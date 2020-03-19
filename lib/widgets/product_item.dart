import 'package:flutter/material.dart';
import '../screens/product_details_screen.dart';

class ProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  ProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailsScreen.routeName,
              arguments: this.id,
            );
          },
          child: Image.network(this.imageUrl, fit: BoxFit.cover),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          title: Text(
            this.title,
            textAlign: TextAlign.center,
          ),
          leading: Icon(
            Icons.favorite,
          ),
          trailing: Icon(
            Icons.shopping_cart,
          ),
        ),
      ),
    );
  }
}
