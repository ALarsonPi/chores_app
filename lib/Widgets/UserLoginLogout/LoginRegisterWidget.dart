import 'dart:io';

import 'package:auth_buttons/auth_buttons.dart';
import 'package:chore_app/Daos/FirebaseDao.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../shared/UI_Helpers.dart';

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

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    fullNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                  () => {isInLoginMode = true},
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
          if (!isInLoginMode)
            TextFormField(
              controller: fullNameController,
              keyboardType: TextInputType.name,
              autofocus: false,
              cursorColor: loginPrimaryColor,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0))),
                labelText: 'Full Name',
                labelStyle: TextStyle(
                  color: loginMediumGreyColor,
                ),
                filled: true,
                fillColor: Color.fromARGB(255, 241, 241, 242),
              ),
            ),
          (isInLoginMode) ? verticalSpaceSmall : verticalSpaceRegular,
          TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            autofocus: false,
            cursorColor: loginPrimaryColor,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0))),
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
            obscureText: true,
            autofocus: false,
            cursorColor: loginPrimaryColor,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0))),
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
              onTap: () => {},
              child: Text(
                'Forgot Password',
                style: loginMediumGreyBodyTextStyle.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          verticalSpaceRegular,
          GestureDetector(
            onTap: () => {
              (isInLoginMode) ? signIn() : register(),
            },
            child: Container(
              width: double.infinity,
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: loginPrimaryColor,
                borderRadius: BorderRadius.circular(8),
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
          (isInLoginMode)
              ? GestureDetector(
                  onTap: () => {
                    setState(
                      () => {
                        isInLoginMode = false,
                      },
                    ),
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
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
          FacebookAuthButton(
            onPressed: () => {},
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
          if (Platform.isIOS) verticalSpaceRegular,
          if (Platform.isIOS)
            AppleAuthButton(
              onPressed: () => {},
              // darkMode: true,
              text: 'CONTINUE WITH APPLE',
              style: const AuthButtonStyle(
                iconSize: 24,
                height: 55,
                textStyle: TextStyle(color: Colors.white),
                buttonType: AuthButtonType.secondary,
                buttonColor: loginPrimaryColor,
              ),
            ),
          verticalSpaceRegular,
          GoogleAuthButton(
            onPressed: () => {},
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

  signIn() {
    FirebaseDao.signIn(
      emailController.text.trim(),
      passwordController.text.trim(),
    );
  }

  register() {
    FirebaseDao.register(
      fullNameController.text.trim(),
      emailController.text.trim(),
      passwordController.text.trim(),
    );
  }
}
