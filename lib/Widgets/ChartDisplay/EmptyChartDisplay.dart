import 'package:chore_app/Daos/ChartDao.dart';
import 'package:chore_app/Providers/DisplayChartProvider.dart';
import 'package:chore_app/Providers/TextSizeProvider.dart';
import 'package:chore_app/Screens/ChartScreen.dart';
import 'package:flutter/material.dart';
import 'package:prompt_dialog/prompt_dialog.dart';
import 'package:provider/provider.dart';

import '../../ColorControl/AppColors.dart';
import '../../Global.dart';
import '../../Models/frozen/Chart.dart';
import '../../Models/frozen/User.dart';
import '../../Screens/ScreenArguments/newChartArguments.dart';

class EmptyChartDisplay extends StatelessWidget {
  EmptyChartDisplay(this.currTabIndex, this.userFromParent, {super.key});
  int currTabIndex;
  User userFromParent;

  String? chartId;
  Chart? chart;

  int? isChartAlreadyUsed(User currUser, String? id) {
    for (int i = 0; i < (currUser.chartIDs as List<String>).length; i++) {
      if (currUser.chartIDs?.elementAt(i).contains(id as String) as bool) {
        return i;
      }
    }
    return -1;
  }

  @override
  Widget build(BuildContext context) {
    User currUser = userFromParent;
    int num;
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
          decoration: BoxDecoration(
            color: Colors.orange,
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                Color(Theme.of(context).primaryColor.value),
                AppColors.getPrimaryColorSwatch().shade200,
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: const [0.25, 0.90],
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0xFF101012),
                offset: Offset(-8, 8),
                blurRadius: 8,
              ),
            ],
          ),
        ),
        Card(
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    "Press a button below to start!",
                    style: TextStyle(
                      fontSize: (Theme.of(context).textTheme.bodySmall?.fontSize
                              as double) +
                          Provider.of<TextSizeProvider>(context, listen: false)
                              .fontSizeToAdd,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        right: Provider.of<TextSizeProvider>(context,
                                    listen: false)
                                .fontSizeToAdd +
                            4,
                      ),
                      child: ElevatedButton(
                        onPressed: () => {
                          Navigator.pushNamed(context, ChartScreen.routeName,
                              arguments: CreateChartArguments(
                                currTabIndex,
                                Chart.emptyChart,
                                currUser,
                              )),
                        },
                        child: Text(
                          "Create New",
                          style: TextStyle(
                            fontSize: (Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.fontSize as double) +
                                Provider.of<TextSizeProvider>(context,
                                        listen: false)
                                    .fontSizeToAdd,
                            color: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.color,
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        chartId = await prompt(
                          context,
                          title: const Text('Please enter Chart Code:'),
                          initialValue: '',
                          isSelectedInitialValue: false,
                          textOK: const Text('OK'),
                          textCancel: const Text('Cancel'),
                          hintText: '',
                          validator: (String? value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.length != 8) {
                              String errorString = 'Invalid Chart Code Entered';
                              return errorString;
                            }
                            return null;
                          },
                          minLines: 1,
                          maxLines: 1,
                          autoFocus: true,
                          barrierDismissible: true,
                          textCapitalization: TextCapitalization.none,
                          textAlign: TextAlign.left,
                        );
                        if (chartId != null) {
                          num = isChartAlreadyUsed(currUser, chartId) as int;
                          if (num != -1) {
                            Global.rootScaffoldMessengerKey.currentState
                                ?.showSnackBar(
                              SnackBar(
                                content: Text(
                                  "You are already a part of that chart\nIt is your Chart ${num + 1}",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          } else {
                            debugPrint(chartId);
                            ChartDao.addPendingRequest(
                                currUser.id, chartId as String);
                            // chart = await ChartDao.addListenerAtIndex(
                            //     currTabIndex,
                            //     chartId as String,
                            //     context,
                            //     false);
                            // debugPrint(chart.toString());
                            // Global.rootScaffoldMessengerKey.currentState
                            //     ?.showSnackBar(
                            //   const SnackBar(
                            //     content: Text(
                            //       "You have sent in a request to join the chart. \nOnce the chart owner accepts your request, you will be added to the chart ",
                            //       textAlign: TextAlign.center,
                            //     ),
                            //   ),
                            // );
                          }
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.all(Provider.of<TextSizeProvider>(
                                context,
                                listen: false)
                            .fontSizeToAdd),
                        child: Text(
                          " Join Chart ",
                          style: TextStyle(
                            fontSize: (Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.fontSize as double) +
                                Provider.of<TextSizeProvider>(context,
                                        listen: false)
                                    .fontSizeToAdd,
                            color: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.color,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
