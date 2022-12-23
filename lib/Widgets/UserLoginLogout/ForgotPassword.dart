import 'package:chore_app/Providers/CurrUserProvider.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'UI_Helpers.dart';
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

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    bool didResetCorrectly = false;
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: forgotPasswordPrimaryColor,
            ),
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
            : ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: MediaQuery.of(context).size.width * 0.5,
                    child: Image.asset("assets/images/forgotPassword.png"),
                  ),
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
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: TextFormField(
                            controller: emailController,
                            validator: (String? email) {
                              return (email != null &&
                                      !EmailValidator.validate(email))
                                  ? 'Invalid Email'
                                  : null;
                            },
                            keyboardType: TextInputType.emailAddress,
                            autofocus: false,
                            cursorColor: forgotPasswordPrimaryColor,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  width: 1,
                                  color: Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  width: 2,
                                  color: forgotPasswordPrimaryColor,
                                ),
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  width: 2,
                                  color: Colors.redAccent,
                                ),
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                              filled: true,
                              fillColor:
                                  const Color.fromARGB(255, 241, 241, 242),
                            ),
                          ),
                        ),
                        verticalSpaceMedium,
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () async => {
                              if (_formKey.currentState!.validate())
                                {
                                  didResetCorrectly =
                                      await Provider.of<CurrUserProvider>(
                                              context,
                                              listen: false)
                                          .passwordReset(
                                              emailController.text.trim()),
                                  setState(() => {
                                        isEmailSent = didResetCorrectly,
                                      }),
                                },
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: forgotPasswordPrimaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                )),
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
                        verticalSpaceRegular,
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
