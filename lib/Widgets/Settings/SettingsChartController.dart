import 'package:chore_app/Providers/TabNumberProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsChartController extends StatelessWidget {
  const SettingsChartController({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Text(
            "How many Charts should show? ",
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.displayLarge?.fontSize,
            ),
          ),
        ),
        const DropdownButtonTool(),
      ],
    );
  }
}

const List<String> list = <String>['One', 'Two', 'Three'];

class DropdownButtonTool extends StatefulWidget {
  const DropdownButtonTool({super.key});

  @override
  State<DropdownButtonTool> createState() => _DropdownButtonToolState();
}

class _DropdownButtonToolState extends State<DropdownButtonTool> {
  @override
  Widget build(BuildContext context) {
    int numTabs =
        Provider.of<TabNumberProvider>(context, listen: false).numTabs;
    // Starting Value
    String dropdownValue = list.elementAt(numTabs - 1);

    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: TextStyle(
        color: Theme.of(context).primaryColor,
      ),
      underline: Container(
        height: 2,
        color: Theme.of(context).primaryColor,
      ),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        Provider.of<TabNumberProvider>(context, listen: false)
            .changeNumTabs(value as String);
        setState(() {
          dropdownValue = value;
        });
      },
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
