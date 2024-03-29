import 'package:chore_app/Models/constant/RingCharLimit.dart';
import 'package:chore_app/Models/constant/Settings.dart';
import 'package:chore_app/Widgets/ChartDisplay/ChangeChart/CreateChartUI_Helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../Global.dart';
import '../../../Providers/TextSizeProvider.dart';

class ChartItemInput extends StatefulWidget {
  ChartItemInput(
      {required this.chunkIndex,
      required this.numRings,
      required this.updateParentChunkText,
      required this.currStrings,
      required this.currRingCharLimit,
      super.key});
  int chunkIndex;
  int numRings;
  List<String> currStrings;
  Function updateParentChunkText;
  RingCharLimit currRingCharLimit;

  @override
  State<ChartItemInput> createState() => ChartItemInputState();
}

class ChartItemInputState extends State<ChartItemInput> {
  TextEditingController nameController = TextEditingController();
  TextEditingController chore1Controller = TextEditingController();
  TextEditingController chore2Controller = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    chore1Controller.dispose();
    chore2Controller.dispose();
  }

  final nameType = "NAME";
  final nameChartLimit = 20;
  final chore1Type = "CHORE 1";
  final chore2Type = "CHORE 2";

  late InputDecorationTheme subtleUnderlineTheme;

  @override
  void initState() {
    super.initState();

    nameController.text = widget.currStrings[0];
    chore1Controller.text = widget.currStrings[1];
    chore2Controller.text = widget.currStrings[2];
    addListeners();
  }

  addListeners() {
    nameController.addListener(() {
      widget.updateParentChunkText(
        widget.chunkIndex,
        nameController.text,
        nameType,
      );
    });

    chore1Controller.addListener(() {
      widget.updateParentChunkText(
        widget.chunkIndex,
        chore1Controller.text,
        chore1Type,
      );
    });

    chore2Controller.addListener(() {
      widget.updateParentChunkText(
        widget.chunkIndex,
        chore2Controller.text,
        chore2Type,
      );
    });
  }

  bool checkIfValid() {
    return (nameController.text.isNotEmpty &&
            nameController.text.length <= nameChartLimit) &&
        (chore1Controller.text.isNotEmpty &&
            chore1Controller.text.length <=
                widget.currRingCharLimit.secondRingLimit) &&
        ((widget.numRings == 2) ||
            (chore2Controller.text.isNotEmpty &&
                chore2Controller.text.length <=
                    widget.currRingCharLimit.thirdRingLimit));
  }

  updateChild() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (widget.currStrings[1] != chore1Controller.text) {
        chore1Controller.text = widget.currStrings[1];
        if (chore1Controller.text.isNotEmpty) {
          chore1Controller.selection = TextSelection.fromPosition(
              TextPosition(offset: chore1Controller.text.length));
        }
      }

      if (widget.currStrings[2] != chore2Controller.text) {
        chore2Controller.text = widget.currStrings[2];
        if (chore2Controller.text.isNotEmpty) {
          chore2Controller.selection = TextSelection.fromPosition(
              TextPosition(offset: chore2Controller.text.length));
        }
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    subtleUnderlineTheme = getSubtleUnderlineTheme(context);
  }

  int getTextFlex() {
    return (Provider.of<TextSizeProvider>(context, listen: false)
                    .currTextSize ==
                TextSize.LARGE ||
            !Global.isPhone)
        ? 2
        : 3;
  }

  int getBodyFlex() {
    return (Provider.of<TextSizeProvider>(context, listen: false)
                    .currTextSize ==
                TextSize.LARGE ||
            !Global.isPhone)
        ? 3
        : 5;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 8.0,
            bottom: 8.0,
          ),
          child: Text(
            "Section ${widget.chunkIndex + 1}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: (Theme.of(context).textTheme.displayMedium?.fontSize
                      as double) +
                  Provider.of<TextSizeProvider>(context, listen: false)
                      .fontSizeToAdd,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Row(
          children: [
            Flexible(
              flex: getTextFlex(),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 16.0,
                ),
                child: Text(
                  "  NAME:     ",
                  style: TextStyle(
                    fontSize: (Theme.of(context)
                            .textTheme
                            .displaySmall
                            ?.fontSize as double) +
                        Provider.of<TextSizeProvider>(context, listen: false)
                            .fontSizeToAdd,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            Flexible(
              flex: getBodyFlex(),
              child: Theme(
                data: ThemeData(
                  inputDecorationTheme: subtleUnderlineTheme,
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 2.0 +
                        Provider.of<TextSizeProvider>(context, listen: false)
                            .fontSizeToAdd,
                    right: 2.0 +
                        Provider.of<TextSizeProvider>(context, listen: false)
                            .fontSizeToAdd,
                  ),
                  child: TextFormField(
                    controller: nameController,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(
                        nameChartLimit + 1,
                      ),
                    ],
                    style: TextStyle(
                      fontSize: (Theme.of(context)
                              .textTheme
                              .displaySmall
                              ?.fontSize as double) +
                          Provider.of<TextSizeProvider>(context, listen: false)
                              .fontSizeToAdd,
                      color: Theme.of(context).textTheme.headlineLarge?.color
                          as Color,
                    ),
                    decoration: InputDecoration(
                      fillColor:
                          (nameController.text.length == nameChartLimit + 1)
                              ? const Color(0xFFF4C7C2)
                              : null,
                      filled: true,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            children: [
              Flexible(
                flex: getTextFlex(),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 16.0,
                  ),
                  child: Text(
                    "CHORE 1:  ",
                    style: TextStyle(
                      fontSize: (Theme.of(context)
                              .textTheme
                              .displaySmall
                              ?.fontSize as double) +
                          Provider.of<TextSizeProvider>(context, listen: false)
                              .fontSizeToAdd,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              Flexible(
                flex: getBodyFlex(),
                child: Theme(
                  data: ThemeData(
                    inputDecorationTheme: subtleUnderlineTheme,
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 2.0 +
                          Provider.of<TextSizeProvider>(context, listen: false)
                              .fontSizeToAdd,
                      right: 2.0 +
                          Provider.of<TextSizeProvider>(context, listen: false)
                              .fontSizeToAdd,
                    ),
                    child: TextFormField(
                      controller: chore1Controller,
                      minLines: 1,
                      maxLines: (widget.numRings == 3) ? 1 : 2,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(
                          widget.currRingCharLimit.secondRingLimit + 1,
                        ),
                      ],
                      style: TextStyle(
                        fontSize: (Theme.of(context)
                                .textTheme
                                .displaySmall
                                ?.fontSize as double) +
                            Provider.of<TextSizeProvider>(context,
                                    listen: false)
                                .fontSizeToAdd,
                        color: Theme.of(context).textTheme.headlineLarge?.color
                            as Color,
                      ),
                      decoration: InputDecoration(
                        fillColor: (chore1Controller.text.length ==
                                widget.currRingCharLimit.secondRingLimit + 1)
                            ? const Color(0xFFF4C7C2)
                            : null,
                        filled: true,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (widget.numRings == 3)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  flex: getTextFlex(),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 16.0,
                    ),
                    child: Text(
                      "CHORE 2:  ",
                      style: TextStyle(
                        fontSize: (Theme.of(context)
                                .textTheme
                                .displaySmall
                                ?.fontSize as double) +
                            Provider.of<TextSizeProvider>(context,
                                    listen: false)
                                .fontSizeToAdd,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                Flexible(
                  flex: getBodyFlex(),
                  child: Theme(
                    data: ThemeData(
                      inputDecorationTheme: subtleUnderlineTheme,
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: 2.0 +
                            Provider.of<TextSizeProvider>(context,
                                    listen: false)
                                .fontSizeToAdd,
                        right: 2.0 +
                            Provider.of<TextSizeProvider>(context,
                                    listen: false)
                                .fontSizeToAdd,
                      ),
                      child: TextFormField(
                        controller: chore2Controller,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(
                            widget.currRingCharLimit.thirdRingLimit + 1,
                          ),
                        ],
                        style: TextStyle(
                          fontSize: (Theme.of(context)
                                  .textTheme
                                  .displaySmall
                                  ?.fontSize as double) +
                              Provider.of<TextSizeProvider>(context,
                                      listen: false)
                                  .fontSizeToAdd,
                          color: Theme.of(context)
                              .textTheme
                              .headlineLarge
                              ?.color as Color,
                        ),
                        decoration: InputDecoration(
                          fillColor: (chore2Controller.text.length ==
                                  widget.currRingCharLimit.thirdRingLimit + 1)
                              ? const Color(0xFFF4C7C2)
                              : null,
                          filled: true,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
