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

  List<OrderItem> get getOrders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    const url = 'https://shopapp-dcc1c.firebaseio.com/orders.json';
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
