import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:chore_app/Models/constant/RingCharLimit.dart';
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

  // Defaults
  int currNumRings = 3;
  int currNumSections = 4;

  late RingCharLimit currCharLimit;

  @override
  void initState() {
    super.initState();
    // -1 for indexes starting at 0, -1 for there not being an option for 1 section
    currCharLimit = RingCharLimits.limits[currNumSections - 1 - 1];
  }

  List<String> nameStrings = List.filled(4, "", growable: true);
  List<String> ring2Strings = List.filled(4, "", growable: true);
  List<String> ring3Strings = List.filled(4, "", growable: true);

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
  // ignore: non_constant_identifier_names
  final int MAX_SECTIONS = 8;

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
      // Copy to compare to
      int oldNumSections = currNumSections;

      // +1 for indexes starting at 0, and +1 for sections starting at 2
      currNumSections = numSectionsOptions.indexOf(value) + 1 + 1;
      currCharLimit = RingCharLimits.limits.elementAt(currNumSections - 2);
      updateStringListSize(currNumSections, oldNumSections);
      updateStringsLength();

      for (int i = 0; i < MAX_SECTIONS - 1; i++) {
        if (chartItemKeys[i].currentState != null) {
          chartItemKeys[i].currentState!.updateChild();
        }
      }
    });
  }

  updateStringListSize(int newNumSections, int oldNumSections) {
    if (newNumSections < oldNumSections) {
      nameStrings = nameStrings.sublist(0, currNumSections);
      ring2Strings = ring2Strings.sublist(0, currNumSections);
      ring3Strings = ring3Strings.sublist(0, currNumSections);
    } else if (currNumSections > oldNumSections) {
      for (int i = 0; i < newNumSections - oldNumSections; i++) {
        nameStrings.add("");
        ring2Strings.add("");
        ring3Strings.add("");
      }
    }
  }

  updateStringsLength() {
    for (int i = 0; i < ring2Strings.length; i++) {
      ring2Strings[i] = ring2Strings.elementAt(i).substring(
          0,
          min(ring2Strings.elementAt(i).characters.length,
              currCharLimit.secondRingLimit));
    }
    for (int i = 0; i < ring3Strings.length; i++) {
      ring3Strings[i] = ring3Strings.elementAt(i).substring(
          0,
          min(ring3Strings.elementAt(i).characters.length,
              currCharLimit.thirdRingLimit));
    }
  }

  updateParentText(int index, String newString, String type) {
    setState(() {
      if (type == "NAME") {
        nameStrings[index] = newString;
      } else if (type == "CHORE 1") {
        ring2Strings[index] = newString;
      } else if (type == "CHORE 2") {
        ring3Strings[index] = newString;
      } else {
        debugPrint("Invalid type");
      }
    });
  }

  CarouselController carouselController = CarouselController();
  List<GlobalKey<ChartItemInputState>> chartItemKeys = [
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
  ];

  int validateAllActiveFields() {
    for (int i = 0; i < currNumSections; i++) {
      bool currChartisValid = chartItemKeys[i].currentState!.checkIfValid();
      if (!currChartisValid) {
        return i;
      }
    }
    return -1;
  }

  @override
  Widget build(BuildContext context) {
    double sizeOfChart = MediaQuery.of(context).size.height * 0.4;
    int validationNum = 0;

    return Scaffold(
      // resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          "Customize New Chart",
          style: TextStyle(
            color: Theme.of(context).textTheme.headlineSmall?.color as Color,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
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
                  circleOneText: nameStrings,
                  circleTwoText: ring2Strings,
                  circleThreeText: ring3Strings,
                  shouldIgnoreTouch: true,

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
            Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    CarouselSlider.builder(
                      carouselController: carouselController,
                      itemCount: currNumSections,
                      itemBuilder: (BuildContext context, int itemIndex,
                              int pageViewIndex) =>
                          Padding(
                        padding: const EdgeInsets.only(
                          left: 8.0,
                          right: 8.0,
                        ),
                        child: ChartItemInput(
                          key: chartItemKeys[itemIndex],
                          currStrings: [
                            nameStrings.elementAt(itemIndex),
                            ring2Strings.elementAt(itemIndex),
                            ring3Strings.elementAt(itemIndex),
                          ],
                          numRings: currNumRings,
                          chunkIndex: itemIndex,
                          currRingCharLimit: currCharLimit,
                          updateParentChunkText: updateParentText,
                        ),
                      ),
                      options: CarouselOptions(
                        scrollPhysics: const BouncingScrollPhysics(),
                        aspectRatio: 16 / 9,
                        viewportFraction: 0.9,
                        initialPage: 0,
                        enableInfiniteScroll: false,
                        reverse: false,
                        autoPlay: false,
                        enlargeCenterPage: false,
                        onPageChanged: (index, reason) {},
                        scrollDirection: Axis.horizontal,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: () {
                          carouselController.previousPage();
                        },
                        icon: const Icon(Icons.arrow_back),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        onPressed: () {
                          carouselController.nextPage();
                        },
                        icon: const Icon(Icons.arrow_forward),
                      ),
                    ),
                  ],
                ),
                Visibility(
                  visible: MediaQuery.of(context).viewInsets.bottom == 0,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.3,
                      right: MediaQuery.of(context).size.width * 0.3,
                    ),
                    child: ElevatedButton(
                      onPressed: () => {
                        // I'll have to validate stuff for myself, as
                        // the form will try to validate ALL the sections
                        // even the ones not active
                        validationNum = validateAllActiveFields(),
                        if (validationNum == -1)
                          {
                            debugPrint("VALID"),
                          }
                        else
                          {
                            Global.rootScaffoldMessengerKey.currentState
                                ?.showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Section ${validationNum + 1} is incomplete."
                                  "\nPlease complete all fields to continue",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          },
                      },
                      child: Text("Continue",
                          style: TextStyle(
                              color: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.color as Color)),
                    ),
                  ),
                ),
              ],
            ),
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
