import 'package:flutter/material.dart';
import 'package:mustapp/counters/cartitemcounter.dart';
import 'package:mustapp/models/productmodel.dart';
import 'package:mustapp/screens/shoppingcart.dart';
import 'package:mustapp/search_result/search_result_screen.dart';
import 'package:mustapp/utils/constant.dart';
import 'package:mustapp/utils/util.dart';
import 'package:mustapp/widgets/search_field.dart';
import 'package:page_transition/page_transition.dart';

class HomeHeader extends StatelessWidget {
  final Function onSearchSubmitted;
  // final Function onCartButtonPressed;
  const HomeHeader({
    Key? key,
    required this.onSearchSubmitted,
    //required this.onCartButtonPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            }),
        SizedBox(width: CustomWidth(context, 5)),
        Expanded(
          /// child: TextField(),
          child: SearchField(),
        ),
        SizedBox(width: 5),
        Container(
          child: Stack(
            children: [
              IconButton(
                icon: Icon(
                  Icons.shopping_cart_outlined,
                ),
                color: Colors.black,
                onPressed: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.fade,
                      child: ShoppingCart(true),
                    ),
                  );
                },
              ),
              Positioned(
                  child: Stack(
                children: [
                  const Icon(Icons.brightness_1, size: 20, color: Colors.green),
                  Positioned(
                      top: 2,
                      bottom: 4,
                      left: 3,
                      //   child: Text(""),
                      // )
                      child: Text(CartItemCounter().count.toString()))
                ],
              ))
            ],
          ),
        ),
      ],
    );
  }
}
