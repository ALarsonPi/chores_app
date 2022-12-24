import 'package:chore_app/Screens/ScreenArguments/newChartArguments.dart';
import 'package:chore_app/Widgets/ChartDisplay/ChartItemInput.dart';
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
  final _formKey = GlobalKey<FormState>();

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

  int currentStep = 0;

  List<Step> getSteps() {
    return <Step>[
      Step(
        state: currentStep > 0 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 0,
        title: const Text(""),
        content: Column(
          children: [],
        ),
      ),
      Step(
        state: currentStep > 1 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 1,
        title: const Text(""),
        content: Column(
          children: [],
        ),
      ),
      Step(
        state: currentStep > 1 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 1,
        title: const Text(""),
        content: Column(
          children: [],
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    double sizeOfChart = MediaQuery.of(context).size.width * 0.75;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Customize New Chart"),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        child: ListView(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 8.0,
                bottom: 8.0,
              ),
              child: SizedBox(
                height: sizeOfChart,
                child: ConcentricChart(
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
                  width: sizeOfChart,
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
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Dropdown(
                  ringNumOptions,
                  updateCurrRingNum,
                  initialIndex: 1,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 32.0),
                  child: Dropdown(
                    numSectionsOptions,
                    updateNumSections,
                    initialIndex: 2,
                  ),
                ),
              ],
            ),
            const Divider(
              thickness: 2,
            ),
            Form(
              key: _formKey,
              child: ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  ChartItemInput(),
                  // TextFormField(),
                  // TextFormField(),
                  // TextFormField(),
                  // TextFormField(),
                  // TextFormField(),
                  // TextFormField(),
                  // TextFormField(),
                  // TextFormField(),
                ],
              ),
            )

            // SizedBox(
            //   width: MediaQuery.of(context).size.width * 0.8,
            //   height: MediaQuery.of(context).size.height * 0.3,
            //   child:
            //       // Text("HI"),
            //       Stepper(
            //     type: StepperType.horizontal,
            //     currentStep: currentStep,
            //     onStepCancel: () => currentStep == 0
            //         ? null
            //         : setState(() {
            //             currentStep -= 1;
            //           }),
            //     onStepContinue: () async {
            //       bool isLastStep = (currentStep == getSteps().length - 1);
            //       if (isLastStep) {
            //       } else {
            //         setState(() {
            //           currentStep += 1;
            //         });
            //       }
            //     },
            //     onStepTapped: (step) => setState(() {
            //       currentStep = step;
            //     }),
            //     steps: getSteps(),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class Dropdown extends StatefulWidget {
  Dropdown(this.list, this.setStateFunction,
      {this.initialIndex = 0, super.key});
  int initialIndex;
  List<String> list;
  Function setStateFunction;

  @override
  State<Dropdown> createState() => _DropdownState();
}

class _DropdownState extends State<Dropdown> {
  late String dropdownValue = widget.list.elementAt(widget.initialIndex);

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.expand_more),
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
