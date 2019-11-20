import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reworked_flutter_course/providers/cart.dart' show Cart;
import 'package:reworked_flutter_course/providers/orders.dart';
import 'package:reworked_flutter_course/widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  // const CartScreen({Key key}) : super(key: key);

  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final order = Provider.of<Orders>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
              margin: EdgeInsets.all(15.0),
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Total',
                      style: TextStyle(fontSize: 20),
                    ),
                    Spacer(),
                    SizedBox(
                      width: 10,
                    ),
                    Chip(
                      label: Text(
                        '\$ ${cart.totalAmount.toStringAsFixed(2)}',
                        style: TextStyle(
                            color:
                                Theme.of(context).primaryTextTheme.title.color),
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    FlatButton(
                      onPressed: () {
                        order.addOrder(
                            cartProducts: cart.items.values.toList(),
                            total: cart.totalAmount);
                        cart.clear();
                      },
                      child: Text('ORDER NOW'),
                      textColor: Theme.of(context).primaryColor,
                    )
                  ],
                ),
              )),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
                itemCount: cart.itemCount,
                itemBuilder: (BuildContext ctx, int i) {
                  var item = cart.items.values.toList()[i];
                  return CartItem(
                      id: item.id,
                      productId: cart.items.keys.toList()[i],
                      title: item.title,
                      quantity: item.quantity,
                      price: item.price);
                }),
          )
        ],
      ),
    );
  }
}
