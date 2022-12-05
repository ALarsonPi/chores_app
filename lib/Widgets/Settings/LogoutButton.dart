import 'package:flutter/material.dart';

class LogoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => {},
      child: Text(
        "Logout",
        style: TextStyle(
          color: Theme.of(context).textTheme.headlineMedium?.color,
        ),
      ),
    );
  }
}
