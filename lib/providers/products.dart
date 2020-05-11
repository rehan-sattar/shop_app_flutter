import 'package:flutter/foundation.dart';
import "dart:convert";
import 'package:http/http.dart' as http;

import './product.dart';
import '../model/http_exception.dart';

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

  Future<void> editProduct(String productId, Product updatedProduct) async {
    var index = _items.indexWhere((element) => element.id == productId);
    final editProductUrl =
        'https://shopapp-dcc1c.firebaseio.com/products/$productId.json';
    if (index >= 0) {
      await http.patch(
        editProductUrl,
        body: json.encode(
          {
            'title': updatedProduct.title,
            'description': updatedProduct.description,
            'price': updatedProduct.price,
            'imageUrl': updatedProduct.imageUrl,
          },
        ),
      );
      _items[index] = updatedProduct;
    } else {
      print('...');
    }
    notifyListeners();
  }

  Future<void> deleteProduct(String productId) async {
    final deleteProductUrl =
        'https://shopapp-dcc1c.firebaseio.com/products/$productId.json';
    final productIndex = _items.indexWhere(
      (element) => element.id == productId,
    );
    var clonedProduct = _items[productIndex];
    _items.removeAt(productIndex);
    notifyListeners();
    final response = await http.delete(deleteProductUrl);
    if (response.statusCode >= 400) {
      _items.insert(productIndex, clonedProduct);
      notifyListeners();
      throw HttpException('Could not delete the product');
    }
    clonedProduct = null;
  }
}
