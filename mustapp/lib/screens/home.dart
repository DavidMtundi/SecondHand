import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mustapp/finalproperties/EcommerceApp.dart';
import 'package:mustapp/itemscreeens/CategoryItem.dart';
import 'package:mustapp/itemscreeens/TrendingItemUpdated.dart';
import 'package:mustapp/models/CategoryModelUpdated.dart';
import 'package:mustapp/counters/cartitemcounter.dart';
import 'package:mustapp/models/productmodel.dart';
import 'package:mustapp/screens/adminlogin.dart';
import 'package:mustapp/screens/adminregister.dart';
import 'package:mustapp/screens/homeupdated.dart';
import 'package:mustapp/screens/login.dart';

import 'package:mustapp/screens/search.dart';
import 'package:mustapp/screens/shoppingcart.dart';
import 'package:mustapp/utils/constant.dart';
import 'package:mustapp/utils/navigator.dart';
import 'package:page_transition/page_transition.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}
//LOAD ALL PRODUCTS FIRST FROM THE DATABASE
//GET PRODUCTS WITH A HIGHER SELLER SCORE FROM THE DATABASE
//GET PRODUCTS

class _HomeState extends State<Home> {
  int currentIndex = 0;
  String? picturepath =
      EcommercApp.preferences!.getString(EcommercApp.userPhotoUrl);
  String actualpath = "";
  @override
  void initState() {
    super.initState();
    findpicture();
  }

  void findpicture() {
    if (picturepath != null) {
      setState(() {
        EcommercApp.currentuserPhotUrl = picturepath!;
      });
    }
  }

  late String countervalue;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        drawer: Drawer(child: leftDrawerMenu()),

        appBar: buildAppBar(context),
        // ignore: unnecessary_new
        bottomNavigationBar: new TabBar(
          tabs: [
            Tab(
              icon: Icon(Icons.home),
            ),
            Tab(
              icon: Icon(
                Icons.category_rounded,
                size: customfont(context, 40),
              ),
            ),
            Tab(
              icon: Icon(Icons.shopping_cart),
            ),
          ],
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Colors.blueGrey,
          indicatorSize: TabBarIndicatorSize.label,
          indicatorPadding: const EdgeInsets.all(8.0),
          indicatorColor: Colors.red,
        ),
        body: TabBarView(
          children: [
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  buildCarouselSlider(),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Row(
                      children: <Widget>[
                        const Expanded(
                          child: Text(
                            "All Products",
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.fade,
                                    // child: ProductList(
                                    //   product: prd,
                                    // ),
                                    child: HomeUpdated(
                                      searchstring: "All",
                                    )),
                              );
                            },
                            child: Text(
                              "View All",
                              style: TextStyle(
                                  fontSize: customfont(context, 15),
                                  decoration: TextDecoration.underline,
                                  color: Colors.blue),
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  BuildServices("All"),
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Row(
                      children: <Widget>[
                        const Expanded(
                          child: Text(
                            "Dressing",
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.fade,
                                    // child: ProductList(
                                    //   product: prd,
                                    // ),
                                    child: HomeUpdated(
                                      searchstring: "Dressing",
                                    )),
                              );
                            },
                            child: Text(
                              "View All",
                              style: TextStyle(
                                  fontSize: customfont(context, 15),
                                  decoration: TextDecoration.underline,
                                  color: Colors.blue),
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  BuildServices("Dressing"),
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            "Electronics",
                            style: TextStyle(
                                fontSize: customfont(context, 20),
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.fade,
                                    // child: ProductList(
                                    //   product: prd,
                                    // ),
                                    child: HomeUpdated(
                                      searchstring: "Electronics",
                                    )),
                              );
                            },
                            child: Text(
                              "View All",
                              style: TextStyle(
                                  fontSize: customfont(context, 15),
                                  decoration: TextDecoration.underline,
                                  color: Colors.blue),
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  BuildServices("Electronics"),
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Row(
                      children: <Widget>[
                        const Expanded(
                          child: Text(
                            "Home Products",
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.fade,
                                    // child: ProductList(
                                    //   product: prd,
                                    // ),
                                    child: HomeUpdated(
                                      searchstring: "Home",
                                    )),
                              );
                            },
                            child: const Text(
                              "View All",
                              style:
                                  TextStyle(fontSize: 18.0, color: Colors.blue),
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  BuildServices("Home"),
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Row(
                      children: <Widget>[
                        const Expanded(
                          child: Text(
                            "Furniture",
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.fade,
                                    // child: ProductList(
                                    //   product: prd,
                                    // ),
                                    child: HomeUpdated(
                                      searchstring: "Furniture",
                                    )),
                              );
                            },
                            child: const Text(
                              "View All",
                              style:
                                  TextStyle(fontSize: 18.0, color: Colors.blue),
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  BuildServices("Furniture"),
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Row(
                      children: <Widget>[
                        const Expanded(
                          child: Text(
                            "Services",
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.fade,
                                    // child: ProductList(
                                    //   product: prd,
                                    // ),
                                    child: HomeUpdated(
                                      searchstring: "Services",
                                    )),
                              );
                            },
                            child: const Text(
                              "View All",
                              style:
                                  TextStyle(fontSize: 18.0, color: Colors.blue),
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  BuildServices("Services"),
                ],
              ),
            ),
            Padding(
                padding: EdgeInsets.only(
                    left: 13,
                    right: 8.0,
                    top: CustomHeight(context, 8),
                    bottom: CustomHeight(context, 8)),
                child: CustomScrollView(
                  //  scrollDirection: Axis.horizontal,
                  // shrinkWrap: true,
                  slivers: <Widget>[
                    SliverStaggeredGrid.countBuilder(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 12,
                        staggeredTileBuilder: (index) =>
                            StaggeredTile.count(1, index.isEven ? 1.42 : 1.5),
                        itemBuilder: (context, index) {
                          return CategoryItem(
                            imagepath: AllCategories[index].imagename,
                            description:
                                AllCategories[index].Description.toString(),
                            title: AllCategories[index].title.toString(),
                          );
                        },
                        itemCount: AllCategories.length)
                  ],
                )),
            //  const WhellFortune(),
            ShoppingCart(false),
            // UserSettings(),
          ],
        ),
      ),
    );
  }

  Container BuildServices(String searchstring) {
    return Container(
      height: CustomHeight(context, 270) > 268
          ? CustomHeight(context, 230)
          : CustomHeight(context, 300),
      child:
          // Column(
          //   mainAxisSize: MainAxisSize.min,
          //   children: [
          StreamBuilder<QuerySnapshot>(
        stream: searchstring == "All"
            ? FirebaseFirestore.instance.collection('items').where("productstock",isGreaterThan: 0).snapshots()
            : FirebaseFirestore.instance
                .collection('items')
                .where("productcategory", isEqualTo: searchstring.toString()).where("productstock",isGreaterThan: 0)
                .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            //   progressDialog.show();
            //show the progress indicator , please wait
              return Image.asset("assets/images/pleasewait.gif",width:CustomWidth(context, 120),height: CustomHeight(context, 80),);
            //return CircularProgressIndicator(semanticsLabel: "Loading");
          }

          //if(snapshot.connectionState == ConnectionState.done){
          return snapshot.data != null
              ? Container(
                  child: snapshot.data!.docs.length > 0
                      ? ListView.builder(
                          shrinkWrap: true,
                          //  controller: _scrollController,
                          // physics: NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (BuildContext context, int index) {
                            Productmodel model = Productmodel.fromJson(
                                snapshot.data!.docs[index].data()
                                    as Map<String, dynamic>);

                            return TrendingItemUpdated(
                                product: model,
                                gradientColors: const [
                                  Color(0XFFa466ec),
                                  Color(0XFFa466ec)
                                ]);
                            //  : SizedBox.shrink();
                          })
                      : Center(
                          child: Text("No ${searchstring}s Found"),
                        ),
                )
              : Center(
                  child: Text("No ${searchstring}s Found"),
                );
          // }
        },
      ),
      //   ],
      // ),
    );
  }

  CarouselSlider buildCarouselSlider() {
    return CarouselSlider(
      items: imgList.map(
        (url) {
          return Stack(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.all(5.0),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                  child: Image.asset(
                    url,
                    fit: BoxFit.cover,
                    width: CustomWidth(context, 800),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Nchiru Ecommerce",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: customfont(context, 17)),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text("All Product",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: customfont(context, 14))),
                      ),
                    ],
                  ),
                ),
              )
            ],
          );
        },
      ).toList(),
      options: CarouselOptions(),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    var item = CartItemCounter().count.toString();
    if (item.isNotEmpty) {
    }
    return AppBar(
      title: Text(
        "Must Products",
        style:
            TextStyle(color: Colors.black, fontSize: customfont(context, 16)),
      ),
      leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.black),
          onPressed: () => _scaffoldKey.currentState!.openDrawer()),
      actions: [
        SizedBox(width: CustomWidth(context, 13)),
        GestureDetector(
          onTap: () {
          Nav.route(context, Search());
          },
          child: Icon(
            Icons.search_rounded,
            color: Colors.black,
          ),
        ),
        Stack(
          children: <Widget>[
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
          ],
        ),
      ],
    );
  }

  leftDrawerMenu() {
    Color blackColor = Colors.black.withOpacity(0.6);
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.zero,
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            height: CustomHeight(context, 150),
            child: DrawerHeader(
              child: ListTile(
                trailing: Icon(
                  Icons.chevron_right,
                  size: customfont(context, 28),
                ),
                title: EcommercApp.auth.currentUser != null
                    ?EcommercApp.auth.currentUser!.email!=null? Flexible(
                      child: Text(
                          EcommercApp.auth.currentUser!.email!.toString(),
                          style: TextStyle(
                              fontSize: customfont(context, 14),
                              fontWeight: FontWeight.w600,
                              color: blackColor),
                        ),
                    )
                    : Text("Not Logged In"):Text("Not Logged in"),
                leading: EcommercApp.currentuserPhotUrl != ""
                    ? CircleAvatar(
                        backgroundImage:
                            NetworkImage(EcommercApp.currentuserPhotUrl))
                    : Icon(
                        Icons.person,
                        size: customfont(context, 50),
                      ),
              ),
              decoration: const BoxDecoration(
                color: Color(0xFFF8FAFB),
              ),
            ),
          ),
          SizedBox(height: CustomHeight(context, 10)),
          ListTile(
            leading: Icon(
              Icons.home,
              color: blackColor,
            ),
            title: Text(
              'Home',
              style: TextStyle(
                  fontSize: customfont(context, 16),
                  fontWeight: FontWeight.w600,
                  color: blackColor),
            ),
            onTap: () {
              Navigator.pushReplacement(
                context,
                PageTransition(
                  type: PageTransitionType.fade,
                  child: Home(),
                ),
              );
            },
          ),
          ExpansionTile(
            title: Text("Want to be a Seller ? ",
                style: TextStyle(
                    fontSize: customfont(context, 18),
                    fontWeight: FontWeight.w600,
                    color: blackColor)),
            leading: const Icon(
              Icons.sell_rounded,
              color: Colors.redAccent,
            ),
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      PageTransition(
                        type: PageTransitionType.fade,
                        child: AdminRegisterscreen(),
                      ),
                    );
                  },
                  child: Text("Register as Seller",
                      style: TextStyle(
                          fontSize: customfont(context, 16),
                          fontWeight: FontWeight.w600,
                          color: blackColor))),
              TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      PageTransition(
                        type: PageTransitionType.fade,
                        child: AdminLoginScreen(),
                      ),
                    );
                  },
                  child: Text("Login as Seller",
                      style: TextStyle(
                          fontSize: customfont(context, 16),
                          fontWeight: FontWeight.w600,
                          color: blackColor))),
            ],
          ),
          ListTile(
            leading: Icon(Icons.logout, color: blackColor),
            title: Text('Log Out',
                style: TextStyle(
                    fontSize: customfont(context, 16),
                    fontWeight: FontWeight.w600,
                    color: blackColor)),
            onTap: () async {
              await sighnout();
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app, color: blackColor),
            title: Text('Quit',
                style: TextStyle(
                    fontSize: customfont(context, 16),
                    fontWeight: FontWeight.w600,
                    color: blackColor)),
            onTap: () {
              SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            },
          ),
        ],
      ),
    );
  }

  sighnout() async {
    await EcommercApp.auth.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => LoginScreen()));
  }
}
