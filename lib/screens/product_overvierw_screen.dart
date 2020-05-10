import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/products.dart';

import '../widgets/products_grid.dart';
import '../screens/cart_screen.dart';
import '../widgets/badge.dart';
import '../widgets/app_drawer.dart';

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

enum FilterOptions { Favorites, All }

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _isFavoriteChecked = false;
  var _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<Products>(context).getAndSetAllProducts();
    }

    _isInit = false;
    super.didChangeDependencies();
  }

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
          ),
          Consumer<Cart>(
            builder: (_, cartData, children) => Badge(
              child: children,
              value: cartData.getTotalItemsCount.toString(),
            ),
            child: IconButton(
              icon: Icon(
                Icons.shopping_cart,
              ),
              onPressed: () {
                Navigator.pushNamed(context, CartScreem.routeName);
              },
            ),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: ProductsGrid(_isFavoriteChecked),
    );
  }
}
