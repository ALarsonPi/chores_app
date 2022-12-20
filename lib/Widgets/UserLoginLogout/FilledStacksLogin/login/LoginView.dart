import 'package:chore_app/Widgets/UserLoginLogout/FilledStacksLogin/AuthenticationLayout.dart';
import 'package:chore_app/Widgets/UserLoginLogout/FilledStacksLogin/login/LoginView.form.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';
import 'LoginViewModel.dart';

@FormView(
  fields: [
    FormTextField(name: 'email'),
    FormTextField(name: 'password'),
  ],
)
class LoginView extends StatelessWidget with $LoginView {
  LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.reactive(
      onModelReady: (model) => listenToFormUpdated(model),
      builder: (context, model, child) => Scaffold(
        body: AuthenticationLayout(
          busy: model.isBusy,
          onCreateAccountTapped: model.navigateToCreateAccount,
          onMainButtonTapped: () => model.saveData(),
          validationMessage: model.validationMessage,
          title: 'Welcome',
          subtitle: 'Enter your email address to sign in. Happy charting',
          mainButtonTitle: 'SIGN IN',
          form: Column(
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Email'),
                controller: emailController,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Password'),
                controller: passwordController,
              ),
            ],
          ),
          onForgetPasswordTapped: () {},
        ),
      ),
      viewModelBuilder: () => LoginViewModel(),
    );
  }
}
