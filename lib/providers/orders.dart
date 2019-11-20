import 'package:flutter/foundation.dart';
import 'package:reworked_flutter_course/providers/cart.dart';

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
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders => List.from(_orders);

  void addOrder({List<CartItem> cartProducts, double total}) {
    _orders.insert(
        0,
        OrderItem(
          id: DateTime.now().toString(),
          products: cartProducts,
          amount: total,
          dateTime: DateTime.now(),
        ));
    notifyListeners();
  }
}
