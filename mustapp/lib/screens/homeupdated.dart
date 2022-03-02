import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mustapp/counters/cartitemcounter.dart';
import 'package:mustapp/itemscreeens/TrendingItemUpdated.dart';
import 'package:mustapp/models/productmodel.dart';
import 'package:mustapp/screens/search.dart';
import 'package:mustapp/screens/shoppingcart.dart';
import 'package:mustapp/utils/constant.dart';
import 'package:page_transition/page_transition.dart';

class HomeUpdated extends StatefulWidget {
  HomeUpdated({Key? key, this.searchstring = "All"}) : super(key: key);

  final String searchstring;

  @override
  _HomeUpdatedState createState() => _HomeUpdatedState();
}

class _HomeUpdatedState extends State<HomeUpdated> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(context),
        body: StreamBuilder<QuerySnapshot>(
          stream: widget.searchstring == "All"
              ? FirebaseFirestore.instance.collection('items').snapshots()
              : FirebaseFirestore.instance
                  .collection('items')
                  .where("productcategory",
                      isEqualTo: widget.searchstring.toString()).where("productstock",isGreaterThan: 0)
                  .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              //   progressDialog.show();
              //show the progress indicator , please wait
              return Image.asset("assets/images/pleasewait.gif",width:customdividewidth(context, 1.4),height: CustomHeight(context, 80),);
              
              //return CircularProgressIndicator(semanticsLabel: "Loading");
            }
            // progressDialog.hide();
            //if(snapshot.connectionState == ConnectionState.done){
            return Padding(
              padding: const EdgeInsets.only(
                  left: 13, right: 8.0, top: 8, bottom: 8),
              child: snapshot.data!.docs.length > 0
                  ? CustomScrollView(
                      //  scrollDirection: Axis.horizontal,
                      // shrinkWrap: true,
                      slivers: <Widget>[
                        SliverStaggeredGrid.countBuilder(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 12,
                            staggeredTileBuilder: (index) =>
                                StaggeredTile.count(
                                    1, index.isEven ? 1.33 : 1.43),
                            itemBuilder: (context, index) {
                              Productmodel model = Productmodel.fromJson(
                                  snapshot.data!.docs[index].data()
                                      as Map<String, dynamic>);
                              return TrendingItemUpdated(
                                  product: model,
                                  gradientColors: const [
                                    Color(0XFFa466ec),
                                    Color(0XFFa466ec)
                                  ]);
                            },
                            itemCount: snapshot.data!.docs.length)
                      ],
                    )
                  : Center(
                      child: Text("No ${widget.searchstring}s Found"),
                    ),
            );
            // }
          },
        ));
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        widget.searchstring != "All"
            ? "All ${widget.searchstring.toString()}"
            : "All Products",
        style: TextStyle(color: Colors.black, fontSize: 16),
      ),
      leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios, color: Colors.black)),
      actions: <Widget>[
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.fade,
                child: Search(),
              ),
            );
          },
          child: Icon(
            Icons.search,
            color: Colors.black,
          ),
        ),
        Stack(
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
                    child: Text(CartItemCounter().count.toString()))
              ],
            ))
          ],
        ),
      ],
      backgroundColor: Colors.white,
    );
  }
}
