import 'package:flutter_device_type/flutter_device_type.dart';

class Global {
  static bool isPhone = Device.get().isPhone;
  static bool isHighPixelRatio = (Device.devicePixelRatio > 2);
  static double toolbarHeight = (isPhone) ? 65.0 : 85.0;
}
