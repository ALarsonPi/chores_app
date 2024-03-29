import 'package:chore_app/Models/constant/Settings.dart';
import 'package:chore_app/Providers/TextSizeProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TextSizeChangerWidget extends StatefulWidget {
  const TextSizeChangerWidget({super.key});

  @override
  State<TextSizeChangerWidget> createState() => _TextSizeChangerWidgetState();
}

class _TextSizeChangerWidgetState extends State<TextSizeChangerWidget> {
  voidFunc() {}

  late String radioValue;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    radioValue = Provider.of<TextSizeProvider>(context, listen: false)
        .currTextSize
        .toString();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Change Text Size",
                  textAlign: TextAlign.start,
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
              RadioListTile<String>(
                title: Text(
                  'Small',
                  style: TextStyle(
                    fontSize: (Theme.of(context)
                            .textTheme
                            .displayMedium
                            ?.fontSize as double) +
                        Provider.of<TextSizeProvider>(context, listen: true)
                            .fontSizeToAdd,
                  ),
                ),
                value: TextSize.SMALL.toString(),
                groupValue: radioValue,
                onChanged: (String? value) {
                  setState(() {
                    radioValue = value as String;
                    Provider.of<TextSizeProvider>(context, listen: false)
                        .setCurrTextSize(TextSize.SMALL);
                  });
                },
              ),
              RadioListTile<String>(
                title: Text(
                  'Normal',
                  style: TextStyle(
                    fontSize: (Theme.of(context)
                            .textTheme
                            .displayMedium
                            ?.fontSize as double) +
                        Provider.of<TextSizeProvider>(context, listen: true)
                            .fontSizeToAdd,
                  ),
                ),
                value: TextSize.MEDIUM.toString(),
                groupValue: radioValue,
                onChanged: (String? value) {
                  setState(() {
                    radioValue = value as String;
                    Provider.of<TextSizeProvider>(context, listen: false)
                        .setCurrTextSize(TextSize.MEDIUM);
                  });
                },
              ),
              RadioListTile<String>(
                title: Text(
                  'Large',
                  style: TextStyle(
                    fontSize: (Theme.of(context)
                            .textTheme
                            .displayMedium
                            ?.fontSize as double) +
                        Provider.of<TextSizeProvider>(context, listen: true)
                            .fontSizeToAdd,
                  ),
                ),
                value: TextSize.LARGE.toString(),
                groupValue: radioValue,
                onChanged: (String? value) {
                  setState(() {
                    radioValue = value as String;
                    Provider.of<TextSizeProvider>(context, listen: false)
                        .setCurrTextSize(TextSize.LARGE);
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
    ;
  }
}
