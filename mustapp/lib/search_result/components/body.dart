import 'package:flutter/material.dart';
import 'package:mustapp/itemscreeens/TrendingItemUpdated.dart';
import 'package:mustapp/models/productmodel.dart';
import 'package:mustapp/search_result/nothingtoshow.dart';
import 'package:mustapp/utils/constant.dart';

class Body extends StatelessWidget {
  final String searchQuery;
  final List<Productmodel> searchResultProductsId;
  final String searchIn;

  const Body({
    Key? key,
    required this.searchQuery,
    required this.searchResultProductsId,
    required this.searchIn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: CustomWidth(context, 10)),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                SizedBox(height: CustomHeight(context, 10)),
                Text(
                  "Search Result",
                  style: TextStyle(fontSize: 15),
                ),
                Text.rich(
                  TextSpan(
                    text: "$searchQuery",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                    children: [
                      TextSpan(
                        text: " in ",
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                      TextSpan(
                        text: "$searchIn",
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.normal,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: CustomHeight(context, 30)),
                SizedBox(
                  height: customdivideheight(context, 1.3),
                  child: buildProductsGrid(),
                ),
                SizedBox(height: CustomHeight(context, 30)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildProductsGrid() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: Color(0xFFF5F6F9),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Builder(
        builder: (context) {
          if (searchResultProductsId.length > 0) {
            return GridView.builder(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: searchResultProductsId.length,
              itemBuilder: (context, index) {
                return TrendingItemUpdated(
                    product: searchResultProductsId[index],
                    gradientColors: const [
                      Color(0XFFa466ec),
                      Color(0XFFa466ec)
                    ]);
              },
            );
          }
          return Center(
            child: NothingToShowContainer(
              
            ),
          );
        },
      ),
    );
  }
}
