import 'package:flutter/material.dart';
import 'package:mustapp/utils/constant.dart';

class SplashContent extends StatelessWidget {
  const SplashContent({
    Key? key,
    this.text,
    this.image,
  }) : super(key: key);
  final String? text, image;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Spacer(),
        Text(
          "MUST Market",
          style: TextStyle(
            fontSize: customfont(context, 36),
            color: kPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        Spacer(),
        Text(
          text!,
          textAlign: TextAlign.center,
        ),
        Spacer(flex: 2),
        Image.asset(
          image!,
          height: CustomHeight(context, 265),
          width: CustomWidth(context, 235),
        ),
      ],
    );
  }
}
