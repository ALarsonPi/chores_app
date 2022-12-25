import 'package:carousel_slider/carousel_slider.dart';
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
      int newNumSections = currNumSections;

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
    });
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

  @override
  Widget build(BuildContext context) {
    double sizeOfChart = MediaQuery.of(context).size.height * 0.4;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Customize New Chart"),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: ListView(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
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
                            currStrings: [
                              nameStrings[itemIndex],
                              ring2Strings[itemIndex],
                              ring3Strings[itemIndex],
                            ],
                            numRings: currNumRings,
                            chunkIndex: itemIndex,
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
                  Padding(
                    padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.3,
                      right: MediaQuery.of(context).size.width * 0.3,
                    ),
                    child: ElevatedButton(
                      onPressed: () => {},
                      child: Text("Continue"),
                    ),
                  ),
                ],
              ),
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
