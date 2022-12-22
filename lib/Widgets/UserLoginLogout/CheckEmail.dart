import 'package:flutter/material.dart';

import '../../shared/UI_Helpers.dart';

class CheckEmail extends StatelessWidget {
  Function returnToLogin;
  Function returnToForgotPassword;
  CheckEmail(this.returnToLogin, this.returnToForgotPassword, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        verticalSpaceLarge,
        verticalSpaceMedium,
        const Padding(
          padding: EdgeInsets.only(bottom: 8.0),
          child: Text(
            "Check Email",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
          child: Text(
            "We have sent password reset instructions to your email.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ),
        // Padding(
        //   padding: const EdgeInsets.only(top: 8.0),
        //   child: GestureDetector(
        //     onTap: () => {
        //       returnToLogin(),
        //     },
        //     child: Align(
        //       alignment: Alignment.center,
        //       child: Text(
        //         "Return to Login",
        //         style: loginMediumGreyBodyTextStyle.copyWith(
        //           color: loginPrimaryColor,
        //         ),
        //       ),
        //     ),
        //   ),
        // ),

        verticalSpaceMedium,
        Image.asset("assets/images/mailboxTransparent.png"),
        verticalSpaceMedium,
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Didn't get the email? Check spam folder, or "),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: GestureDetector(
                onTap: () => {
                  returnToForgotPassword(),
                },
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "try another email address",
                    style: loginMediumGreyBodyTextStyle.copyWith(
                      color: loginPrimaryColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
