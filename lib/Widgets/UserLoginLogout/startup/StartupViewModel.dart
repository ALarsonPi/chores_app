import 'package:flutter/foundation.dart';
import 'package:stacked/stacked.dart';
import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../FilledStacksLogin/services/navigationService.dart';
import '../FilledStacksLogin/services/userService.dart';

class StartUpViewModel extends BaseViewModel {
  final _userService = locator<UserService>();
  final _navigationService = locator<NavigationService>();

  Future<void> runStartupLogic() async {
    if (_userService.hasLoggedInUser) {
      await _userService.syncUserAccount();
      final currentUser = _userService.currentUser;
      _navigationService.navigateTo(Routes.startUpView);
    } else {
      _navigationService.navigateTo(Routes.loginView);
    }
  }
}
