import 'package:chore_app/Daos/UserDao.dart';
import 'package:chore_app/Models/frozen/UserModel.dart';
import 'package:chore_app/Screens/widgets/customTileWidget.dart';
import 'package:chore_app/Screens/widgets/roleInfoWidget.dart';
import 'package:chore_app/Services/ChartService.dart';
import 'package:chore_app/Services/ListenService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Models/frozen/Chart.dart';
import 'ScreenArguments/connectedUserArguments.dart';

class ConnectedUsersScreen extends StatefulWidget {
  const ConnectedUsersScreen({super.key});
  static const routeName = "/connectedUsersExtraction";

  @override
  State<ConnectedUsersScreen> createState() => _ConnectedUsersScreenState();
}

class _ConnectedUsersScreenState extends State<ConnectedUsersScreen> {
  late final args =
      ModalRoute.of(context)!.settings.arguments as ConnectedUserArguments;

  List<UserModel> requestingUsers = List.empty(growable: true);
  List<UserModel> connectedUsers = List.empty(growable: true);

  Future<void> _showAssignUserRoleDialog({
    required UserModel userModel,
    required String title,
  }) async {
    bool isChangingCurrUser = false;
    if (userModel.id == FirebaseAuth.instance.currentUser?.uid as String) {
      isChangingCurrUser = await _showChangeCurrUserConfirmDialog();
      if (isChangingCurrUser == false) return;
    }
    // ignore: use_build_context_synchronously
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('What role should ${userModel.name} have?'),
                RoleInfoWidget(
                  isChangingCurrUser,
                  pushUserToHomeScreen: pushUserToHomeScreen,
                  index: args.index,
                  userID: userModel.id,
                  contextFromParent: context,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Theme.of(context).chipTheme.selectedShadowColor,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> _showAcceptUserDialog(UserModel userModel) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Accept New User'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'Would you like to accept ${userModel.name} to the chart?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Theme.of(context).chipTheme.selectedShadowColor,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Approve'),
              onPressed: () {
                Navigator.of(context).pop();
                _showAssignUserRoleDialog(
                  userModel: userModel,
                  title: 'Assign User Role',
                );
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool> _showChangeCurrUserConfirmDialog() async {
    bool answerChosen = false;
    await showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Role on Chart'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text(
                    'You are about to look at other role options for your own profile. Are you sure you want to change your role on the chart?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Theme.of(context).chipTheme.selectedShadowColor,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Yes, I'm sure"),
              onPressed: () {
                answerChosen = true;
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
    return answerChosen;
  }

  Future<void> _showDeleteUserDialog(UserModel userModel) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Remove User from Chart'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'Would you like to remove ${userModel.name} from the chart?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Theme.of(context).chipTheme.selectedShadowColor,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Remove'),
              onPressed: () {
                ChartService().setUserRoleForChart(
                  "Remove",
                  userModel.id,
                  ListenService.chartsNotifiers.elementAt(args.index).value,
                  false,
                  args.index,
                  ListenService.chartsNotifiers.elementAt(args.index).value.id,
                );
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  getUserRole(UserModel user) {
    Chart currChart = ListenService.chartsNotifiers.elementAt(args.index).value;
    if (currChart.ownerIDs.contains(user.id)) {
      return "Owner";
    } else if (currChart.editorIDs.contains(user.id)) {
      return "Editor";
    } else if (currChart.viewerIDs.contains(user.id)) {
      return "Viewer";
    } else {
      return "User";
    }
  }

  List<String> getRequestingUsers(Chart chart) {
    return chart.pendingIDs;
  }

  List<String> getConnectedUsers(Chart chart) {
    List<String> connectedUserIDs = List.empty(growable: true);
    connectedUserIDs.addAll(chart.ownerIDs);
    connectedUserIDs.addAll(chart.editorIDs);
    connectedUserIDs.addAll(chart.viewerIDs);
    return connectedUserIDs;
  }

  Future<List<UserModel>> getBatchOfUsers(List<String> ids) async {
    return await UserDao().getBatchOfUserModels(ids);
  }

  pushUserToHomeScreen() {
    Navigator.pushNamed(context, 'home');
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      builder: (context, chart, child) {
        List<String> requestingUserIDs = getRequestingUsers(chart);
        List<String> connectedUserIDs = getConnectedUsers(chart);

        // If there are some Users to fetch
        // and they haven't been fetched yet, fetch them
        if (requestingUserIDs.isNotEmpty &&
            requestingUsers.length != requestingUserIDs.length) {
          getBatchOfUsers(requestingUserIDs).then((listOfUsers) => {
                setState(() => requestingUsers = listOfUsers),
              });
        } else if (requestingUserIDs.isEmpty) {
          requestingUsers = [];
        }
        if (connectedUserIDs.isNotEmpty &&
            connectedUsers.length != connectedUserIDs.length) {
          getBatchOfUsers(connectedUserIDs).then((listOfUsers) => {
                setState(() => connectedUsers = listOfUsers),
              });
        } else if (connectedUserIDs.isEmpty) {
          connectedUsers = [];
        }

        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: true,
            title: Text(chart.chartTitle),
            centerTitle: true,
          ),
          body: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            children: [
              const SizedBox(height: 30),
              Text(
                "Users Requesting Access (${requestingUsers.length})",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.headlineLarge?.fontSize,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: requestingUsers.length,
                itemBuilder: (BuildContext context, int index) {
                  return CustomTileWidget(
                    user: requestingUsers[index],
                    icon: const Icon(Icons.add),
                    color: const Color(0xffffcccb),
                    showAcceptDialog: _showAcceptUserDialog,
                    showDeleteDialog: _showDeleteUserDialog,
                  );
                },
              ),
              const SizedBox(height: 30),
              Text(
                "Connected Users (${connectedUsers.length})",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.headlineLarge?.fontSize,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: connectedUsers.length,
                itemBuilder: (BuildContext context, int index) {
                  return CustomTileWidget(
                    user: connectedUsers[index],
                    icon: const Icon(Icons.view_array_sharp),
                    color: const Color(0xffe4f2fd),
                    subtitle: getUserRole(connectedUsers[index]),
                    showRoleDialog: _showAssignUserRoleDialog,
                    showDeleteDialog: _showDeleteUserDialog,
                  );
                },
              ),
            ],
          ),
        );
      },
      valueListenable: ListenService.chartsNotifiers.elementAt(args.index),
    );
  }
}
