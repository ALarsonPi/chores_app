import 'package:flutter/material.dart';

class FutureDataProvider extends ChangeNotifier {
  late Future dataFuture = Future.delayed(const Duration(seconds: 0));

  updateDataFuture(Future newFuture) async {
    dataFuture = newFuture;
    notifyListeners();
  }
}
