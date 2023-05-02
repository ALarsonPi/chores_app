import 'package:flutter/material.dart';

import '../../Services/ChartService.dart';
import '../../Services/ListenService.dart';

// ignore: must_be_immutable
class RoleInfoWidget extends StatelessWidget {
  RoleInfoWidget(this.isEditingCurrUser,
      {required this.index,
      required this.userID,
      required this.contextFromParent,
      required this.pushUserToHomeScreen,
      super.key});
  int index;
  String userID;
  BuildContext contextFromParent;
  bool isEditingCurrUser;
  Function pushUserToHomeScreen;

  handleRoleChange(BuildContext context, String newRole) {
    if (isEditingCurrUser &&
        ChartService().isOnlyOneInChart(
          ListenService.chartsNotifiers.elementAt(index).value,
          userID,
        )) {
      Navigator.pop(contextFromParent);
      // Notify user
      _showNotifyUserThatChangeCannotBeMadeDialog(context);
    } else if (ChartService().isSoleOwner(
      ListenService.chartsNotifiers.elementAt(index).value,
      userID,
    )) {
      Navigator.pop(contextFromParent);
      ChartService().showUserPromotionConfirmDialog(
        context,
        index,
        userID,
        ListenService.chartsNotifiers.elementAt(index).value,
      );
    } else {
      ChartService().addUserToChartWithNewRole(index, userID, newRole);
      Navigator.pop(contextFromParent);
      if (isEditingCurrUser) {
        pushUserToHomeScreen();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: Icon(
            Icons.preview_rounded,
            color: Theme.of(context).colorScheme.primary,
          ),
          iconColor: Theme.of(context).colorScheme.primary,
          title: const Text("Viewer"),
          onTap: () => {
            handleRoleChange(context, "Viewer"),
          },
          subtitle: const Text("Can see chart, but can't change chart"),
        ),
        ListTile(
          leading: Icon(
            Icons.edit_document,
            color: Theme.of(context).colorScheme.primary,
          ),
          iconColor: Theme.of(context).colorScheme.primary,
          title: const Text("Editor"),
          onTap: () => {
            handleRoleChange(context, "Editor"),
          },
          subtitle: const Text("Can edit chart, but can't add other users"),
        ),
        ListTile(
          leading: Icon(
            Icons.add_business_rounded,
            color: Theme.of(context).colorScheme.primary,
          ),
          iconColor: Theme.of(context).colorScheme.primary,
          title: const Text("Owner"),
          onTap: () => {
            // As logic for taking away owner's is not needed when
            // setting someone to owner. And setting someone to owner will
            // never make it so that the chart has no owners, the logic flow
            // for this option is much simpler and streamlined
            ChartService().addUserToChartWithNewRole(index, userID, "Owner"),
            Navigator.pop(contextFromParent),
          },
          subtitle:
              const Text("Can edit chart, add more users, and delete chart"),
        ),
      ],
    );
  }

  Future<void> _showNotifyUserThatChangeCannotBeMadeDialog(
      BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Change cannot be Made'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text(
                    'The Chart must have at least one owner. If you are no longer the owner, nobody can join the chart in the future.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
