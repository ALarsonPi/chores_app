import 'package:chore_app/Widgets/ConcentricChart.dart';
import 'package:flutter/material.dart';

import '../Global.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //In the future we'll grab any/all charts from system memory
    //or firebase (depending on updates and all that)
    //For now it's all hard-coded and we currently only
    //have one chart but in the future I'm thinking of giving the
    //user up to 3, maybe
    //Also use title of first chart as title here in the Scaffold
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(Global.toolbarHeight),
        child: AppBar(
          toolbarHeight: Global.toolbarHeight,
          centerTitle: true,
          title: Text(
            "Chart 1",
            style: Theme.of(context).textTheme.headlineLarge,
          ),
        ),
      ),
      body: Stack(
        children: [
          ConcentricChart(numberOfRings: 3),
        ],
      ),
    );
  }
}
