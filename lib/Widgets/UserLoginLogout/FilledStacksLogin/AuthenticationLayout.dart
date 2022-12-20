import 'package:flutter/material.dart';

import 'shared/UI_Helpers.dart';

class AuthenticationLayout extends StatelessWidget {
  final String title;
  final String subtitle;
  final Function onMainButtonTapped;
  final Widget form;

  final Function? onCreateAccountTapped;
  final Function? onForgetPasswordTapped;
  final Function? onBackPressed;
  final String? validationMessage;

  final String mainButtonTitle;
  final bool showTermsText;
  final bool busy;

  const AuthenticationLayout({
    required this.title,
    required this.subtitle,
    required this.form,
    required this.onMainButtonTapped,
    this.validationMessage,
    this.onCreateAccountTapped,
    this.onForgetPasswordTapped,
    this.onBackPressed,
    this.mainButtonTitle = 'CONTINUE',
    this.showTermsText = false,
    this.busy = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 25,
      ),
      child: ListView(
        children: [
          if (onBackPressed == null) verticalSpaceLarge,
          if (onBackPressed != null) verticalSpaceRegular,
          if (onBackPressed != null)
            IconButton(
              padding: EdgeInsets.zero,
              alignment: Alignment.centerLeft,
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
              onPressed: () => onBackPressed,
            ),
          Text(
            title,
            style: const TextStyle(fontSize: 34),
          ),
          verticalSpaceSmall,
          SizedBox(
              width: screenWidthPercentage(context, percentage: 0.7),
              child: Text(
                subtitle,
                style: ktsMediumGreyBodyText,
              )),
          verticalSpaceRegular,
          form,
          verticalSpaceRegular,
          if (onForgetPasswordTapped != null)
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () => onForgetPasswordTapped,
                child: Text('Forgot Password',
                    style: ktsMediumGreyBodyText.copyWith(
                      fontWeight: FontWeight.bold,
                    )),
              ),
            ),
          verticalSpaceRegular,
          if (validationMessage != null)
            Text(
              validationMessage as String,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 16,
              ),
            ),
          if (validationMessage != null) verticalSpaceRegular,
          GestureDetector(
            onTap: () => onMainButtonTapped,
            child: Container(
              width: double.infinity,
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: kcPrimaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: busy
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(
                        Colors.white,
                      ),
                    )
                  : Text(
                      mainButtonTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
            ),
          ),
          if (onCreateAccountTapped != null)
            GestureDetector(
              onTap: () => onCreateAccountTapped,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text("Don\'t have an account?"),
                  horizontalSpaceTiny,
                  Text(
                    'Create an account',
                    style: TextStyle(
                      color: kcPrimaryColor,
                    ),
                  ),
                ],
              ),
            ),
          if (showTermsText)
            const Text(
              "By signing up you agree to your terms, conditions and Privacy Policy",
              style: ktsMediumGreyBodyText,
              textAlign: TextAlign.center,
            )
        ],
      ),
    );
  }
}
