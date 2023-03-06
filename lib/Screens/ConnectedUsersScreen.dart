import 'package:chore_app/Models/frozen/UserModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import '../Daos/ChartDao.dart';
import '../Global.dart';
import '../Providers/TextSizeProvider.dart';
import '../Services/UserManager.dart';
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

  @override
  void initState() {
    super.initState();

    // Create a listener pointing to this currentChart (ID sent in in args)
    // and listens to see if any changes are made to this chart
    // and if any of those changes affect any of these Lists
    // [pending, viewers, editors, owners] it will
    // setState and rebuild based on the new data

    // Changes would be made in ChartDao? or here?
    // Or maybe just Listen to the Provider?
  }

  Future<void> _showEditUserDialog(String userID) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit User Title'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('This is a demo alert dialog.'),
                Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Viewer'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Editor'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Owner'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showAcceptUserDialog(String userID) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('AlertDialog Title'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('This is a demo alert dialog.'),
                Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Approve'),
              onPressed: () {
                Navigator.of(context).pop();
                _showEditUserDialog(userID);
              },
            ),
          ],
        );
      },
    );
  }

  Widget makeCustomTile({
    required String title,
    required Icon icon,
    required Color color,
    required String userID,
    String? subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 6.0, right: 8.0),
      child: ListTile(
        onTap: () => {
          _showAcceptUserDialog(userID),
        },
        title: Text(
          title,
          textScaleFactor: 1.25,
        ),
        subtitle: (subtitle != null) ? Text(subtitle) : null,
        tileColor: color,
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            icon,
          ],
        ),
      ),
    );
  }

  getUserRole(UserModel user) {
    if (args.chartData.ownerIDs.contains(user.id)) {
      return "Owner";
    } else if (args.chartData.editorIDs.contains(user.id)) {
      return "Editor";
    } else if (args.chartData.viewerIDs.contains(user.id)) {
      return "Viewer";
    } else {
      return "User";
    }
  }

  @override
  Widget build(BuildContext context) {
    UserModel user1 =
        UserModel.emptyUser.copyWith(id: "123", name: "Jeff Bezos");
    UserModel user2 =
        UserModel.emptyUser.copyWith(id: "124", name: "Dr. Frankenstein");
    UserModel user3 =
        UserModel.emptyUser.copyWith(id: "125", name: "James Peach");
    UserModel user4 =
        UserModel.emptyUser.copyWith(id: "126", name: "Chad Viewer");
    UserModel user5 =
        UserModel.emptyUser.copyWith(id: "127", name: "Stephen Einstein");
    UserModel user6 =
        UserModel.emptyUser.copyWith(id: "128", name: "James Veitch");

    List<UserModel> requestingUsers = List.empty(growable: true);
    requestingUsers.add(user1);
    requestingUsers.add(user2);
    requestingUsers.add(user3);

    List<UserModel> connectedUsers = List.empty(growable: true);
    connectedUsers.add(user4);
    connectedUsers.add(user5);
    connectedUsers.add(user6);
    connectedUsers.add(Global.getIt.get<UserManager>().currUser.value);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(args.chartData.chartTitle),
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
              return makeCustomTile(
                title: requestingUsers[index].name as String,
                icon: const Icon(Icons.add),
                color: const Color(0xffffcccb),
                userID: requestingUsers[index].id,
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
              return makeCustomTile(
                title: connectedUsers[index].name as String,
                subtitle: getUserRole(connectedUsers[index]),
                icon: const Icon(Icons.view_array_sharp),
                color: const Color(0xffe4f2fd),
                userID: connectedUsers[index].id,
              );
            },
          ),
        ],
      ),
    );
  }
}
