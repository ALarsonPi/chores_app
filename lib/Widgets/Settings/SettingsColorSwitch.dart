import 'package:flutter/material.dart';

import '../../ColorControl/PrimaryColorSwitcher.dart';
import '../../ColorControl/ThemeSwitcher.dart';

class SettingsColorSwitch extends StatelessWidget {
  SettingsColorSwitch(this.setStateForParent, {super.key});

  Function setStateForParent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Container(
            padding: const EdgeInsets.only(
              left: 15,
            ),
            color: Colors.grey.withOpacity(0.25),
            child: ExpansionTile(
              initiallyExpanded: false,
              title: Text(
                "Change Theme Color",
                style: TextStyle(
                  color: Theme.of(context).textTheme.displaySmall?.color,
                  fontSize: Theme.of(context).textTheme.displayMedium?.fontSize,
                ),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 8.0,
                    bottom: 8.0,
                    right: 15,
                  ),
                  child: ThemeSwitcher(75, setStateForParent),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: PrimaryColorSwitcher(75, setStateForParent),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
