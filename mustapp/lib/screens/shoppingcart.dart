import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:mustapp/finalproperties/EcommerceApp.dart';
import 'package:mustapp/itemscreeens/TrendingItemUpdated.dart';
import 'package:mustapp/models/productmodel.dart';
import 'package:mustapp/utils/constant.dart';

// ignore: must_be_immutable
class ShoppingCart extends StatefulWidget {
  bool showAppBar = true;

  ShoppingCart(this.showAppBar, {Key? key}) : super(key: key);

  _ShoppingCartState createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  int shoppingCartCount = 1;
  String customtext = "Show Phone";
  @override
  void initState() {
    super.initState();
    cleareverything();
    loadallthedata();
  }

  cleareverything() async {
    await listofdocids.clear;
  }

  loadallthedata() async {
    List<String>? tempcartList =
        EcommercApp.preferences!.getStringList(EcommercApp.usercartList);

    if (tempcartList != null) {
      for (var item in tempcartList) {
        if (!listofdocids.contains(item) &&
            item != "garbageValue" &&
            item != "") {
          //listofdocids.remove("");
          setState(() {
            listofdocids.add(item.toString());
          });
        }
        print("One of the Items are:: " + item.toString());
      }
    }

    //tempcartList!.add(shortinfoasid);
  }

  //load the shopping cart from firebase
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: widget.showAppBar
            ? AppBar(
                title: const Text(
                  "Shopping Cart",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
                backgroundColor: Colors.white,
              )
            : null,
        body: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            if (listofdocids.length > 0)
              for (var item in listofdocids)
                if (item != "")
                  Dismissible(
                    key: UniqueKey(),
                    child: loadallitems(item.toString()),
                    onDismissed: (direction) async {
                      await removeItemToCart(item.toString(), context);
                      await listofdocids.remove(item);
                    },
                  ),
            if (listofdocids.length < 1)
              Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: customdivideheight(context, 9),
                    ),
                    Icon(
                      Icons.shopping_cart_outlined,
                      size: 40,
                    ),
                    SizedBox(
                      height: CustomHeight(context, 20),
                    ),
                    Image.asset(
                      "assets/images/emptycart.gif",
                      //color: kTextColor,
                      width: CustomWidth(context, 300),
                      height: CustomHeight(context, 300),
                    ),
                    // Icon(
                    //   Icons.shopping_cart_outlined,
                    //   size: 23,
                    // ),
                    SizedBox(
                      height: CustomHeight(context, 20),
                    ),
                    Text(
                      "Shopping Cart Empty",
                      style: TextStyle(fontSize: 22),
                    ),
                  ],
                ),
              )
          ],
        )));
  }

  List listofdocids = [];

  Container loadallitems(String indexvalue) {
    return Container(
      height: CustomHeight(context, 280),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('items')
            .where("productid", isEqualTo: indexvalue.toString())
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            //   progressDialog.show();
            //show the progress indicator , please wait
            return const Text("Loading Please Wait");
            //return CircularProgressIndicator(semanticsLabel: "Loading");
          }
          Productmodel model = Productmodel.fromJson(
              snapshot.data!.docs[0].data() as Map<String, dynamic>);
          return snapshot.data!.docs.length > 0
              ? model.stock > 0
                  ? buildShoppingCartItem(model, context)
                  : buildsolditem(model, context)
              : Center(
                  child: Text("No Item Here"),
                );
        },
      ),
    );
  }

  Container buildsolditem(Productmodel model, BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
      height: CustomHeight(context, 273),
      child: Card(
        child: Column(
          children: [
            Container(
              child: Center(
                child: Text("<Swipe to Remove from Cart>"),
              ),
              padding: EdgeInsets.only(top: 10, bottom: 30),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  width: customdividewidth(context, 3),
                  child: Column(
                    children: <Widget>[
                      Container(
                          height: CustomHeight(context, 120),
                          width: CustomWidth(context, 160),
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: Image.asset("/assets/imagesold.png")),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text(
                              'Quantity: ' + '0',
                              style:
                                  TextStyle(fontSize: customfont(context, 18)),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Container buildShoppingCartItem(Productmodel model, BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
      height: CustomHeight(context, 273),
      child: Card(
        child: Column(
          children: [
            Container(
              child: Center(
                child: Text("<Swipe to Remove from Cart>"),
              ),
              padding: EdgeInsets.only(top: 10, bottom: 30),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  width: customdividewidth(context, 3),
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: CustomHeight(context, 120),
                        width: CustomWidth(context, 160),
                        decoration: const BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: CachedNetworkImage(
                          imageUrl: model.imageurl,
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) => Center(
                            child: CircularProgressIndicator(
                              value: downloadProgress.progress,
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                          // model.imageurl,
                          //width: 150,
                          // height: 140,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text(
                              'Quantity: ' + '$shoppingCartCount',
                              style:
                                  TextStyle(fontSize: customfont(context, 18)),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  width: customdividewidth(context, 2),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.only(left: 12.0),
                            width: CustomWidth(context, 130),
                            child: Flexible(
                              child: Text(
                                model.title,
                                style: TextStyle(
                                    fontSize: customfont(context, 16)),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 6.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Flexible(
                                child: Text(
                                  "kshs " + model.price,
                                  style: TextStyle(
                                      fontSize: customfont(context, 14),
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 4, right: 4, bottom: 5.0),
                              child: Row(
                                children: [
                                  Container(
                                    child: ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            customtext =
                                                model.sellerphone.toString();
                                          });
                                        },
                                        child: Text(customtext.toString())),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
