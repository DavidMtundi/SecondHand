import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Import the firebase_core plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:mustapp/counters/AdressChanger.dart';
import 'package:mustapp/counters/ItemQuantity.dart';
import 'package:mustapp/counters/TotalAmount.dart';
import 'package:mustapp/finalproperties/EcommerceApp.dart';
import 'package:mustapp/counters/cartitemcounter.dart';
import 'package:mustapp/screens/home.dart';
import 'package:mustapp/screens/otherhome.dart';
import 'package:mustapp/splash/splashscreen.dart';
import 'package:mustapp/utils/constant.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  EcommercApp.auth = FirebaseAuth.instance;
  EcommercApp.preferences = await SharedPreferences.getInstance();
  // final SharedPreferences preferences = await EcommercApp.preferen;
  EcommercApp.firestore = FirebaseFirestore.instance;
  runApp(const App());
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  // Create the initialization Future outside of `build`:
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  void initState() {
    super.initState();
  } //this checks to see whether the user is already logged in

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (C) => CartItemCounter()),
        ChangeNotifierProvider(create: (C) => ItemQuantity()),
        ChangeNotifierProvider(create: (C) => AddressChanger()),
        ChangeNotifierProvider(create: (C) => TotalAmount()),
      ],
      child: OverlaySupport(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            dividerColor: const Color(0xFFECEDF1),
            brightness: Brightness.light,
            backgroundColor: Colors.white,
            primaryColor: const Color(0xFFF93963),
            fontFamily: 'Montserrat',
            textTheme: const TextTheme(
              headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
              subtitle1: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
              subtitle2: TextStyle(fontSize: 16),
              bodyText1: TextStyle(fontSize: 14.0, fontFamily: 'Montserrat'),
              headline2: TextStyle(
                  fontSize: 14.0,
                  fontFamily: 'Montserrat1',
                  color: Colors.white),
              headline3: TextStyle(
                  fontSize: 14.0,
                  fontFamily: 'Montserrat',
                  color: Colors.black54),
            ),
            colorScheme:
                ColorScheme.fromSwatch().copyWith(secondary: Colors.cyan[600]),
          ),
          home: FutureBuilderWidget(initialization: _initialization),
        ),
      ),
    );
  }
}

class FutureBuilderWidget extends StatelessWidget {
  const FutureBuilderWidget({
    Key? key,
    required Future<FirebaseApp> initialization,
  })  : _initialization = initialization,
        super(key: key);

  final Future<FirebaseApp> _initialization;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          // Navigator.push(
          //    context,
          //    MaterialPageRoute(
          //       builder: (context) => SomethingWentWrongScreen()));
          return Container(
              child: Center(
            child: Text("Something went wrong"),
          ));
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          //Navigator.pushReplacement(context,
          //  MaterialPageRoute(builder: (context) => LoginScreen()));
          return const AuthenticateScreen();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

class AuthenticateScreen extends StatefulWidget {
  const AuthenticateScreen({Key? key}) : super(key: key);

  @override
  _AuthenticateScreenState createState() => _AuthenticateScreenState();
}

class _AuthenticateScreenState extends State<AuthenticateScreen> {
  @override
  void initState() {
    super.initState();
    displaySplash();
  }

  void displaySplash() {
    Timer(const Duration(seconds: 5), () async {
      Route defaultroute = MaterialPageRoute(builder: (_) => const OtherHome());

      if (EcommercApp.user != null) {
        Route route = MaterialPageRoute(builder: (_) => const Home());
        Navigator.pushReplacement(context, route);
      } else {
        Route route = MaterialPageRoute(builder: (_) => SplashScreen());

        Navigator.pushReplacement(context, route);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      customscreenheight = MediaQuery.of(context).size.height;
      customscreenwidth = MediaQuery.of(context).size.width;
    });
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/welcome.png"),
                fit: BoxFit.fitWidth)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              height: CustomHeight(context, 12),
            ),
            Center(
                child: Text(
              "Buy & Sell Products",
              style: TextStyle(fontSize: customfont(context, 16)),
            )),
            SizedBox(
              height: CustomHeight(context, 20),
            ),
          ],
        ),
      ),
    );
  }
}
