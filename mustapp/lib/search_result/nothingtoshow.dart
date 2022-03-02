import 'package:flutter/material.dart';
import 'package:mustapp/utils/constant.dart';
import 'package:mustapp/utils/util.dart';

class NothingToShowContainer extends StatefulWidget {
  final String iconPath;
  final String primaryMessage;
  final String secondaryMessage;

  const NothingToShowContainer({
    Key? key,
    this.iconPath = "assets/images/emptyboxes.gif",
    this.primaryMessage = "Nothing to show  😥",
    this.secondaryMessage = "Please Try a Different Search Keyword",
  }) : super(key: key);

  @override
  State<NothingToShowContainer> createState() => _NothingToShowContainerState();
}

class _NothingToShowContainerState extends State<NothingToShowContainer> {
  ///setState(() {
    ///});
  
  @override
  Widget build(BuildContext context) {
    
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.only(
            top: 30,
            left: 20,
            right: 20,
          ),

          ///  width: customdividewidth(context, 1.25),
          //height: customdivideheight(context, 8),
          child: Column(
            children: [
              Image.asset(
                widget.iconPath,
                //color: kTextColor,
                width: CustomWidth(context, 300),
                height: CustomHeight(context, 300),
              ),
              SizedBox(height: 16),
              Text(
                "${widget.primaryMessage}",
                style: TextStyle(
                  color: kTextColor,
                  fontSize: customfont(context, 18),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "${widget.secondaryMessage}",
                style: TextStyle(
                  color: kTextColor,
                  fontSize: customfont(context, 22),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
