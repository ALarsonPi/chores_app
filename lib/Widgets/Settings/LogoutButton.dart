import 'package:chore_app/Providers/TabNumberProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LogoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => {
        Provider.of<TabNumberProvider>(context, listen: false)
            .changeCurrTabNum(0),
        FirebaseAuth.instance.signOut(),
      },
      child: Text(
        "Logout",
        style: TextStyle(
          color: Theme.of(context).textTheme.headlineMedium?.color,
        ),
      ),
    );
  }
}
