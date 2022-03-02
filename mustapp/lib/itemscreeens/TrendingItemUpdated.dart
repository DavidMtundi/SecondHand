import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mustapp/counters/cartitemcounter.dart';
import 'package:mustapp/finalproperties/EcommerceApp.dart';
import 'package:mustapp/itemscreeens/Resetpassword.dart';
import 'package:mustapp/itemscreeens/productpageupdated.dart';
import 'package:mustapp/models/productmodel.dart';
import 'package:mustapp/utils/constant.dart';
import 'package:mustapp/utils/util.dart';
import 'package:mustapp/widgets/star_rating.dart';
import 'package:mustapp/widgets/submitbutton.dart';
import 'package:provider/provider.dart';

class TrendingItemUpdated extends StatefulWidget {
  final Productmodel product;
  final List<Color> gradientColors;
  final int size;
  final bool homepage;

  const TrendingItemUpdated(
      {Key? key,
      required this.product,
      this.homepage = false,
      required this.gradientColors,
      this.size = 18})
      : super(key: key);

  @override
  State<TrendingItemUpdated> createState() => _TrendingItemUpdatedState();
}

class _TrendingItemUpdatedState extends State<TrendingItemUpdated> {
  bool isloading =false;
  @override
  Widget build(BuildContext context) {
    double trendCardWidth = CustomWidth(context, 140);

    return GestureDetector(
      child: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius:
                    BorderRadius.all(Radius.circular(customfont(context, 15)))),
            width: trendCardWidth,
            child: Card(
              elevation: CustomHeight(context, 2),
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.all(CustomWidth(context, 5)),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        const Spacer(),
                        Icon(
                          Icons.verified,
                          color: Colors.black54,
                        )
                      ],
                    ),
                    _productImage(context),
                    _productDetails(context),
                 isloading?CustomLoadingWidget(text: "...",isitem:true):   SubmitButton(
                        resizableheight: true,
                        title: "Add",
                        act: () async {
                          setState(() {
                            isloading =true;
                          });
                          try {
                            checkIteminCart(widget.product.id, context);
                          } catch (e) {
                            setState(() {
                              isloading =false;
                            });
                          }
                          setState(() {
                            isloading =false;
                          });
                        })
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      onTap: () {
        Route route = MaterialPageRoute(
            builder: (c) => ProductPageUpdated(product: widget.product));
        Navigator.push(context, route);
        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //     builder: (context) => ProductPageUpdated(
        //       product: product,
        //     ),
        //   ),
        // );
      },
    );
  }

  _productImage(BuildContext context) {
    return Stack(
      children: <Widget>[
        Center(
          child: SizedBox(
            width: widget.homepage
                ? CustomWidth(context, 100)
                : CustomWidth(context, 150),
            height: CustomHeight(context, 70),
            // decoration: BoxDecoration(
            child: CustomCachedNetworkImage(
              product: widget.product,
              homepage: widget.homepage,
            ),
            //   ),
          ),
        )
      ],
    );
  }

  _productDetails(BuildContext context) {
    return Padding(
      padding:
          widget.size != 18 ? EdgeInsets.only(left: 10) : EdgeInsets.only(left: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.product.seller.toString(),
            style: const TextStyle(fontSize: 12, color: Color(0XFFb1bdef)),
          ),
          Text(
            widget.product.title.toString(),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
          ),
          StarRating(rating: 5, size: 10),
          Row(
            children: <Widget>[
              Text(widget.product.price.toString(),
                  style: TextStyle(
                      fontSize: customfont(context, 11),
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.lineThrough,
                      color: Colors.red)),
              SizedBox(
                width: 5,
              ),
              Text(
                "kshs: ${widget.product.discountprice.toString()}",
                style: TextStyle(
                    color: Colors.black45,
                    fontSize: customfont(context, 12),
                    fontWeight: FontWeight.w900),
              )
            ],
          ),
        ],
      ),
    );
  }
}

void checkIteminCart(String? shortinfoasid, BuildContext context) {
  EcommercApp.preferences!.getStringList(EcommercApp.usercartList) != null
      ? EcommercApp.preferences!
              .getStringList(EcommercApp.usercartList)!
              .contains(shortinfoasid)
          ? Fluttertoast.showToast(msg: "Item already in the cart")
          : addItemToCart(shortinfoasid!, context)
      : addItemToCart(shortinfoasid!, context);
}

addItemToCart(String? shortinfoasid, BuildContext context) async {
  print("passsed the first test");

  await Connectivity().checkConnectivity();

  List<String>? tempcartList = await EcommercApp.preferences != null
      ? EcommercApp.preferences!.getStringList(EcommercApp.usercartList) ?? []
      : [];
  tempcartList.add(shortinfoasid ?? "0");
  print("passsed the second test");
  try {
    EcommercApp.firestore
        .collection(EcommercApp.collectionUser)
        .doc(EcommercApp.preferences!.getString(EcommercApp.userUID))
        .update({EcommercApp.usercartList: tempcartList}).then((value) async {
      Fluttertoast.showToast(msg: "Item Added To Cart Successfully");
      EcommercApp.preferences!
          .setStringList(EcommercApp.usercartList, tempcartList);

      await Provider.of<CartItemCounter>(context, listen: false)
          .displayResult();
    }).onError((error, stackTrace) {
      print(error.toString());
      Fluttertoast.showToast(
          msg: "Unknown error, Please try Logging in as a Buyer to Access");
    });
  } catch (e) {
    Fluttertoast.showToast(msg: "Please Login as an Admin to Access");
  }
}

removeItemToCart(String? shortinfoasid, BuildContext context) async {
  var result = await Connectivity().checkConnectivity();
  if (result == ConnectivityResult.none) {
    await showconnectivitysnackbar(context, result);
  }
  List<String>? tempcartList =
      EcommercApp.preferences!.getStringList(EcommercApp.usercartList);
  tempcartList!.remove(shortinfoasid);

  EcommercApp.firestore
      .collection(EcommercApp.collectionUser)
      .doc(EcommercApp.preferences!.getString(EcommercApp.userUID))
      .update({EcommercApp.usercartList: tempcartList}).then((value) {
    Fluttertoast.showToast(msg: "Item Removed From Cart Successfully");
    EcommercApp.preferences!
        .setStringList(EcommercApp.usercartList, tempcartList);

    Provider.of<CartItemCounter>(context, listen: false).displayResult();
  });
}

class CustomCachedNetworkImage extends StatelessWidget {
  const CustomCachedNetworkImage(
      {Key? key, required this.product, this.homepage = false})
      : super(key: key);

  final Productmodel product;
  final bool homepage;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      fit: BoxFit.fitWidth,

      width: homepage ? 70 : 130,
      imageUrl: product.imageurl.toString(),
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
                colorFilter:
                    const ColorFilter.mode(Colors.white, BlendMode.colorBurn))),
      ),
      progressIndicatorBuilder: (context, url, downloadProgress) => Center(
        child: CircularProgressIndicator(
          value: downloadProgress.progress,
        ),
      ),
      errorWidget: (context, url, error) => const Icon(Icons.error),
      // model.imageurl,
      //width: 150,
      // height: 140,
    );
  }
}
