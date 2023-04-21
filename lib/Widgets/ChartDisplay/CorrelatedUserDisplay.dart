import 'package:flutter/material.dart';

class CorrelatedUserDisplay extends StatefulWidget {
  const CorrelatedUserDisplay({super.key});

  @override
  State<CorrelatedUserDisplay> createState() => _CorrelatedUserDisplayState();
}

class _CorrelatedUserDisplayState extends State<CorrelatedUserDisplay> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "HERE",
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
