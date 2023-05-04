import 'package:chore_app/Daos/UserDao.dart';
import 'package:chore_app/Services/ListenService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../Daos/ChartDao.dart';
import '../../Models/frozen/Chart.dart';
import '../../Models/frozen/UserModel.dart';
import '../../Services/ChartService.dart';

// ignore: must_be_immutable
class GiveOwnershipPopup extends StatefulWidget {
  GiveOwnershipPopup(
      {super.key,
      required this.userIDs,
      required this.currChartID,
      required this.currChart,
      this.index = 0});
  List<String> userIDs;
  int index;
  String currChartID;
  Chart currChart;

  @override
  State<GiveOwnershipPopup> createState() => _GiveOwnershipPopupState();
}

class _GiveOwnershipPopupState extends State<GiveOwnershipPopup> {
  String searchString = "";
  UserModel userToPromote = UserModel.emptyUser;
  String currRadioValue = "";

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "Decide which user \nshould be made OWNER",
                    softWrap: true,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: (userToPromote == UserModel.emptyUser)
                          ? null
                          : () {
                              ChartService().processUserPromotionRequest(
                                userToPromote,
                                ListenService.userNotifier.value,
                                widget.index,
                                widget.currChartID,
                                widget.currChart,
                              );
                              Navigator.of(context, rootNavigator: true).pop();
                            },
                      child: const Text(
                        "Make Owner",
                        style: TextStyle(color: Colors.white),
                      ),
                      // color: const Color(0xFF1BC0C5),
                    ),
                  ),
                ),
              ],
            ),
            FutureBuilder(
              future: UserDao().getBatchOfUserModels(widget.userIDs),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text("");
                }

                int? len = snapshot.data?.length;
                if (len == 0 || len == null) {
                  return Column(
                    children: const [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Text("No charts available",
                            style: TextStyle(fontSize: 20, color: Colors.grey)),
                      )
                    ],
                  );
                }

                List<UserModel> users = snapshot.data as List<UserModel>;
                List<UserModel> matchingUsersByName;
                List<UserModel> matchingUsersByID;
                List<UserModel> filteredUsers = List.empty(growable: true);
                matchingUsersByName = users
                    .where((s) => (s.name as String)
                        .toLowerCase()
                        .contains(searchString.toLowerCase()))
                    .toList();
                matchingUsersByID = users
                    .where((s) =>
                        s.id.toLowerCase().contains(searchString.toLowerCase()))
                    .toList();
                filteredUsers.addAll(matchingUsersByID);
                filteredUsers.addAll(matchingUsersByName);
                filteredUsers = filteredUsers.toSet().toList();

                return Expanded(
                  child: ListView.builder(
                    key: const PageStorageKey<String>("unique_key"),
                    padding: const EdgeInsets.only(bottom: 15),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: false,
                    itemCount: filteredUsers.length,
                    itemBuilder: (context, index) {
                      String fullID = filteredUsers[index].id;
                      String subID = fullID.substring(0, 8);
                      return GestureDetector(
                        onTap: () => {
                          setState(
                            () => {
                              currRadioValue = subID,
                              userToPromote = filteredUsers[index],
                            },
                          )
                        },
                        child: ListTile(
                          leading: Radio<String>(
                            value: currRadioValue,
                            groupValue: subID,
                            onChanged: (value) => {
                              setState(
                                () => {
                                  currRadioValue = subID,
                                  userToPromote = filteredUsers[index],
                                },
                              )
                            },
                          ),
                          title: Text(filteredUsers[index].name as String),
                          subtitle: Text(
                            filteredUsers[index].id.substring(0, 8),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
