import 'package:flutter/widgets.dart';
import 'package:mustapp/finalproperties/EcommerceApp.dart';

class CartItemCounter extends ChangeNotifier {
  // int _counter = 0;
  int _counter =
      EcommercApp.preferences!.getStringList(EcommercApp.usercartList) != null
          ? EcommercApp.preferences!
                  .getStringList(EcommercApp.usercartList)!
                  .length -
              1
          : 0;

  int get count => _counter;

  Future<void> displayResult() async {
    _counter = await EcommercApp.preferences!
            .getStringList(EcommercApp.usercartList)!
            .length -
        1;
    await Future.delayed(const Duration(milliseconds: 30), () {
      notifyListeners();
    });
  }
}
