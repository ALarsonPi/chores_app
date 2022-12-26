import 'package:flutter/material.dart';

InputDecorationTheme getSubtleUnderlineTheme(BuildContext context) {
  return InputDecorationTheme(
    enabledBorder: const UnderlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(5)),
      borderSide: BorderSide(
        width: 1,
        color: Color.fromARGB(255, 231, 231, 231),
      ),
    ),
    focusedBorder: UnderlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(5)),
      borderSide: BorderSide(
        width: 1,
        color: Theme.of(context).primaryColor,
      ),
    ),
    errorBorder: const UnderlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(5)),
      borderSide: BorderSide(
        width: 1,
        color: Colors.red,
      ),
    ),
  );
}
