import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import './cart_provider.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class OrdersProvider with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    const url = 'https://flutter-update-cd3c8.firebaseio.com/orders.json';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<OrderItem> loadedOrders = [];
      if (extractedData == null) return;
      extractedData.forEach((key, value) {
        print(key);
        final productsDynamic = value['products'] as List<dynamic>;
        final productsList = productsDynamic
            .map((prod) => CartItem(
                id: prod['id'],
                title: prod['title'],
                quantity: prod['quantity'],
                price: prod['price']))
            .toList();
        loadedOrders.add(OrderItem(
          id: key,
          amount: value['amount'],
          products: productsList,
          dateTime: DateTime.parse(value['dateTime']),
        ));
      });
      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    const url = 'https://flutter-update-cd3c8.firebaseio.com/orders.json';
    final timestamp = DateTime.now();
    try {
      final response = await http.post(url,
          body: json.encode({
            'products': cartProducts
                .map((cartItem) => {
                      'id': cartItem.id,
                      'price': cartItem.price,
                      'quantity': cartItem.quantity,
                      'title': cartItem.title,
                    })
                .toList(),
            'amount': total,
            'dateTime': timestamp.toIso8601String()
          }));

      final newOrder = OrderItem(
          id: json.decode(response.body)['name'],
          products: cartProducts,
          amount: total,
          dateTime: timestamp);
      _orders.add(newOrder);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
