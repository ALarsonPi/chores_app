import 'package:flutter/material.dart';

class ChartItemInput extends StatefulWidget {
  const ChartItemInput({super.key});

  @override
  State<ChartItemInput> createState() => _ChartItemInputState();
}

class _ChartItemInputState extends State<ChartItemInput> {
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
              child: TextFormField(),
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
              child: TextFormField(),
            ),
          ],
        ),
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
              child: TextFormField(),
            ),
          ],
        ),
      ],
    );
  }
}
