import 'dart:io';

import 'package:auth_buttons/auth_buttons.dart';
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
                  style: ktsMediumGreyBodyText,
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
                  style: ktsMediumGreyBodyText.copyWith(
                    color: kcPrimaryColor,
                  ),
                ),
              ),
            ),
          verticalSpaceSmall,
          if (!isInLoginMode)
            TextField(
              controller: fullNameController,
              cursorColor: Colors.white,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(labelText: 'Full Name'),
            ),
          verticalSpaceSmall,
          TextField(
            controller: emailController,
            cursorColor: Colors.white,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          verticalSpaceTiny,
          TextField(
            controller: passwordController,
            cursorColor: Colors.white,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(labelText: 'Password'),
          ),
          verticalSpaceTiny,
          verticalSpaceRegular,
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () => {},
              child: Text(
                'Forgot Password',
                style: ktsMediumGreyBodyText.copyWith(
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
                color: kcPrimaryColor,
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
                        style: ktsMediumGreyBodyText,
                      ),
                      horizontalSpaceTiny,
                      Text(
                        'Create an account',
                        style: TextStyle(
                          color: kcPrimaryColor,
                        ),
                      ),
                    ],
                  ),
                )
              : const Text(
                  "By signing up you agree to your terms, conditions and Privacy Policy",
                  style: ktsMediumGreyBodyText,
                  textAlign: TextAlign.center,
                ),
          verticalSpaceMedium,
          const Text(
            "Or",
            style: ktsDarkGreyBodyText,
            textAlign: TextAlign.center,
          ),
          verticalSpaceRegular,
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
                buttonColor: kcPrimaryColor,
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

  Future signIn() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );
  }

  Future register() async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );
  }
}
