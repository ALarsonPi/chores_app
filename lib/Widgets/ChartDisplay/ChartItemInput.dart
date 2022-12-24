import 'package:flutter/material.dart';

class ChartItemInput extends StatefulWidget {
  ChartItemInput(
      {required this.chunkIndex,
      required this.numRings,
      required this.updateParentChunkText,
      super.key});
  int chunkIndex;
  int numRings;
  Function updateParentChunkText;

  @override
  State<ChartItemInput> createState() => _ChartItemInputState();
}

class _ChartItemInputState extends State<ChartItemInput> {
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

  String nameType = "NAME";
  String chore1Type = "CHORE 1";
  String chore2Type = "CHORE 2";

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Flexible(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: Text("  NAME:     "),
              ),
            ),
            Flexible(
              flex: 5,
              child: TextFormField(
                controller: nameController,
              ),
            ),
          ],
        ),
        Row(
          children: [
            const Flexible(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: Text("CHORE 1:  "),
              ),
            ),
            Flexible(
              flex: 5,
              child: TextFormField(
                controller: chore1Controller,
              ),
            ),
          ],
        ),
        if (widget.numRings == 3)
          Row(
            children: [
              const Flexible(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: Text("CHORE 2:  "),
                ),
              ),
              Flexible(
                flex: 5,
                child: TextFormField(
                  controller: chore2Controller,
                ),
              ),
            ],
          ),
      ],
    );
  }
}
