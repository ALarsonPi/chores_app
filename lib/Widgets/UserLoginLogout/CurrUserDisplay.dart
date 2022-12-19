import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CurrUserDisplay extends StatelessWidget {
  const CurrUserDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return ListView(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      children: [
        Text(
          "Signed in as",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: Theme.of(context).textTheme.displayLarge?.fontSize,
            color: Theme.of(context).textTheme.displayMedium?.color,
          ),
        ),
        Text(
          user.email!,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: Theme.of(context).textTheme.displayLarge?.fontSize,
            color: Theme.of(context).textTheme.displayMedium?.color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
