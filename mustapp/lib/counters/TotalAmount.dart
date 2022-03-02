import 'package:flutter/material.dart';

class TotalAmount extends ChangeNotifier {
  double _totalamountvalue = 0;
  double get totalamount => _totalamountvalue;

  display(double value) async {
    _totalamountvalue = value;

    await Future.delayed(const Duration(milliseconds: 100), () {
      notifyListeners();
    });
    notifyListeners();
  }
}
