import 'package:chore_app/Global.dart';
import 'package:chore_app/Providers/DisplayChartProvider.dart';
import 'package:chore_app/Widgets/ChartDisplay/EmptyChartDisplay.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Models/frozen/Chart.dart';
import '../../Models/frozen/User.dart';
import 'CreatedChartDisplay.dart';

class TabContent extends StatelessWidget {
  TabContent(this.circleDataIndex, this.userFromParent, {super.key});
  int circleDataIndex;
  User userFromParent;

  @override
  Widget build(BuildContext context) {
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
      return EmptyChartDisplay(circleDataIndex, userFromParent);
    }
  }
}
