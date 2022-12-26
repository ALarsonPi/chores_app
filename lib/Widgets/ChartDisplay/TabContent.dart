import 'package:chore_app/Providers/ChartProvider.dart';
import 'package:chore_app/Widgets/ChartDisplay/EmptyChartDisplay.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Models/frozen/Chart.dart';
import 'CreatedChartDisplay.dart';

class TabContent extends StatelessWidget {
  TabContent(this.circleDataIndex, {super.key});
  int circleDataIndex;

  @override
  Widget build(BuildContext context) {
    Chart chartData = Provider.of<ChartProvider>(context, listen: true)
        .circleDataList[circleDataIndex];
    if (!(chartData == Chart.emptyChart)) {
      return CreatedChartDisplay(circleDataIndex, chartData);
    } else {
      return EmptyChartDisplay(circleDataIndex);
    }
  }
}
