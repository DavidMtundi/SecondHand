import 'package:flutter/material.dart';
import 'package:mustapp/models/productmodel.dart';
import 'package:mustapp/utils/util.dart';

import 'components/body.dart';

class SearchResultScreen extends StatefulWidget {
  final String searchQuery;
  final String searchIn;
  final List<Productmodel> searchResultProductsId;

  const SearchResultScreen({
    Key? key,
    required this.searchQuery,
    required this.searchResultProductsId,
    required this.searchIn,
  }) : super(key: key);

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  @override
  Widget build(BuildContext context) {
    setState(() {
      searching = !searching;
    });

    return Scaffold(
      appBar: AppBar(),
      body: Body(
        searchQuery: widget.searchQuery,
        searchResultProductsId: widget.searchResultProductsId,
        searchIn: widget.searchIn,
      ),
    );
  }
}
