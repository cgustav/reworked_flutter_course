import 'dart:math';

import 'package:flutter/material.dart';
import 'package:reworked_flutter_course/providers/cart.dart';
import 'package:reworked_flutter_course/providers/orders.dart' as ord;
import 'package:intl/intl.dart';

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;

  OrderItem({@required this.order});

  @override
  _OrderItemState createState() => _OrderItemState();
}
//class OrderItem extends StatelessWidget {
// const OrderItem({Key key}) : super(key: key);s

class _OrderItemState extends State<OrderItem> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('\$${widget.order.amount}'),
            subtitle: Text(
                DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime)),
            trailing: IconButton(
              icon: Icon((_expanded) ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          (_expanded)
              ? AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  height: _expanded
                      ? min(widget.order.products.length * 20.0 + 60.0, 190)
                      : 0,
                  child: ListView(
                    children: widget.order.products
                        .map((CartItem item) => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  item.title,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '${item.quantity} x \$${item.price}',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.grey),
                                )
                              ],
                            ))
                        .toList(),
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
