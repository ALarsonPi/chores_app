import 'package:flutter/material.dart';

class ContactCreatorButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () => {},
        child: Text(
          "Contact App Creator",
          style: TextStyle(
            fontSize: Theme.of(context).textTheme.displayLarge?.fontSize,
            color: Theme.of(context).primaryColor,
            //const Color(0xFF0000EE),
          ),
        ));
  }
}
