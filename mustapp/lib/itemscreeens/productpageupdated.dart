import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mustapp/itemscreeens/TrendingItemUpdated.dart';
import 'package:mustapp/models/productmodel.dart';
import 'package:mustapp/utils/colors.dart';
import 'package:mustapp/utils/constant.dart';
import 'package:mustapp/widgets/dotted_slider.dart';
import 'package:mustapp/widgets/star_rating.dart';
import 'package:intl/intl.dart';

class ProductPageUpdated extends StatefulWidget {
  final Productmodel product;

  const ProductPageUpdated({Key? key, required this.product}) : super(key: key);

  @override
  _ProductPageUpdatedState createState() => _ProductPageUpdatedState();
}

class _ProductPageUpdatedState extends State<ProductPageUpdated> {
  bool isClicked = false;
  final formatCurrency = NumberFormat.currency(locale: "en_US", symbol: "");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        color: Theme.of(context).backgroundColor,
        width: MediaQuery.of(context).size.width,
        height: customdivideheight(context, 10) > 75
            ? customdivideheight(context, 11)
            : customdivideheight(context, 9),
        child: Container(
          padding: EdgeInsets.all(CustomWidth(context, 8)),
          decoration: BoxDecoration(
            border: Border.all(width: 0.5, color: Colors.black12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Row(
                children: <Widget>[
                  SizedBox(
                    child: Divider(
                      color: Colors.black26,
                      height: CustomHeight(context, 4),
                    ),
                    //   height: 24,
                  ),
                  Text(
                    widget.product.price.toString(),
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: CustomWidth(context, 18),
                        decoration: TextDecoration.lineThrough),
                  ),
                  SizedBox(
                    width: CustomWidth(context, 6),
                  ),
                  Text(
                    "Kshs: ${formatCurrency.format(int.parse(widget.product.discountprice))}",
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: customfont(context, 17),
                        fontWeight: FontWeight.w700),
                  )
                ],
              ),
              SizedBox(
                width: CustomWidth(context, 3),
              ),
              RaisedButton(
                onPressed: () {
                  checkIteminCart(widget.product.id, context);
                },
                textColor: Colors.white,
                padding: const EdgeInsets.all(0.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(CustomWidth(context, 8)),
                ),
                child: Container(
                  width: customdividewidth(context, 3) > 110
                      ? customdividewidth(context, 3)
                      : customdividewidth(context, 2.6),
                  height: CustomHeight(context, 60),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: <Color>[
                        CustomColors.GreenLight,
                        CustomColors.GreenDark,
                      ],
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(CustomWidth(context, 8)),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: CustomColors.GreenShadow,
                        blurRadius: CustomWidth(context, 15),
                        spreadRadius: CustomWidth(context, 7),
                        offset: Offset(0.0, 0.0),
                      )
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Icon(
                        Icons.shopping_cart_rounded,
                        color: Colors.white,
                      ),
                      const Text(
                        "Add to Cart",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              iconTheme: const IconThemeData(
                color: Colors.black, //change your color here
              ),
              backgroundColor: Colors.white,
              expandedHeight: customdivideheight(context, 2.4),
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text(
                  widget.product.title,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: CustomWidth(context, 16),
                  ),
                ),
                background: Padding(
                  padding: EdgeInsets.only(top: CustomHeight(context, 48)),
                  child: dottedSlider(),
                ),
              ),
            ),
          ];
        },
        body: Container(
          height: customdivideheight(context, 1),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _buildInfo(context), //Product Info
                _buildExtra(context),
                _buildDescription(context),
                //      _buildComments(context),
                _buildProducts(context),
                Container(
                  height: CustomHeight(context, 230) > 210
                      ? CustomHeight(context, 230)
                      : CustomHeight(context, 270),
                  child: alternativeBuildSimillar(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Shopping Cart"),
      content: const Text("Your product has been added to cart."),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _productSlideImage(String imageUrl) {
    return Container(
        height: CustomHeight(context, 100),
        width: double.infinity,
        child: CustomCachedNetworkImage(product: widget.product));
  }

  dottedSlider() {
    return DottedSlider(
      color: Colors.red,
      maxHeight: CustomHeight(context, 200),
      children: <Widget>[
        _productSlideImage(widget.product.imageurl),
        _productSlideImage(widget.product.imageurl),
        _productSlideImage(widget.product.imageurl),
        _productSlideImage(widget.product.imageurl),
      ],
    );
  }

  _buildInfo(context) {
    return Container(
      width: customdividewidth(context, 1),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                    width: CustomWidth(context, 130),
                    child: const Text("Seller Name")),
                SizedBox(
                  width: CustomWidth(context, 48),
                ),
                Text(widget.product.seller.toString()),
              ],
            ),
            SizedBox(
              height: CustomHeight(context, 8),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                    width: CustomWidth(context, 130),
                    child: const Text("Seller Ratings ")),
                SizedBox(
                  width: CustomWidth(context, 48),
                ),
                StarRating(rating: 4, size: 18)
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: CustomHeight(context, 13)),
              child: Text(
                "Please Make Sure you see the item in Person before performing payment >",
                style: TextStyle(color: Colors.black45),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildExtra(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(
        top: BorderSide(width: 1.0, color: Colors.black12),
        bottom: BorderSide(width: 1.0, color: Colors.black12),
      )),
      padding: EdgeInsets.all(CustomWidth(context, 4)),
      width: customdividewidth(context, 1),
      height: customdivideheight(context, 4) > 185
          ? customdivideheight(context, 4)
          : customdivideheight(context, 2.5),
      child: Padding(
        padding: EdgeInsets.all(CustomWidth(context, 8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text("Status"),
            Row(
              children: <Widget>[
                OutlineButton(
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(8.0)),
                  child: const Text('Used'),
                  onPressed: () {}, //callback when button is clicked
                  borderSide: const BorderSide(
                    color: Colors.grey, //Color of the border
                    style: BorderStyle.solid, //Style of the border
                    width: 0.8, //width of the border
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            const Text("Color"),
            Row(
              children: <Widget>[
                OutlineButton(
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(8.0)),
                  child: Text(widget.product.colors.toString()),
                  onPressed: () {}, //callback when button is clicked
                  borderSide: const BorderSide(
                    color: Colors.orangeAccent, //Color of the border
                    style: BorderStyle.solid, //Style of the border
                    width: 1.5, //width of the border
                  ),
                ),
                SizedBox(
                  width: CustomWidth(context, 8),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _buildDescription(BuildContext context) {
    return Container(
      width: customdividewidth(context, 1),
      height: customdivideheight(context, 3.8) > 200
          ? customdivideheight(context, 3.8)
          : customdivideheight(context, 3),
      child: Container(
        padding: EdgeInsets.all(CustomWidth(context, 16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              "Description",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black45,
                fontSize: CustomWidth(context, 18),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Flexible(child: Text(widget.product.description.toString())),
            SizedBox(
              height: CustomHeight(context, 8),
            ),
            Center(
              child: GestureDetector(
                onTap: () {
                  _settingModalBottomSheet(context);
                },
                child: Text(
                  "View More",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                      fontSize: CustomWidth(context, 18)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _buildProducts(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(6.0),
          child: Row(
            children: <Widget>[
              const Expanded(
                child: Text(
                  "Similar Items",
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54),
                  textAlign: TextAlign.start,
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    print("Clicked");
                  },
                  child: Text(
                    "View All",
                    style: TextStyle(
                        fontSize: CustomWidth(context, 18), color: Colors.blue),
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
            ],
          ),
        ),
        //    alternativeBuildSimillar()
      ],
    );
  }

  ///Load all the products in the category that are simillar to the product selected
  Column alternativeBuildSimillar() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('items')
              .where("productcategory",
                  isEqualTo: widget.product.category.toString())
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              //   progressDialog.show();
              //show the progress indicator , please wait
              return const Text("Loading Please Wait");
              //return CircularProgressIndicator(semanticsLabel: "Loading");
            }
            if (snapshot.data!.docs.length <= 1) {
              return Center(
                  child: Text(
                      "No Similar Items ${widget.product.category.toString()} "));
            }
            print(
                "The values found are: ${snapshot.data!.docs.length.toString()} with the product category ${widget.product.category.toString()}");
            // progressDialog.hide();
            //if(snapshot.connectionState == ConnectionState.done){
            return Expanded(
              child: ListView.builder(
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
                    //: SizedBox.shrink();
                  }),
            );
            // }
          },
        ),
      ],
    );
  }
}

void _settingModalBottomSheet(context) {
  showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          width: MediaQuery.of(context).size.width,
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  "Description",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black45,
                    fontSize: CustomWidth(context, 18),
                  ),
                ),
                SizedBox(
                  height: CustomHeight(context, 8),
                ),
                Text(
                    "Very nice phone especially for android developers, since i have used it for development it has been incredibly faster."),
                SizedBox(
                  height: CustomHeight(context, 8),
                ),
              ],
            ),
          ),
        );
      });
}
