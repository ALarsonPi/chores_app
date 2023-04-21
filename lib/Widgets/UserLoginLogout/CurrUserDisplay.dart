import 'package:chore_app/Providers/TextSizeProvider.dart';
import 'package:chore_app/Services/ListenService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CurrUserDisplay extends StatelessWidget {
  const CurrUserDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        Text(
          "Signed in as",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize:
                (Theme.of(context).textTheme.displayLarge?.fontSize as double) +
                    Provider.of<TextSizeProvider>(context, listen: true)
                        .fontSizeToAdd,
            color: Theme.of(context).textTheme.displayMedium?.color,
          ),
        ),
        Text(
          ListenService.userNotifier.value.name ?? "No name",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize:
                (Theme.of(context).textTheme.displayLarge?.fontSize as double) +
                    Provider.of<TextSizeProvider>(context, listen: true)
                        .fontSizeToAdd,
            color: Theme.of(context).textTheme.displayMedium?.color,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          "(${ListenService.userNotifier.value.email})",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize:
                (Theme.of(context).textTheme.displayLarge?.fontSize as double) +
                    Provider.of<TextSizeProvider>(context, listen: true)
                        .fontSizeToAdd,
            color: Theme.of(context).textTheme.displayMedium?.color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
