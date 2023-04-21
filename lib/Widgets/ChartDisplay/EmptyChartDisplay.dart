import 'package:chore_app/Providers/TextSizeProvider.dart';
import 'package:chore_app/Screens/ChartScreen.dart';
import 'package:chore_app/Services/ListenService.dart';
import 'package:chore_app/Widgets/ChartDisplay/JoinChartDialogPopup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../ColorControl/AppColors.dart';
import '../../Models/frozen/Chart.dart';
import '../../Models/frozen/UserModel.dart';
import '../../Screens/ScreenArguments/newChartArguments.dart';

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
    UserModel currUser = ListenService.userNotifier.value;
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
                            return const JoinChartPopupContent();
                          },
                        );
                        // chartId = await prompt(
                        //   Global.scaffoldKey.currentContext as BuildContext,
                        //   title: const Text('Please enter Chart Code:'),
                        //   initialValue: '',
                        //   isSelectedInitialValue: false,
                        //   textOK: const Text('OK'),
                        //   textCancel: const Text('Cancel'),
                        //   hintText: '',
                        //   validator: (String? value) {
                        //     if (value == null ||
                        //         value.isEmpty ||
                        //         value.length != 8) {
                        //       String errorString = 'Invalid Chart Code Entered';
                        //       return errorString;
                        //     }
                        //     return null;
                        //   },
                        //   minLines: 1,
                        //   maxLines: 1,
                        //   autoFocus: true,
                        //   barrierDismissible: true,
                        //   textCapitalization: TextCapitalization.none,
                        //   textAlign: TextAlign.left,
                        // );
                        // showGeneralDialog(
                        //     context: context,
                        //     barrierDismissible: true,
                        //     barrierLabel: MaterialLocalizations.of(context)
                        //         .modalBarrierDismissLabel,
                        //     barrierColor: Colors.black45,
                        //     transitionDuration:
                        //         const Duration(milliseconds: 200),
                        //     pageBuilder: (BuildContext buildContext,
                        //         Animation animation,
                        //         Animation secondaryAnimation) {
                        //       return Center(
                        //         child: Container(
                        //           width: MediaQuery.of(context).size.width - 10,
                        //           height:
                        //               MediaQuery.of(context).size.height - 80,
                        //           padding: EdgeInsets.all(20),
                        //           color: Colors.white,
                        //           child: Column(
                        //             children: [
                        //               ElevatedButton(
                        //                 onPressed: () {
                        //                   Navigator.of(context).pop();
                        //                 },
                        //                 child: Text(
                        //                   "Save",
                        //                   style: TextStyle(color: Colors.white),
                        //                 ),
                        //                 // color: const Color(0xFF1BC0C5),
                        //               )
                        //             ],
                        //           ),
                        //         ),
                        //       );
                        //     });
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
