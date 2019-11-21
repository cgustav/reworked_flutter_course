import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reworked_flutter_course/providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final String title;
  final int quantity;
  final double price;

  CartItem({this.id, this.title, this.productId, this.quantity, this.price});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (DismissDirection direction) {
        return showDialog(
            context: context,
            builder: (BuildContext ctx) => AlertDialog(
                  title: Text('Are you sure?'),
                  content:
                      Text('Do you want to remove the item from the cart?'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Discard'),
                      onPressed: () {
                        Navigator.of(ctx).pop(false);
                      },
                    ),
                    FlatButton(
                      child: Text('Delete'),
                      onPressed: () {
                        Navigator.of(ctx).pop(true);
                      },
                    ),
                  ],
                ));
      },
      onDismissed: (DismissDirection direction) {
        Provider.of<Cart>(context, listen: false).removeItem(this.productId);
      },
      background: Container(
        alignment: Alignment.centerRight,
        margin: EdgeInsets.only(right: 15),
        padding: EdgeInsets.only(right: 20),
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        //child: child
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
                child: FittedBox(
              child: Padding(
                padding: EdgeInsets.all(5),
                child: Text('$price'),
              ),
            )),
            title: Text(title),
            subtitle: Text('total: \$ ${price * quantity}'),
            trailing: Text('x $quantity'),
          ),
        ),
      ),
    );
  }
}
