import 'package:flutter/material.dart';

import '../../shared/UI_Helpers.dart';
import 'CheckEmail.dart';

class ForgotPassword extends StatefulWidget {
  Function setStateBackToLoginScreen;
  ForgotPassword(this.setStateBackToLoginScreen, {super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final emailController = TextEditingController();

  bool isEmailSent = false;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
  }

  returnToForgotPasswordScreen() {
    setState(() {
      isEmailSent = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => widget.setStateBackToLoginScreen(),
          ),
        ),
        automaticallyImplyLeading: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "",
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          left: 32.0,
          right: 32.0,
        ),
        child: (isEmailSent)
            ? CheckEmail(
                widget.setStateBackToLoginScreen,
                returnToForgotPasswordScreen,
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  verticalSpaceLarge,
                  verticalSpaceLarge,
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      "Recover Password",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                    child: Text(
                      "Enter the email associated with your account and we'll send an email with instructions to reset your password.",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  verticalSpaceMedium,
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      autofocus: false,
                      cursorColor: loginPrimaryColor,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0))),
                        labelText: 'Email Address',
                        labelStyle: TextStyle(
                          color: loginMediumGreyColor,
                        ),
                        filled: true,
                        fillColor: Color.fromARGB(255, 241, 241, 242),
                      ),
                    ),
                  ),
                  verticalSpaceLarge,
                  verticalSpaceSmall,
                  Padding(
                    padding: const EdgeInsets.only(top: 32.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () => {
                          setState(() => {
                                isEmailSent = true,
                              }),
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(loginPrimaryColor),
                        ),
                        child: const Text(
                          "Send Instructions",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                  verticalSpaceRegular,
                ],
              ),
      ),
    );
  }
}
