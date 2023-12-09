import 'package:chore_app/Widgets/Settings/SettingsContent.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Providers/TextSizeProvider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          "Settings",
          style: TextStyle(
            fontSize: (Theme.of(context).textTheme.headlineLarge?.fontSize
                    as double) +
                Provider.of<TextSizeProvider>(context, listen: true)
                    .fontSizeToAdd,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: const SettingsContent(),
    );
  }
}
