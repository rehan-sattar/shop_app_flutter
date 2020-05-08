import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/widgets/user_product_item.dart';

import '../providers/products.dart';
import '../widgets/app_drawer.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/userProducts';
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              /// .....
            },
          )
        ],
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: ListView.builder(
          itemBuilder: (ctx, index) => Column(
            children: <Widget>[
              UserProductItem(
                productProvider.items[index].title,
                productProvider.items[index].imageUrl,
              ),
              Divider()
            ],
          ),
          itemCount: productProvider.items.length,
        ),
      ),
    );
  }
}
