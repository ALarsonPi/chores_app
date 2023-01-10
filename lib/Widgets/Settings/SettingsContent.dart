import 'package:chore_app/Widgets/Settings/textSizeChanger.dart';
import 'package:flutter/material.dart';

import '../../Models/constant/Settings.dart';
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
    return ListView(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 8.0,
            left: 8.0,
            right: 8.0,
          ),
          child: SettingsColorSwitch(updateThemeColorParent),
        ),
        const Padding(
          padding: EdgeInsets.only(
            bottom: 8.0,
            left: 8.0,
            right: 8.0,
          ),
          child: TextSizeChangerWidget(),
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
        // Column For auto sizing properties of button
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 16.0,
                left: 8.0,
                right: 8.0,
              ),
              child: LogoutButton(),
            ),
          ],
        ),
      ],
    );
  }
}
