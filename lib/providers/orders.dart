import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:reworked_flutter_course/helpers/http_resources.dart';
import 'package:reworked_flutter_course/providers/cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(
      {@required this.id,
      @required this.amount,
      @required this.products,
      @required this.dateTime});

  factory OrderItem.fromMap(Map content) => OrderItem(
      id: content['id'],
      amount: content['amount'],
      dateTime: content['dateTime'],
      products: content['products']);
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders => List.from(_orders);

  Future<void> fetchAndSetOrders() async {
    var response =
        await http.get(HttpResources.firestoreDB.url(collection: 'orders'));
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;

    if (extractedData == null) return;

    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(OrderItem(
          id: orderId,
          amount: orderData['amount'],
          dateTime: DateTime.parse(
            orderData['dateTime'],
          ),
          products: (orderData['products'] as List<dynamic>)
              .map((dynamic item) => CartItem(
                    id: item['id'],
                    title: item['title'],
                    price: item['price'],
                    quantity: item['quantity'],
                  ))
              .toList()));
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder({List<CartItem> cartProducts, double total}) async {
    DateTime timestamp = DateTime.now();
    double fixedTotal = double.parse(total.toStringAsFixed(2));

    //Here we build a representation of a product
    //to negotiate with our backend.
    try {
      Map container = {
        'amount': fixedTotal,
        'dateTime': timestamp.toIso8601String(),
        'products': cartProducts
            .map((cartProduct) => {
                  'id': cartProduct.id,
                  'title': cartProduct.title,
                  'quantity': cartProduct.quantity,
                  'price': cartProduct.price
                })
            .toList()
      };

      var response = await http.post(
          HttpResources.firestoreDB.url(collection: 'orders'),
          body: json.encode(container));

      if (response.statusCode >= 400)
        throw new Exception('Cannot reach successful server response.');

      _orders.insert(
          0,
          OrderItem(
            id: json.decode(response.body)['name'],
            products: cartProducts,
            amount: fixedTotal,
            dateTime: timestamp,
          ));
    } catch (error) {
      print('[orders]Error Creating an Order -> $error');
    }

    notifyListeners();
  }
}
