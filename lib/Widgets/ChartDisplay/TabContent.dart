import 'package:chore_app/Global.dart';
import 'package:chore_app/Widgets/ChartDisplay/EmptyChartDisplay.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Models/frozen/Chart.dart';
import '../../Models/frozen/User.dart';
import 'CreatedChartDisplay.dart';

class TabContent extends StatelessWidget {
  TabContent(this.circleDataIndex, {super.key});
  int circleDataIndex;

  @override
  Widget build(BuildContext context) {
    Chart chartData = Chart.emptyChart;
    // Provider.of<ChartProvider>(context, listen: true)
    //     .circleDataList[circleDataIndex];

    List listOfThisUsersCharts =
        Provider.of<List<List<Chart>>>(context, listen: true);
    List<Chart> currCharts = List.empty(growable: true);
    for (List<Chart> currList in listOfThisUsersCharts) {
      currCharts.addAll(currList);
      currCharts.addAll(Global.addedChartsDuringSession);
    }
    List<User> listOfUser = Provider.of<List<User>>(context, listen: true);

    int indexOfCurrTab = (listOfUser.isEmpty)
        ? -1
        : listOfUser.elementAt(0).associatedTabNums?.indexOf(circleDataIndex)
            as int;

    if (indexOfCurrTab != -1) {
      String currChartID =
          listOfUser.elementAt(0).chartIDs?.elementAt(indexOfCurrTab) as String;
      var correctChart =
          currCharts.where((element) => element.id == currChartID);
      if (correctChart.isNotEmpty) {
        chartData = correctChart.first;
      }
    }

    if (!(chartData == Chart.emptyChart)) {
      return CreatedChartDisplay(circleDataIndex, chartData);
    } else {
      return EmptyChartDisplay(circleDataIndex);
    }
  }
}
