import 'package:stacked/stacked.dart';
import 'package:stacked_firebase_auth/stacked_firebase_auth.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../../app/app.locator.dart';

abstract class AuthenticationViewModel extends FormViewModel {
  AuthenticationViewModel({required this.successRoute});
  final _navigationService = locator<NavigationService>();
  final String successRoute;

  @override
  void setFormStatus() {}

  Future saveData() async {
    final result = await runBusyFuture(runAuthentication());

    if (!result.hasError) {
      _navigationService.navigateTo(successRoute);
    } else {
      setValidationMessage(result.errorMessage);
    }
  }

  Future<FirebaseAuthenticationResult> runAuthentication();
}
