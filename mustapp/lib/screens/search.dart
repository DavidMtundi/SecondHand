import 'package:flutter/material.dart';
import 'package:mustapp/utils/constant.dart';
import 'package:mustapp/utils/util.dart';
import 'package:mustapp/widgets/search_field.dart';

class Search extends StatefulWidget {
  Search({Key? key}) : super(key: key);

  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 28.0),
            child: Column(
              children: [
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(30)),
                  // padding: EdgeInsets.only(
                  //   top: 45.0,
                  //   left: 24.0,
                  //   right: 24.0,
                  // ),
                  child: SearchField(),
                ),
                SizedBox(
                  height: CustomHeight(context, 60),
                ),
                Center(
                  child: searching
                      ? Text("Loading please wait")
                      : Text(
                          "Please Search Here and click done in the keyboard"),
                ),
                SizedBox(
                  height: 10,
                ),
                searching
                    ? Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20)
                            //color: Color(0xFF4aa0d5),
                            ),
                        child: Image.asset(
                          "assets/downloading.gif",
                          height: CustomHeight(context, 250.0),
                          width: CustomWidth(context, 250.0),
                          fit: BoxFit.fill,
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                            //  color: Color(0xFF4aa0d5),
                            ),
                        child: Image.asset(
                          "assets/gosearch.gif",
                          height: CustomHeight(context, 250.0),
                          width: CustomWidth(context, 250.0),
                          fit: BoxFit.fill,

                          //  color:Colors.white
                        ),
                      ),
                if (searching) Text("Please Wait")
              ],
            ),
          ),
        ),
      ),
    );
  }
}
