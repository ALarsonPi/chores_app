import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Providers/TextSizeProvider.dart';

class ContactCreatorButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () => {},
        child: Text(
          "Contact App Creator",
          style: TextStyle(
            fontSize:
                (Theme.of(context).textTheme.displayLarge?.fontSize as double) +
                    Provider.of<TextSizeProvider>(context, listen: true)
                        .fontSizeToAdd,
            color: Theme.of(context).primaryColor,
            //const Color(0xFF0000EE),
          ),
        ));
  }
}
