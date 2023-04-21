import 'package:chore_app/Services/ListenService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../Daos/ChartDao.dart';
import '../../Models/frozen/Chart.dart';
import '../../Services/ChartService.dart';

class JoinChartPopupContent extends StatefulWidget {
  const JoinChartPopupContent({super.key});

  @override
  State<JoinChartPopupContent> createState() => _JoinChartPopupContentState();
}

class _JoinChartPopupContentState extends State<JoinChartPopupContent> {
  String searchString = "";
  Chart chartToJoin = Chart.emptyChart;
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
            TextField(
              autofocus: true,
              onChanged: (String value) => {
                setState(
                  () => {
                    searchString = value,
                  },
                ),
              },
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search by chart title or ID'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Colors.white),
                      ),
                      // color: const Color(0xFF1BC0C5),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: (chartToJoin == Chart.emptyChart)
                          ? null
                          : () {
                              ChartService().processChartJoinRequest(
                                chartToJoin,
                                ListenService.userNotifier.value,
                              );
                              Navigator.of(context, rootNavigator: true).pop();
                            },
                      child: const Text(
                        "Join",
                        style: TextStyle(color: Colors.white),
                      ),
                      // color: const Color(0xFF1BC0C5),
                    ),
                  ),
                ),
              ],
            ),
            StreamBuilder(
              stream: ChartDao.getChartStreamFromFirestore(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text("");
                }

                int? len = snapshot.data?.docs.length;
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

                List<Chart> charts = snapshot.data!.docs
                    .map((doc) => Chart.fromSnapshot(doc))
                    .toList();
                List<Chart> matchingChartsByTitle;
                List<Chart> matchingChartsByID;
                List<Chart> filteredCharts = List.empty(growable: true);
                matchingChartsByTitle = charts
                    .where((s) => s.chartTitle
                        .toLowerCase()
                        .contains(searchString.toLowerCase()))
                    .toList();
                matchingChartsByID = charts
                    .where((s) =>
                        s.id.toLowerCase().contains(searchString.toLowerCase()))
                    .toList();
                filteredCharts.addAll(matchingChartsByID);
                filteredCharts.addAll(matchingChartsByTitle);
                filteredCharts = filteredCharts.toSet().toList();

                return Expanded(
                  child: ListView.builder(
                    key: const PageStorageKey<String>("unique_key"),
                    padding: const EdgeInsets.only(bottom: 15),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: false,
                    itemCount: filteredCharts.length,
                    itemBuilder: (context, index) {
                      String fullID = filteredCharts[index].id;
                      String subID = fullID.substring(0, 8);
                      return GestureDetector(
                        onTap: () => {
                          setState(
                            () => {
                              currRadioValue = subID,
                              chartToJoin = filteredCharts[index],
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
                                  chartToJoin = filteredCharts[index],
                                },
                              )
                            },
                          ),
                          title: Text(filteredCharts[index].chartTitle),
                          subtitle: Text(
                            filteredCharts[index].id.substring(0, 8),
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
