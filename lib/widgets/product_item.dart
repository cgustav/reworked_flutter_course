import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reworked_flutter_course/providers/cart.dart';
import 'package:reworked_flutter_course/providers/product.dart';

import 'package:reworked_flutter_course/screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  //const ProductItem({Key key}) : super(key: key);
  // final String id;
  // final String title;
  // final String imageUrl;

  // ProductItem({this.id, this.title, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    //print('Building product item...');

    /*
    We will combine two different Approaches
    to access to a provider content (so also
    the way we manage a widget state).

    1. The Provider.of<T>()'s Way: We use the 
    flutter framework properties to access to 
    a provider through the widget tree inherited
    context. Here we "subscribe" to the provider "T"
    existing in the app context and its notifyListener 
    method.

    2. The Consumer's (Widget) Way: It shares a
    pretty similar functionality with the
    "Provider.of"'s way to access to a Provider 
    content. The diference is that the consumer
    can wrap a specific or multiple widgets.
    Everithing wrapped inside the consumer widget
    will be rebuilded in case the Provider's 
    notifyListener method is invoked.

    The advantage of combining these two approaches 
    lies in the flexibility in the way we manage the
    widget building through different data states 
    incoming constantly (probably the most of cases
    will be this way) from our providers.

    For example, if we just use the Provider.of's 
    way our ProductItem and all its descendant 
    widgets will be rebuilded constantly (each 
    time notify listeners is invoked).
    This is not a bad approach per se but is not
    the most optimal solution (since this have a 
    direct impact in host device memory, and this
    impact is proportional to how large becomes 
    our app).

    On the other hand if we just use the Consumer's 
    method we could experiment problems accesing the
    Provider's data because the way our BuildContext
    works and the scope of the context of our 
    Consumer's widget, like this case.

    Note: is necesary to set the listen argument
    of provider.of method to false.

    */

    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);

    //ClipRRect simply forces the child widget it
    //wraps into a certain shape and therefore on
    //ClipRRect.
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            //named route
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: product.id,
            );
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          title: Text(product.title, textAlign: TextAlign.center),
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
              builder: (BuildContext ctx, Product product, Widget child) =>
                  IconButton(
                    icon: Icon(product.isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border),
                    color: Theme.of(context).accentColor,
                    onPressed: () {
                      product.toggleFavoriteStatus();
                    },
                  )),
          trailing: IconButton(
            icon: Icon(
              Icons.shopping_cart,
            ),
            color: Theme.of(context).accentColor,
            onPressed: () {
              cart.addItem(
                  productId: product.id,
                  title: product.title,
                  price: product.price);
            },
          ),
        ),
      ),
      //),
    );
  }
}
