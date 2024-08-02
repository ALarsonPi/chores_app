import 'package:chore_app/Models/Notifications/PushNotificationAction.dart';
import 'package:flutter/services.dart';
import 'dart:async';

class NotificationActionService {
  static const notificationAction =
      MethodChannel('com.creator.chore_app/notificationaction');
  static const String triggerActionChannelMethod = "triggerAction";
  static const String getLaunchActionChannelMethod = "getLaunchAction";

  final actionMappings = {
    'action_a': PushNotificationAction.actionA,
    'action_b': PushNotificationAction.actionB
  };

  final actionTriggeredController = StreamController.broadcast();

  NotificationActionService() {
    notificationAction.setMethodCallHandler(handleNotificationActionCall);
  }

  Stream get actionTriggered => actionTriggeredController.stream;

  Future<void> triggerAction({action = String}) async {
    if (!actionMappings.containsKey(action)) {
      return;
    }

    actionTriggeredController.add(actionMappings[action]);
  }

  Future<void> checkLaunchAction() async {
    final launchAction = await notificationAction
        .invokeMethod(getLaunchActionChannelMethod) as String?;

    if (launchAction != null) {
      triggerAction(action: launchAction);
    }
  }

  Future<void> handleNotificationActionCall(MethodCall call) async {
    switch (call.method) {
      case triggerActionChannelMethod:
        return triggerAction(action: call.arguments as String);
      default:
        throw MissingPluginException();
    }
  }
}
