import 'package:chore_app/Widgets/Settings/SettingsContent.dart';
import 'package:flutter/material.dart';

import '../Global.dart';

// Not sure if I want to use this. Currently I'm thinking I don't,
// but we'll see what makes more sense for the users

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(Global.toolbarHeight),
        child: AppBar(
          iconTheme: IconThemeData(
            color: Theme.of(context).cardColor,
          ),
          automaticallyImplyLeading: true,
          toolbarHeight: Global.toolbarHeight,
          centerTitle: true,
          title: Text(
            "Settings",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
      ),
      body: const SettingsContent(),
    );
  }
}
