import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final DateTime dateTime;
  final List<CartItem> products;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.dateTime,
    @required this.products,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String token;
  final String userId;

  Orders(this.token, this.userId, this._orders);

  List<OrderItem> get getOrders {
    return [..._orders];
  }

  Future<void> getAndSetAllOrders() async {
    try {
      final url =
          'https://shopapp-dcc1c.firebaseio.com/orders/$userId.json?auth=$token';
      final response = await http.get(url);
      List<OrderItem> loadedOrders = [];
      var extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      extractedData.forEach(
        (orderId, orderData) {
          loadedOrders.add(
            OrderItem(
              id: orderId,
              amount: orderData['amount'],
              dateTime: DateTime.parse(orderData['dateTime']),
              products: (orderData['products'] as List<dynamic>).map(
                (ci) {
                  return CartItem(
                    id: ci['id'],
                    price: ci['price'],
                    title: ci['title'],
                    quantity: ci['quantity'],
                  );
                },
              ).toList(),
            ),
          );
        },
      );
      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    } catch (err) {
      throw (err);
    }
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url =
        'https://shopapp-dcc1c.firebaseio.com/orders/$userId.json?auth=$token';
    final tiemstamp = DateTime.now();

    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'amount': total,
            'dateTime': tiemstamp.toIso8601String(),
            'products': cartProducts
                .map(
                  (cartItem) => {
                    'id': cartItem.id,
                    'title': cartItem.title,
                    'price': cartItem.price,
                    'quantity': cartItem.quantity,
                  },
                )
                .toList()
          },
        ),
      );
      _orders.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['name'],
          amount: total,
          dateTime: tiemstamp,
          products: cartProducts,
        ),
      );
      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  int get getOrdersCount {
    return _orders.length;
  }
}
