import 'package:flutter/material.dart';

import './products_grid.dart';

class ProductList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shop'),
      ),
      body: ProductsGrid(),
    );
  }
}
