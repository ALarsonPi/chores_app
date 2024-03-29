import 'dart:io';

import 'package:auth_buttons/auth_buttons.dart';
import 'package:chore_app/Services/FirebaseLogin.dart';
import 'package:chore_app/Widgets/UserLoginLogout/ForgotPassword.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

import 'UI_Helpers.dart';

class LoginRegisterWidget extends StatefulWidget {
  const LoginRegisterWidget({
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
    return _LoginRegisterWidget();
  }
}

class _LoginRegisterWidget extends State<LoginRegisterWidget> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final fullNameController = TextEditingController();

  bool isInLoginMode = true;
  bool isInForgotPasswordMode = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    fullNameController.dispose();
  }

  returnToLoginView() {
    setState(() {
      isInForgotPasswordMode = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return (isInForgotPasswordMode)
        ? ForgotPassword(returnToLoginView)
        : SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 25,
            ),
            child: Column(
              children: [
                verticalSpaceRegular,
                verticalSpaceLarge,
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    (isInLoginMode) ? "Welcome" : "Create Account",
                    style: const TextStyle(fontSize: 34),
                  ),
                ),
                verticalSpaceSmall,
                Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                      width: screenWidthPercentage(context, percentage: 0.75),
                      child: Text(
                        (isInLoginMode)
                            ? "Enter your email address to sign in"
                            : "Enter your name, email, and password to sign up",
                        style: loginMediumGreyBodyTextStyle,
                      )),
                ),
                if (!isInLoginMode) verticalSpaceTiny,
                if (!isInLoginMode)
                  GestureDetector(
                    onTap: () => {
                      setState(
                        () => isInLoginMode = true,
                      ),
                    },
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Already have account?",
                        style: loginMediumGreyBodyTextStyle.copyWith(
                          color: loginPrimaryColor,
                        ),
                      ),
                    ),
                  ),
                verticalSpaceMedium,
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!isInLoginMode)
                        TextFormField(
                          controller: fullNameController,
                          keyboardType: TextInputType.name,
                          autofocus: false,
                          cursorColor: loginPrimaryColor,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0))),
                            labelText: 'Full Name',
                            labelStyle: TextStyle(
                              color: loginMediumGreyColor,
                            ),
                            filled: true,
                            fillColor: Color.fromARGB(255, 241, 241, 242),
                          ),
                        ),
                      (isInLoginMode)
                          ? verticalSpaceSmall
                          : verticalSpaceRegular,
                      TextFormField(
                        controller: emailController,
                        validator: (String? email) {
                          return (email != null &&
                                  !EmailValidator.validate(email))
                              ? 'Invalid Email'
                              : null;
                        },
                        keyboardType: TextInputType.emailAddress,
                        cursorColor: loginPrimaryColor,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(
                            color: loginMediumGreyColor,
                          ),
                          filled: true,
                          fillColor: Color.fromARGB(255, 241, 241, 242),
                        ),
                      ),
                      verticalSpaceRegular,
                      TextFormField(
                        controller: passwordController,
                        validator: (String? password) {
                          return (password != null && !(password.length > 5))
                              ? 'Password must be longer than 5 characters'
                              : null;
                        },
                        obscureText: true,
                        autofocus: false,
                        cursorColor: loginPrimaryColor,
                        textInputAction: TextInputAction.done,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0))),
                          labelText: 'Password',
                          labelStyle: TextStyle(
                            color: loginMediumGreyColor,
                          ),
                          filled: true,
                          fillColor: Color.fromARGB(255, 241, 241, 242),
                        ),
                      ),
                      verticalSpaceTiny,
                      verticalSpaceRegular,
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () => {
                            setState(
                              () => isInForgotPasswordMode = true,
                            ),
                          },
                          child: Text(
                            'Forgot Password',
                            style: loginMediumGreyBodyTextStyle.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      verticalSpaceRegular,
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () => {
                            if (_formKey.currentState!.validate())
                              {
                                (isInLoginMode)
                                    ? FirebaseLogin.login(
                                        emailController.text.trim(),
                                        passwordController.text.trim(),
                                      )
                                    : FirebaseLogin.register(
                                        fullNameController.text.trim(),
                                        emailController.text.trim(),
                                        passwordController.text.trim(),
                                      ),
                              },
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(loginPrimaryColor),
                          ),
                          child: Text(
                            (isInLoginMode) ? "SIGN IN" : "SIGN UP",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      verticalSpaceMedium,
                    ],
                  ),
                ),
                (isInLoginMode)
                    ? GestureDetector(
                        onTap: () => {
                          setState(
                            () => isInLoginMode = false,
                          ),
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account?",
                              style: loginMediumGreyBodyTextStyle,
                            ),
                            horizontalSpaceTiny,
                            Text(
                              'Create an account',
                              style: TextStyle(
                                color: loginPrimaryColor,
                              ),
                            ),
                          ],
                        ),
                      )
                    : const Text(
                        "By signing up you agree to your terms, conditions and Privacy Policy",
                        style: loginMediumGreyBodyTextStyle,
                        textAlign: TextAlign.center,
                      ),
                verticalSpaceMedium,
                const Text(
                  "Or",
                  style: loginDarkGreyBodyTextStyle,
                  textAlign: TextAlign.center,
                ),
                verticalSpaceRegular,
                verticalSpaceTiny,
                if (Platform.isIOS)
                  AppleAuthButton(
                    onPressed: () => {
                      FirebaseLogin.signInWithApple(),
                    },
                    themeMode: ThemeMode.light,
                    text: '   CONTINUE WITH APPLE    ',
                    style: const AuthButtonStyle(
                      buttonColor: Color(0xff000000),
                      iconSize: 24,
                      height: 55,
                      width: double.infinity,
                      textStyle: TextStyle(color: Colors.white),
                      buttonType: AuthButtonType.secondary,
                    ),
                  ),
                if (Platform.isIOS) verticalSpaceRegular,
                FacebookAuthButton(
                  onPressed: () => {
                    FirebaseLogin.signInWithFacebook(),
                  },
                  text: 'CONTINUE WITH FACEBOOK',
                  style: const AuthButtonStyle(
                    buttonColor: Color(0xff395998),
                    iconSize: 24,
                    iconBackground: Colors.white,
                    buttonType: AuthButtonType.secondary,
                    width: double.infinity,
                    height: 55,
                    textStyle: TextStyle(color: Colors.white),
                  ),
                ),
                verticalSpaceRegular,
                GoogleAuthButton(
                  onPressed: () => {
                    FirebaseLogin.signInWithGoogle(),
                  },
                  text: 'CONTINUE WITH GOOGLE',
                  style: const AuthButtonStyle(
                    buttonColor: Color(0xff4285F4),
                    iconSize: 24,
                    iconBackground: Colors.white,
                    buttonType: AuthButtonType.secondary,
                    width: double.infinity,
                    height: 55,
                    textStyle: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          );
  }
}
