import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:mustapp/screens/defaultscreen.dart';
import 'package:mustapp/screens/login.dart';
import 'package:mustapp/splash/splashcontent.dart';
import 'package:mustapp/utils/constant.dart';
import 'package:mustapp/utils/util.dart';
import 'package:mustapp/widgets/submitbutton.dart';

// This is the best practice

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int currentPage = 0;
  List<Map<String, String>> splashData = [
    {
      "text": "Welcome to Must Market Place, Let’s shop!",
      "image": "assets/images/splash_1.png"
    },
    {
      "text":
          "We help Buyers Connect with Sellers \naround Meru, specifically Meru University",
      "image": "assets/images/splash_2.png"
    },
    {
      "text": "We show the easy way to shop cheap. \nJust stay at home with us",
      "image": "assets/images/splash_3.png"
    },
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: PageView.builder(
                onPageChanged: (value) {
                  setState(() {
                    currentPage = value;
                  });
                },
                itemCount: splashData.length,
                itemBuilder: (context, index) => SplashContent(
                  image: splashData[index]["image"],
                  text: splashData[index]['text'],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: CustomWidth(context, 20)),
                child: Column(
                  children: <Widget>[
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        splashData.length,
                        (index) => buildDot(index: index),
                      ),
                    ),
                    Spacer(flex: 3),
                    SubmitButton(
                      title: "Continue",
                      act: () async {
                        var result = await Connectivity().checkConnectivity();
                        if (result == ConnectivityResult.none) {
                          await showconnectivitysnackbar(context, result);
                        }
                        //anonymous login then access the application
                     
                        Route route =
                            MaterialPageRoute(builder: (c) => defaultscreen());
                        Navigator.pushReplacement(context, route);
                      },
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AnimatedContainer buildDot({int? index}) {
    return AnimatedContainer(
      duration: kAnimationDuration,
      margin: EdgeInsets.only(right: 5),
      height: 6,
      width: currentPage == index ? 20 : 6,
      decoration: BoxDecoration(
        color: currentPage == index ? kPrimaryColor : Color(0xFFD8D8D8),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
