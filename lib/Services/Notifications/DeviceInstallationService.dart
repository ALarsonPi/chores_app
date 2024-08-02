import 'package:flutter/services.dart';

class DeviceInstallationService {
  static const deviceInstallation =
      MethodChannel('com.creator.chore_app/deviceinstallation');
  static const String getDeviceIdChannelMethod = "getDeviceId";
  static const String getDeviceTokenChannelMethod = "getDeviceToken";
  static const String getDevicePlatformChannelMethod = "getDevicePlatform";

  Future<dynamic> getDeviceId() {
    return deviceInstallation.invokeMethod(getDeviceIdChannelMethod);
  }

  Future<dynamic> getDeviceToken() {
    return deviceInstallation.invokeMethod(getDeviceTokenChannelMethod);
  }

  Future<dynamic> getDevicePlatform() {
    return deviceInstallation.invokeMethod(getDevicePlatformChannelMethod);
  }
}
