import 'package:flutter/material.dart';
import 'package:reworked_flutter_course/providers/auth.dart';
import 'package:reworked_flutter_course/providers/cart.dart';
import 'package:reworked_flutter_course/providers/orders.dart';
import 'package:reworked_flutter_course/providers/product.dart';
import 'package:reworked_flutter_course/providers/products.dart';
import 'package:reworked_flutter_course/screens/authentication.dart';
import 'package:reworked_flutter_course/screens/cart_screen.dart';
import 'package:reworked_flutter_course/screens/edit_product.dart';
import 'package:reworked_flutter_course/screens/orders_screen.dart';
import 'package:reworked_flutter_course/screens/product_detail_screen.dart';
import 'package:reworked_flutter_course/screens/products_overview_screen.dart';
import 'package:provider/provider.dart';
import 'package:reworked_flutter_course/screens/user_products.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //This is the class from the provider
    //package.
    //Only child widgets will be able to
    //listen the notifiers provided by
    //provider classes.

    //return ChangeNotifierProvider.value(
    /*
      inside the builder constructor lies 
      the provider which is directly involved 
      in the state management of products data.

      Each time that NotifyListener() is invoked
      This class will receive the notify and order
      to a specific widget to rebuild its content.

      So if something simply changes in here. It
      wont rebuild the whole MaterialApp it will
      only rebuild widgets which are listening.
      */

    //In this case our ChangeNotifierProvider does
    //not lies on any context variable to get work,
    //so we dont need to use this approach:
    //ChangeNotifierProvider(
    //   builder: (BuildContext ctx) => Products(),
    //   child: ...
    //)
    //Instead, we use the value approach which is kinda
    //shorter way (because we just need to pass a simply
    //object as an argument) to obtain the same behavior
    //value: Products(),

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        // ChangeNotifierProvider.value(
        //   value: Products(),
        // ),
        /*
        ChangeNotifierProxyProvider is actually
        a generic class and you should add extra
        information (like <T> argument) to make it
        work correctly.

        This allow you to set a provider which itself
        depends on another provider which was defined 
        before.

        In this particular case we are passing the
        Auth class to Products class. Internally
        the provider package do a lookup to our 
        "internal provider tree" and will see if
        it finds a provider match with the given
        Auth class.

        This proxy provider will be rebuilder each
        time the Auth class invoke notifyListeners
        function.
         */
        ChangeNotifierProxyProvider<Auth, Products>(
            builder: (BuildContext ctx, Auth auth, Products prevProducts) =>
                // Products(
                //     auth.token, (prevProducts == null) ? [] : prevProducts.items),
                Products(
                    authToken: auth.token,
                    items: (prevProducts == null) ? [] : prevProducts.items,
                    userId: auth.userId)),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        // ChangeNotifierProvider.value(
        //   value: Orders(),
        // ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          builder: (BuildContext ctx, Auth auth, Orders prevOrders) => Orders(
              authToken: auth.token,
              userId: auth.userId,
              orders: (prevOrders == null) ? [] : prevOrders.orders),
        )
      ],
      child: Consumer<Auth>(
        builder: (BuildContext ctx, Auth auth, Widget child) => MaterialApp(
          title: 'My Shop',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
          ),
          //home: ProductsOverviewScreen(),
          home: (auth.isAuth) ? ProductsOverviewScreen() : AuthScreen(),
          routes: {
            //0
            ProductDetailScreen.routeName: (BuildContext ctx) =>
                ProductDetailScreen(),
            //1
            CartScreen.routeName: (BuildContext ctx) => CartScreen(),

            //2
            OrdersScreen.routeName: (BuildContext ctx) => OrdersScreen(),

            //3
            UserProductsScreen.routeName: (BuildContext ctx) =>
                UserProductsScreen(),

            //4
            EditProductScreen.routeName: (BuildContext ctx) =>
                EditProductScreen(),

            //5
            AuthScreen.routeName: (BuildContext ctx) => AuthScreen(),

            //6
            ProductsOverviewScreen.routeName: (BuildContext ctx) =>
                ProductsOverviewScreen(),
          },
        ),
      ),
    );
  }
}
