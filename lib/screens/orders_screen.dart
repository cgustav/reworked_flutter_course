import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reworked_flutter_course/providers/orders.dart' show Orders;
import 'package:reworked_flutter_course/widgets/app_drawer.dart';
import 'package:reworked_flutter_course/widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const String routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    // final ordersData = Provider.of<Orders>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text('Your Orders'),
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future:
              Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
          builder: (BuildContext ctx, AsyncSnapshot snap) {
            if (snap.connectionState == ConnectionState.waiting)
              return Center(
                child: CircularProgressIndicator(),
              );
            else {
              if (snap.error != null)
                return Center(
                  child: Text('An error ocurred!'),
                );
              else
                return Consumer<Orders>(
                  builder:
                      (BuildContext ctx2, Orders ordersData, Widget child) =>
                          ListView.builder(
                    itemCount: ordersData.orders.length,
                    itemBuilder: (BuildContext ctx, int i) => OrderItem(
                      order: ordersData.orders[i],
                    ),
                  ),
                );
            }
          },
        ));
  }
}
