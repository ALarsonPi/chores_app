import 'package:flutter/material.dart';

import '../../ColorControl/PrimaryColorSwitcher.dart';
import '../../ColorControl/ThemeSwitcher.dart';

class TextSizeChangerWidget extends StatefulWidget {
  const TextSizeChangerWidget({super.key});

  @override
  State<TextSizeChangerWidget> createState() => _TextSizeChangerWidgetState();
}

class _TextSizeChangerWidgetState extends State<TextSizeChangerWidget> {
  voidFunc() {}

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        children: [
          Container(
            padding: const EdgeInsets.only(
              left: 15,
            ),
            color: Colors.grey.withOpacity(0.25),
            child: ExpansionTile(
              initiallyExpanded: false,
              title: Text(
                "Change Text Size",
                style: TextStyle(
                  color: Theme.of(context).textTheme.displaySmall?.color,
                  fontSize: Theme.of(context).textTheme.displayMedium?.fontSize,
                ),
              ),
              children: [
                RadioListTile<String>(
                  title: const Text('Small'),
                  value: "HI",
                  groupValue: "fontSizeGroup",
                  onChanged: (String? value) {
                    setState(() {
                      // _character = value;
                    });
                  },
                ),
                RadioListTile<String>(
                  title: const Text('Medium'),
                  value: "HI",
                  groupValue: "fontSizeGroup",
                  onChanged: (String? value) {
                    setState(() {
                      // _character = value;
                    });
                  },
                ),
                RadioListTile<String>(
                  title: const Text('Large'),
                  value: "HI",
                  groupValue: "fontSizeGroup",
                  onChanged: (String? value) {
                    setState(() {
                      // _character = value;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
    ;
  }
}
