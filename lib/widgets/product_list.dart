import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './products_grid.dart';
import '../providers/products.dart';

enum FilterOptions { Favorites, All }

class ProductList extends StatefulWidget {
  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  var _isFavoriteChecked = false;

  void handleSelectedChange(FilterOptions selectedValue) {
    setState(() {
      if (selectedValue == FilterOptions.Favorites) {
        _isFavoriteChecked = true;
      } else {
        _isFavoriteChecked = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shop'),
        actions: <Widget>[
          PopupMenuButton(
            icon: Icon(
              Icons.more_vert,
            ),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Select only favorites'),
                value: FilterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text('Select All'),
                value: FilterOptions.All,
              ),
            ],
            onSelected: handleSelectedChange,
          )
        ],
      ),
      body: ProductsGrid(_isFavoriteChecked),
    );
  }
}
