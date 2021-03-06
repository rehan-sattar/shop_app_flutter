import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/edit_product_screen.dart';
import '../widgets/user_product_item.dart';
import '../providers/products.dart';
import '../widgets/app_drawer.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/userProducts';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .getAndSetAllProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, EditProductScreen.routeName);
            },
          )
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (context, snapshot) {
          return RefreshIndicator(
            onRefresh: () => _refreshProducts(context),
            child: snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Consumer<Products>(
                    builder: (ctx, productProvider, _) {
                      return (Padding(
                        padding: EdgeInsets.all(20),
                        child: ListView.builder(
                          itemBuilder: (ctx, index) => Column(
                            children: <Widget>[
                              UserProductItem(
                                productProvider.items[index].id,
                                productProvider.items[index].title,
                                productProvider.items[index].imageUrl,
                              ),
                              Divider()
                            ],
                          ),
                          itemCount: productProvider.items.length,
                        ),
                      ));
                    },
                  ),
          );
        },
      ),
    );
  }
}
