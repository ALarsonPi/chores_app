import 'package:flutter/material.dart';

import '../UserLoginLogout/CurrUserDisplay.dart';
import 'ContactCreatorButton.dart';
import 'LogoutButton.dart';
import 'SettingsChartController.dart';
import 'SettingsColorSwitch.dart';

class SettingsContent extends StatefulWidget {
  const SettingsContent({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SettingsContent();
  }
}

class _SettingsContent extends State<SettingsContent> {
  updateThemeColorParent() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 8.0,
            bottom: 8.0,
            left: 8.0,
            right: 8.0,
          ),
          child: SettingsColorSwitch(updateThemeColorParent),
        ),
        const SettingsChartController(),
        Padding(
          padding: const EdgeInsets.only(
            top: 16.0,
            left: 8.0,
            right: 8.0,
          ),
          child: ContactCreatorButton(),
        ),
        const Padding(
          padding: EdgeInsets.only(
            top: 16.0,
            bottom: 8.0,
          ),
          child: CurrUserDisplay(),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 16.0,
            left: 8.0,
            right: 8.0,
          ),
          child: LogoutButton(),
        ),
      ],
    );
  }
}
