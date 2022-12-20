import 'package:chore_app/Widgets/UserLoginLogout/FilledStacksLogin/base/AuthenticationViewModel.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_firebase_auth/stacked_firebase_auth.dart';

import '../../../../app/app.locator.dart';
import '../../../../app/app.router.dart';
import '../services/navigationService.dart';
import 'LoginView.form.dart';

class LoginViewModel extends AuthenticationViewModel {
  LoginViewModel() : super(successRoute: Routes.addressSelectionView);

  final _firebaseAuthenticationService =
      locator<FirebaseAuthenticationService>();
  final _navigationService = locator<NavigationService>();

  @override
  Future<FirebaseAuthenticationResult> runAuthentication() =>
      _firebaseAuthenticationService.loginWithEmail(
        email: emailValue!,
        password: passwordValue!,
      );

  void navigateToCreateAccount() =>
      _navigationService.navigateTo(Routes.createAccountView);
}
