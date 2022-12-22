import 'package:chore_app/Screens/ScreenArguments/newChartArguments.dart';
import 'package:chore_app/Widgets/ConcentricChart/ConcentricChart.dart';
import 'package:flutter/material.dart';

import '../Global.dart';

class CreateChartScreen extends StatefulWidget {
  const CreateChartScreen({super.key});
  static const routeName = "/extractChartNum";

  @override
  State<CreateChartScreen> createState() => _CreateChartScreenState();
}

class _CreateChartScreenState extends State<CreateChartScreen> {
  late final args =
      ModalRoute.of(context)!.settings.arguments as CreateChartArguments;

  // Defaults
  int currNumRings = 3;
  int currNumSections = 4;

  final List<String> ringNumOptions = <String>[
    'Two Ring',
    'Three Ring',
  ];
  final List<String> numSectionsOptions = <String>[
    'Two Sections',
    'Three Sections',
    'Four Sections',
    'Five Sections',
    'Six Sections',
    'Seven Sections',
    'Eight Sections',
  ];

  updateCurrRingNum(String value) {
    setState(() {
      if (value == ringNumOptions.elementAt(0)) {
        currNumRings = 2;
      } else {
        currNumRings = 3;
      }
    });
  }

  updateNumSections(String value) {
    setState(() {
      // +1 for indexes starting at 0, and +1 for sections starting at 2
      currNumSections = numSectionsOptions.indexOf(value) + 1 + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 8.0,
              bottom: 8.0,
            ),
            child: SizedBox(
              height: MediaQuery.of(context).size.width * 0.75,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ConcentricChart(
                    numberOfRings: currNumRings,
                    circleOneText: List.filled(currNumSections, ""),
                    circleTwoText: List.filled(currNumSections, ""),
                    circleThreeText: List.filled(currNumSections, ""),

                    // Theme
                    linesColors: Global.currentTheme.lineColors,
                    circleOneColor: Global.currentTheme.primaryColor,
                    circleOneFontColor: Global.currentTheme.primaryTextColor,
                    circleTwoColor: Global.currentTheme.secondaryColor,
                    circleTwoFontColor: Global.currentTheme.secondaryTextColor,
                    circleThreeColor: Global.currentTheme.tertiaryColor,
                    circleThreeFontColor: Global.currentTheme.tertiaryTextColor,

                    // Const Programmer Decisions
                    width: MediaQuery.of(context).size.width * 0.75,
                    spaceBetweenLines: Global.circleSettings.spaceBetweenLines,
                    overflowLineLimit: Global.circleSettings.overflowLineLimit,
                    chunkOverflowLimitProportion:
                        Global.circleSettings.chunkOverflowLimitProportion,
                    circleOneRadiusProportions:
                        Global.circleSettings.circleOneRadiusProportions,
                    circleOneFontSize: Global.circleSettings.circleOneFontSize,
                    circleOneTextRadiusProportion:
                        Global.circleSettings.circleOneTextRadiusProportion,
                    circleTwoRadiusProportions:
                        Global.circleSettings.circleTwoRadiusProportions,
                    circleTwoFontSize: Global.circleSettings.circleTwoFontSize,
                    circleThreeRadiusProportion:
                        Global.circleSettings.circleThreeRadiusProportion,
                    circleThreeFontSize:
                        Global.circleSettings.circleThreeFontSize,
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Dropdown(ringNumOptions, updateCurrRingNum),
              Padding(
                padding: const EdgeInsets.only(left: 32.0),
                child: Dropdown(numSectionsOptions, updateNumSections),
              ),
            ],
          ),
          const Divider(
            thickness: 2,
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class Dropdown extends StatefulWidget {
  Dropdown(this.list, this.setStateFunction, {super.key});
  List<String> list;
  Function setStateFunction;

  @override
  State<Dropdown> createState() => _DropdownState();
}

class _DropdownState extends State<Dropdown> {
  late String dropdownValue = widget.list.elementAt(0);

  @override
  Widget build(BuildContext context) {
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
        setState(() {
          dropdownValue = value as String;
        });
        widget.setStateFunction(value);
      },
      items: widget.list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
