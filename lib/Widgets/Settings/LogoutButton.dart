import 'package:chore_app/Providers/TabNumberProvider.dart';
import 'package:chore_app/Services/FirebaseLogin.dart';
import 'package:chore_app/Services/ListenService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Providers/TextSizeProvider.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => {
        ListenService.cancelListeningToCharts(),
        ListenService.cancelListeningToUser(),
        Provider.of<TabNumberProvider>(context, listen: false)
            .changeCurrTabNum(0),
        FirebaseLogin.logout(),
        // Just to ensure that everything works
        Navigator.pushNamed(context, 'home'),
      },
      child: Padding(
        padding: EdgeInsets.all(
          Provider.of<TextSizeProvider>(context, listen: true).fontSizeToAdd,
        ),
        child: Text(
          "Logout",
          style: TextStyle(
            fontSize: (Theme.of(context).textTheme.headlineMedium?.fontSize
                    as double) +
                Provider.of<TextSizeProvider>(context, listen: true)
                    .fontSizeToAdd,
            color: Theme.of(context).textTheme.headlineMedium?.color,
          ),
        ),
      ),
    );
  }
}
