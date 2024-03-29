import 'dart:async';

import 'package:chore_app/Providers/TextSizeProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:provider/provider.dart';

import '../../../Global.dart';
import '../../../Models/frozen/Chart.dart';

class ChangeTitleWidget extends StatefulWidget {
  ChangeTitleWidget(
      {required this.oldTitle,
      required this.currTabIndex,
      required this.updateParent,
      required this.currChart,
      super.key});
  String oldTitle;
  int currTabIndex;
  Chart currChart;
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

  dismissKeyboardAfterNormalDismisal() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
      updateParent();
    }
  }

  updateParent() {
    setState(() {
      widget.updateParent(widget.currChart, controller.text);
    });
  }

  @override
  void initState() {
    super.initState();
    var keyboardVisibilityController = KeyboardVisibilityController();

    keyboardSubscription =
        keyboardVisibilityController.onChange.listen((bool visible) {
      if (!visible) {
        dismissKeyboardAfterNormalDismisal();
      }
    });

    controller.text = widget.oldTitle;
    controller.addListener(() {
      if (widget.oldTitle != controller.text) {
        // if (Global.editedTitles.containsKey(widget.currTabIndex)) {
        //   Global.editedTitles
        //       .update(widget.currTabIndex, (value) => controller.text);
        // } else {
        //   Global.editedTitles
        //       .putIfAbsent(widget.currTabIndex, () => controller.text);
        // }
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Global.titleFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle currStyle = TextStyle(
      fontSize: (Theme.of(context).textTheme.headlineLarge?.fontSize
              as double) +
          Provider.of<TextSizeProvider>(context, listen: false).fontSizeToAdd,
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
        focusNode: Global.titleFocusNode,
        textAlign: TextAlign.center,
        textAlignVertical: TextAlignVertical.center,
        controller: controller,
        style: currStyle,
        cursorColor: Colors.white,
      ),
    );
  }
}
