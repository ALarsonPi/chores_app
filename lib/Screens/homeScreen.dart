import 'package:chore_app/Widgets/RotatingPieChart/TextPainters/ArcText.dart';
import 'package:chore_app/Widgets/ConcentricChart.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //In the future we'll grab any/all charts from system memory
    //or firebase (depending on updates and all that)
    //For now it's all hard-coded and we currently only
    //have one chart but in the future I'm thinking of giving the
    //user up to 3, maybe
    //Also use title of first chart as title here in the Scaffold
    double currentRadius = 125;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Chart 1"),
      ),
      body: Stack(
        children: [
          ConcentricChart(numberOfRings: 2),
        ],
      ),
    );
  }
}
