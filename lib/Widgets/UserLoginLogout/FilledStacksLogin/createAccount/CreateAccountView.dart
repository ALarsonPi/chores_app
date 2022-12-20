import 'package:chore_app/Widgets/UserLoginLogout/FilledStacksLogin/AuthenticationLayout.dart';
import 'package:chore_app/Widgets/UserLoginLogout/FilledStacksLogin/createAccount/CreateAccountView.form.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';

import 'CreateAccountViewModel.dart';

@FormView(fields: [
  FormTextField(name: 'fullName'),
  FormTextField(name: 'email'),
  FormTextField(name: 'password'),
])
class CreateAccountView extends StatelessWidget with $CreateAccountView {
  CreateAccountView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CreateAccountViewModel>.reactive(
      onModelReady: (model) => listenToFormUpdated(model),
      builder: (context, model, child) => Scaffold(
        body: AuthenticationLayout(
          busy: model.isBusy,
          onBackPressed: () => model.navigateBack,
          onMainButtonTapped: () => model.saveData(),
          validationMessage: model.validationMessage,
          title: 'Create Account',
          subtitle: 'Enter your name, email, and password to sign-up',
          mainButtonTitle: 'SIGN UP',
          form: Column(
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Full Name'),
                controller: fullNameController,
              ),
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
          showTermsText: true,
        ),
      ),
      viewModelBuilder: () => CreateAccountViewModel(),
    );
  }
}
