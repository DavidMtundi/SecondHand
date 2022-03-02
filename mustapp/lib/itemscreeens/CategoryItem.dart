import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mustapp/models/productmodel.dart';
import 'package:mustapp/screens/homeupdated.dart';
import 'package:mustapp/utils/constant.dart';

class CategoryItem extends StatelessWidget {
  final String title;
  final bool homepage;
  final String description;
  final String imagepath;

  const CategoryItem(
      {Key? key,
      required this.title,
      this.homepage = false,
      required this.description,
      required this.imagepath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double trendCardWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      child: Stack(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.all(Radius.circular(15))),
            width: trendCardWidth / 2.2,
            child: Card(
              elevation: 2,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    const Padding(padding: EdgeInsets.only(top: 10)),
                    Row(
                      children: <Widget>[
                        const Spacer(),

                        Text(title.toString() + "s ",
                            style: const TextStyle(
                                fontSize: 15, color: Colors.black87))
                        // Icon(
                        //   Ionicons.getIconData("ios-heart-empty"),
                        //   color: Colors.black54,
                        // )
                      ],
                    ),
                    const Padding(padding: EdgeInsets.only(top: 10)),
                    _productImage(context),
                    const Padding(padding: EdgeInsets.only(top: 10)),
                    _productDetails(context),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => HomeUpdated(
              searchstring: title,
            ),
          ),
        );
      },
    );
  }

  _productImage(BuildContext context) {
    return Stack(
      children: <Widget>[
        Center(
          child: Container(
              width: homepage ? 100 : 150,
              height: CustomHeight(context, 70),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                      fit: BoxFit.fitWidth, image: AssetImage(imagepath)))
              // decoration: BoxDecoration(
              // child: Image.asset(

              // ),
              //   ),
              ),
        )
      ],
    );
  }

  _productDetails(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            description,
            style: TextStyle(
                fontSize: customfont(context, 13), color: Colors.black38),
          ),
          //  StarRating(rating: 5, size: 10),
        ],
      ),
    );
  }
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
      imageUrl: product.imageurl,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(const Radius.circular(10)),
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
