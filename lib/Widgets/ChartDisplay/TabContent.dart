import 'package:chore_app/Global.dart';
import 'package:chore_app/Widgets/ChartDisplay/EmptyChartDisplay.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import '../../Models/frozen/Chart.dart';
import '../../Services/ChartManager.dart';
import 'CreatedChartDisplay.dart';

class TabContent extends StatelessWidget with GetItMixin {
  TabContent(this.circleDataIndex, {super.key});
  int circleDataIndex;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      builder: (context, value, child) {
        return (!(value == Chart.emptyChart))
            ? CreatedChartDisplay(
                circleDataIndex,
                value as Chart,
              )
            : EmptyChartDisplay(circleDataIndex);
      },
      valueListenable:
          Global.getIt.get<ChartList>().getCurrNotifierByIndex(circleDataIndex),
    );
  }
}
