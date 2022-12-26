import 'package:chore_app/Models/constant/RingCharLimit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
            nameController.text.length < nameChartLimit) &&
        (chore1Controller.text.isNotEmpty &&
            chore1Controller.text.length <
                widget.currRingCharLimit.secondRingLimit) &&
        ((widget.numRings == 2) ||
            (chore2Controller.text.isNotEmpty &&
                chore2Controller.text.length <
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

    subtleUnderlineTheme = InputDecorationTheme(
      enabledBorder: const UnderlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        borderSide: BorderSide(
          width: 1,
          color: Color.fromARGB(255, 231, 231, 231),
        ),
      ),
      focusedBorder: UnderlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        borderSide: BorderSide(
          width: 1,
          color: Theme.of(context).primaryColor,
        ),
      ),
      errorBorder: const UnderlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        borderSide: BorderSide(
          width: 1,
          color: Colors.red,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 8.0,
            bottom: 8.0,
          ),
          child: Text(
            "Section ${widget.chunkIndex + 1}",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Row(
          children: [
            const Flexible(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: Text(
                  "  NAME:     ",
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            Flexible(
              flex: 5,
              child: Theme(
                data: ThemeData(
                  inputDecorationTheme: subtleUnderlineTheme,
                ),
                child: TextFormField(
                  controller: nameController,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(
                      nameChartLimit,
                    ),
                  ],
                  style: TextStyle(
                    color: Theme.of(context).textTheme.headlineLarge?.color
                        as Color,
                  ),
                  decoration: const InputDecoration(
                    hintStyle: TextStyle(
                      fontStyle: FontStyle.italic,
                    ),
                    filled: true,
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
              const Flexible(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: Text(
                    "CHORE 1:  ",
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              Flexible(
                flex: 5,
                child: Theme(
                  data: ThemeData(
                    inputDecorationTheme: subtleUnderlineTheme,
                  ),
                  child: TextFormField(
                    controller: chore1Controller,
                    maxLines: (widget.numRings == 3) ? 1 : 2,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(
                        widget.currRingCharLimit.secondRingLimit,
                      ),
                    ],
                    style: TextStyle(
                      color: Theme.of(context).textTheme.headlineLarge?.color
                          as Color,
                    ),
                    decoration: const InputDecoration(
                      hintStyle: TextStyle(
                        fontStyle: FontStyle.italic,
                      ),
                      filled: true,
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
              children: [
                const Flexible(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.only(left: 16.0),
                    child: Text(
                      "CHORE 2:  ",
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                Flexible(
                  flex: 5,
                  child: Theme(
                    data: ThemeData(
                      inputDecorationTheme: subtleUnderlineTheme,
                    ),
                    child: TextFormField(
                      controller: chore2Controller,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(
                          widget.currRingCharLimit.thirdRingLimit,
                        ),
                      ],
                      style: TextStyle(
                        color: Theme.of(context).textTheme.headlineLarge?.color
                            as Color,
                      ),
                      decoration: const InputDecoration(
                        hintStyle: TextStyle(
                          fontStyle: FontStyle.italic,
                        ),
                        filled: true,
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
