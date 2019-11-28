import 'package:flutter/material.dart';
import 'package:reworked_flutter_course/helpers/custom_route.dart';
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
import 'package:reworked_flutter_course/screens/splash_screen.dart';
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
      /* 
      The Home will be completely different depending on
      if there is a valid living session from a user with
      a valid token or not.

      So, first we check with Provider's Consumer widget
      if there is a valid user authenticated each time 
      this widget is rebuilded.
           - case true: It displays the products overview
                        screen
           - case false: Otherwise it displays the log
                         in page to put some user
                         credentials.

      On the second place the app will check if this authenticated
      user (in the case were true) have an invalid or expired 
      session token. So, using a FutureBuilder widget 
      the app will invoke each time this page is rebuilded
      the [tryAuthLogIn] function.

      The [tryAuthLogIn] function checks in base of a DateTime 
      object if current session token is still living. If its not 
      then the function will invoke the logOut() function 
      killing all local variables related to the living user 
      session and rebuild this page to display the AuthPage 
      instead.

      While the app is processing if the existing authenticated user 
      session is valid or not it will display a splash screen to
      improve the user experience. To accomplish that is necesary
      to check the connection state of the AsyncSnap object given 
      from the FutureBuilder implemented before.

      
       */
      child: Consumer<Auth>(
        builder: (BuildContext ctx, Auth auth, Widget child) => MaterialApp(
          title: 'My Shop',
          theme: ThemeData(
              primarySwatch: Colors.purple,
              accentColor: Colors.deepOrange,
              fontFamily: 'Lato',
              pageTransitionsTheme: PageTransitionsTheme(builders: {
                TargetPlatform.android: CustomPageTransitionBuilder(),
                TargetPlatform.iOS: CustomPageTransitionBuilder(),
              })),
          //home: ProductsOverviewScreen(),
          home: (auth.isAuth)
              ? ProductsOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogIn(),
                  builder: (BuildContext ctx, AsyncSnapshot snap) =>
                      (snap.connectionState == ConnectionState.waiting)
                          ? SplashScreen()
                          : AuthScreen(),
                ),
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
