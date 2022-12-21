import 'package:chore_app/Providers/CurrUserProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CurrUserDisplay extends StatelessWidget {
  const CurrUserDisplay({super.key});

  @override
  Widget build(BuildContext context) {
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
        if ((Provider.of<CurrUserProvider>(context, listen: true)
                .currUser
                .name !=
            null))
          Text(
            Provider.of<CurrUserProvider>(context, listen: true)
                    .currUser
                    .name ??
                "No name",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.displayLarge?.fontSize,
              color: Theme.of(context).textTheme.displayMedium?.color,
              fontWeight: FontWeight.bold,
            ),
          ),
        Text(
          "(${Provider.of<CurrUserProvider>(context, listen: true).currUser.email})",
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
