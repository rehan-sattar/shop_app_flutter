import 'package:flutter/foundation.dart';
import "dart:convert";
import 'package:http/http.dart' as http;

import './product.dart';

class Products extends ChangeNotifier {
  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];

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

  Future<void> addProduct(Product newProduct) {
    var addNewProductEndPoint =
        'https://shopapp-dcc1c.firebaseio.com/products.json';
    return http
        .post(
      addNewProductEndPoint,
      body: json.encode(
        {
          'title': newProduct.title,
          'description': newProduct.description,
          'price': newProduct.price,
          'imageUrl': newProduct.imageUrl
        },
      ),
    )
        .then(
      (value) {
        var _newProduct = new Product(
          id: DateTime.now().toString(),
          title: newProduct.title,
          description: newProduct.description,
          price: newProduct.price,
          imageUrl: newProduct.imageUrl,
        );
        _items.add(_newProduct);
        notifyListeners();
      },
    ).catchError((error) {
      print(error);
      throw error;
    });
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
