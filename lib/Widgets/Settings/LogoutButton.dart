import 'package:chore_app/Daos/ChartDao.dart';
import 'package:chore_app/Global.dart';
import 'package:chore_app/Providers/TabNumberProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Providers/TextSizeProvider.dart';
import '../../Services/ChartManager.dart';
import '../../Services/UserManager.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => {
        ChartDao.endListeningToCharts(),
        Global.getIt.get<ChartList>().setChartsToEmpty(),
        Global.getIt.get<UserManager>().endListening(),
        Provider.of<TabNumberProvider>(context, listen: false)
            .changeCurrTabNum(0),
        FirebaseAuth.instance.signOut(),
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
