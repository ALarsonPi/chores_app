import 'package:chore_app/Services/Notifications/NotificationRegistrationService.dart';
import 'package:flutter/material.dart';

import '../Config.dart';

class NotificationRegistrationScreen extends StatefulWidget {
  const NotificationRegistrationScreen({super.key});

  @override
  State<NotificationRegistrationScreen> createState() =>
      _NotificationRegistrationScreenState();
}

class _NotificationRegistrationScreenState
    extends State<NotificationRegistrationScreen> {
  final notificationRegistrationService =
      NotificationRegistrationService(Config.backendServiceEndpoint);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ElevatedButton(
              onPressed: registerButtonClicked,
              child: const Text("Register"),
            ),
            ElevatedButton(
              onPressed: deregisterButtonClicked,
              child: const Text("Deregister"),
            ),
          ],
        ),
      ),
    );
  }

  void registerButtonClicked() async {
    try {
      await notificationRegistrationService
          .registerDevice(List.empty(growable: true));
      await showAlert(message: "Device registered");
    } catch (e) {
      await showAlert(message: e);
    }
  }

  void deregisterButtonClicked() async {
    try {
      await notificationRegistrationService.deregisterDevice();
      await showAlert(message: "Device deregistered");
    } catch (e) {
      await showAlert(message: e);
    }
  }

  Future<void> showAlert({message: String}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Notification Demo'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
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
