import 'dart:async';

import 'package:chore_app/Providers/ChartProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:provider/provider.dart';

class ChangeTitleWidget extends StatefulWidget {
  ChangeTitleWidget(
      {required this.oldTitle,
      required this.currTabIndex,
      required this.updateParent,
      super.key});
  String oldTitle;
  int currTabIndex;
  Function updateParent;

  @override
  State<ChangeTitleWidget> createState() => ChangeTitleWidgetState();
}

class ChangeTitleWidgetState extends State<ChangeTitleWidget> {
  TextEditingController controller = TextEditingController();
  late StreamSubscription<bool> keyboardSubscription;

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    keyboardSubscription.cancel();
  }

  @override
  void initState() {
    super.initState();
    var keyboardVisibilityController = KeyboardVisibilityController();

    keyboardSubscription =
        keyboardVisibilityController.onChange.listen((bool visible) {
      if (!visible) {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
          setState(() {
            widget.updateParent();
          });
        }
      }
    });

    controller.text = widget.oldTitle;
    controller.addListener(() {
      if (widget.oldTitle != controller.text) {
        Provider.of<ChartProvider>(context, listen: false)
            .updateChartTitle(widget.currTabIndex, controller.text);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    TextStyle currStyle = TextStyle(
      fontSize: Theme.of(context).textTheme.headlineLarge?.fontSize,
      color: Theme.of(context).textTheme.headlineMedium?.color,
    );
    return Theme(
      data: ThemeData(
        inputDecorationTheme: const InputDecorationTheme(
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          fillColor: Colors.white,
        ),
      ),
      child: TextFormField(
        autofocus: true,
        textAlign: TextAlign.center,
        textAlignVertical: TextAlignVertical.center,
        controller: controller,
        style: currStyle,
        cursorColor: Colors.white,
      ),
    );
  }
}
