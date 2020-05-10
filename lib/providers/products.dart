import 'package:flutter/foundation.dart';
import "dart:convert";
import 'package:http/http.dart' as http;

import './product.dart';

class Products extends ChangeNotifier {
  List<Product> _items = [];

  var showFavorites = false;

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return items.where((item) => item.isFavorite).toList();
  }

  Future<void> getAndSetAllProducts() async {
    var productsNodeEndPoint =
        'https://shopapp-dcc1c.firebaseio.com/products.json';

    try {
      final response = await http.get(productsNodeEndPoint);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData["title"],
          description: prodData["description"],
          price: prodData['price'],
          imageUrl: prodData["imageUrl"],
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (err) {
      throw (err);
    }
  }

  Future<void> addProduct(Product newProduct) async {
    var productsNodeEndPoint =
        'https://shopapp-dcc1c.firebaseio.com/products.json';

    try {
      final response = await http.post(
        productsNodeEndPoint,
        body: json.encode(
          {
            'title': newProduct.title,
            'description': newProduct.description,
            'price': newProduct.price,
            'imageUrl': newProduct.imageUrl
          },
        ),
      );
      var _newProduct = new Product(
        id: json.decode(response.body)["name"],
        title: newProduct.title,
        description: newProduct.description,
        price: newProduct.price,
        imageUrl: newProduct.imageUrl,
      );
      _items.add(_newProduct);
      notifyListeners();
    } catch (error) {
      // print(error);
      // throw error;
    }
  }

  void editProduct(String productId, Product updatedProduct) {
    var index = _items.indexWhere((element) => element.id == productId);
    if (index >= 0) {
      _items[index] = updatedProduct;
    } else {
      print('...');
    }
    notifyListeners();
  }

  void deleteProduct(String productId) {
    _items.removeWhere((element) => element.id == productId);
    notifyListeners();
  }
}
