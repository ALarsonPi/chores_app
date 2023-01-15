import 'package:chore_app/Global.dart';
import 'package:chore_app/Providers/DisplayChartProvider.dart';
import 'package:chore_app/Widgets/ChartDisplay/EmptyChartDisplay.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Models/frozen/Chart.dart';
import '../../Providers/ChartProvider.dart';
import 'CreatedChartDisplay.dart';

class TabContent extends StatelessWidget {
  TabContent(this.circleDataIndex, {super.key});
  int circleDataIndex;

  @override
  Widget build(BuildContext context) {
    Provider.of<ChartProvider>(context, listen: true)
        .circleDataList[circleDataIndex];
    Chart chartData = (!Provider.of<DisplayChartProvider>(context, listen: true)
            .usersCharts
            .keys
            .contains(circleDataIndex))
        ? Chart.emptyChart
        : Provider.of<DisplayChartProvider>(context, listen: true)
            .usersCharts[circleDataIndex] as Chart;

    if (!(chartData == Chart.emptyChart)) {
      return CreatedChartDisplay(circleDataIndex, chartData);
    } else {
      return EmptyChartDisplay(circleDataIndex);
    }
  }
}
