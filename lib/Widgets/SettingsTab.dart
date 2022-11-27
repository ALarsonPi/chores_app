import 'package:flutter/material.dart';

import '../ColorControl/PrimaryColorSwitcher.dart';
import '../ColorControl/ThemeSwitcher.dart';

class SettingsTab extends StatefulWidget {
  const SettingsTab({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SettingsTab();
  }
}

class _SettingsTab extends State<SettingsTab> {
  updateParent() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListView(
            shrinkWrap: true,
            children: [
              Container(
                padding: const EdgeInsets.only(
                  left: 15,
                ),
                color: Colors.grey.withOpacity(0.4),
                child: ExpansionTile(
                  initiallyExpanded: false,
                  title: Text(
                    "Change Theme Color",
                    style: TextStyle(
                      color: Theme.of(context).textTheme.displaySmall?.color,
                      fontSize:
                          Theme.of(context).textTheme.displaySmall?.fontSize,
                    ),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 8.0,
                        bottom: 8.0,
                        right: 15,
                      ),
                      child: ThemeSwitcher(75, updateParent),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 15.0),
                      child: PrimaryColorSwitcher(75, updateParent),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
