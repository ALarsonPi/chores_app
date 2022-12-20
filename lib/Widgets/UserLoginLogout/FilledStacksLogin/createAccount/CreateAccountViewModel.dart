import 'package:chore_app/Widgets/UserLoginLogout/FilledStacksLogin/base/AuthenticationViewModel.dart';
import 'package:stacked_firebase_auth/stacked_firebase_auth.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../../app/app.locator.dart';
import '../../../../app/app.router.dart';
import 'CreateAccountView.form.dart';

class CreateAccountViewModel extends AuthenticationViewModel {
  CreateAccountViewModel() : super(successRoute: Routes.addressSelectionView);

  final _firebaseAuthenticationService =
      locator<FirebaseAuthenticationService>();
  final _navigationService = locator<NavigationService>();

  @override
  Future<FirebaseAuthenticationResult> runAuthentication() =>
      _firebaseAuthenticationService.createAccountWithEmail(
        email: emailValue!,
        password: passwordValue!,
      );

  void navigateBack() => _navigationService.back();
}
