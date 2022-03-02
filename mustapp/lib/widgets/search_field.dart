import 'package:flutter/material.dart';
import 'package:mustapp/models/productmodel.dart';
import 'package:mustapp/search_result/nothingtoshow.dart';
import 'package:mustapp/search_result/search_result_screen.dart';
import 'package:mustapp/utils/constant.dart';
import 'package:mustapp/utils/util.dart';

class SearchField extends StatefulWidget {
  // final Function onSubmit;
  const SearchField({
    Key? key,
    // required this.onSubmit,
  }) : super(key: key);

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  @override
  void initState() {
    super.initState();
    searching = false;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      expands: true,
      maxLines: null,
      minLines: null,
      textInputAction: TextInputAction.search,
      style: TextStyle(fontSize: 20, color: Colors.black87),
      decoration: InputDecoration(
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        hintText: "Search Product Here ",
        fillColor: Colors.black,
        contentPadding: EdgeInsets.symmetric(
            horizontal: CustomHeight(context, 15),
            vertical: CustomWidth(context, 5)),
      ),
      onSubmitted: (value) async {
        final query = value.trim().toString();
        setState(() {
          searching = true;
        });
        //  if (query.length <= 0) return;
        List<Productmodel> searchedProductsId = [];
        try {
          searchedProductsId =
              await searchInProducts(query.toLowerCase()) as List<Productmodel>;
          if (searchedProductsId.length > 0) {
            setState(() {
              searching = false;
            });
            await Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => SearchResultScreen(
                  searchQuery: query,
                  searchResultProductsId: searchedProductsId,
                  searchIn: "All Products",
                ),
              ),
            );
            //  await refreshPage();
          } else {
            setState(() {
              searching = false;
            });
            Route route =
                MaterialPageRoute(builder: (c) => NothingToShowContainer());
            Navigator.push(context, route);
          }
        } catch (e) {
          final error = e.toString();
          setState(() {
            searching = false;
          });
          //  Logger().e(error);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("$error"),
            ),
          );
        }
      },
    );
  }
}
