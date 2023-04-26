import 'package:flutter/material.dart';

import '../../Models/frozen/UserModel.dart';

// ignore: must_be_immutable
class CustomTileWidget extends StatelessWidget {
  CustomTileWidget({
    super.key,
    required this.user,
    required this.icon,
    required this.color,

    // Just for Requesting Users
    this.showAcceptDialog,

    // Things just for connected users
    this.showRoleDialog,
    this.showDeleteDialog,
    this.subtitle,
  });
  Function? showAcceptDialog;
  Function? showRoleDialog;
  Function? showDeleteDialog;
  UserModel user;
  Icon icon;
  Color color;
  String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 6.0, right: 8.0),
      child: ListTile(
        onTap: () => {
          (subtitle != null)
              ? showRoleDialog!(
                  userModel: user,
                  title: 'Edit User Role',
                )
              : showAcceptDialog!(user),
        },
        title: Text(
          user.name as String,
          textScaleFactor: 1.25,
          style: TextStyle(
            color: Theme.of(context).chipTheme.secondarySelectedColor,
          ),
        ),
        subtitle: (subtitle != null)
            ? Text(
                subtitle as String,
                style: TextStyle(
                  color: Theme.of(context).chipTheme.secondarySelectedColor,
                ),
              )
            : null,
        tileColor: color,
        iconColor: Theme.of(context).chipTheme.secondarySelectedColor,
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            icon,
          ],
        ),
        trailing: (showDeleteDialog == null)
            ? null
            : IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Colors.red[300],
                ),
                onPressed: () {
                  showDeleteDialog!(user);
                },
              ),
      ),
    );
  }
}
