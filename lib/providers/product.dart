import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/model/http_exception.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  void _updateStatus(bool status) {
    isFavorite = status;
    notifyListeners();
  }

  Future<void> toggleIsFavorite(String token) async {
    final previousStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url =
        'https://shopapp-dcc1c.firebaseio.com/products/$id.json?auth=$token';
    try {
      final response = await http.patch(
        url,
        body: json.encode(
          {'isFavorite': this.isFavorite},
        ),
      );
      if (response.statusCode >= 400) {
        _updateStatus(previousStatus);
        throw HttpException('Oops! Can\'t mark this as favorite!');
      }
    } catch (e) {
      _updateStatus(previousStatus);
      throw HttpException(e.toString());
    }
  }
}
