import 'package:chore_app/Providers/TextSizeProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
          Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Change Theme Color",
                  style: TextStyle(
                    color: Theme.of(context).textTheme.displaySmall?.color,
                    fontSize: (Theme.of(context)
                            .textTheme
                            .displayMedium
                            ?.fontSize as double) +
                        Provider.of<TextSizeProvider>(context, listen: true)
                            .fontSizeToAdd,
                  ),
                ),
              ),
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
        ],
      ),
    );
  }
}
