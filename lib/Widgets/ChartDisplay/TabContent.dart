import 'package:chore_app/Widgets/ChartDisplay/EmptyChartDisplay.dart';
import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

import '../../Models/frozen/Chart.dart';
import '../../Services/ListenService.dart';
import 'CreatedChartDisplay.dart';

// ignore: must_be_immutable
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
      valueListenable: ListenService.chartsNotifiers.elementAt(circleDataIndex),
    );
  }
}
