import 'package:chore_app/Services/ChartService.dart';
import 'package:chore_app/Widgets/ChartDisplay/EmptyChartDisplay.dart';
import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

import '../../Models/frozen/Chart.dart';
import '../../Services/ListenService.dart';
import 'CreatedChartDisplay.dart';

// ignore: must_be_immutable
class TabContent extends StatelessWidget with GetItMixin {
  TabContent(this.tabNum, this.notifyParentOfChangedContent, {super.key});
  int tabNum;
  Function notifyParentOfChangedContent;

  hasChangedData(int ringNum, bool hasChanged, double newPosition) {
    ChartService.prepareSavedChartData(
        tabNum, ringNum, hasChanged, newPosition);
    notifyParentOfChangedContent(
      ChartService.tabHasDataToSave(tabNum),
      tabNum,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      builder: (context, value, child) {
        return (!(value == Chart.emptyChart))
            ? CreatedChartDisplay(
                tabNum,
                value,
                hasChangedData,
              )
            : EmptyChartDisplay(tabNum);
      },
      valueListenable: ListenService.chartsNotifiers.elementAt(tabNum),
    );
  }
}
