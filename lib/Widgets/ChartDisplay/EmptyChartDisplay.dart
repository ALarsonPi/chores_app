import 'package:chore_app/Providers/TextSizeProvider.dart';
import 'package:chore_app/Screens/ChartScreen.dart';
import 'package:chore_app/Widgets/ChartDisplay/JoinChartDialogPopup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../ColorControl/AppColors.dart';
import '../../Models/frozen/Chart.dart';
import '../../Screens/ScreenArguments/newChartArguments.dart';

// ignore: must_be_immutable
class EmptyChartDisplay extends StatefulWidget {
  EmptyChartDisplay(this.currTabIndex, {super.key});
  int currTabIndex;

  @override
  State<StatefulWidget> createState() {
    return EmptyChartDisplayState();
  }
}

class EmptyChartDisplayState extends State<EmptyChartDisplay> {
  String? chartId;
  Chart? chart;

  @override
  Widget build(BuildContext context) {
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
                                widget.currTabIndex,
                                Chart.emptyChart,
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
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return JoinChartPopupContent(
                              index: widget.currTabIndex,
                            );
                          },
                        );
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
