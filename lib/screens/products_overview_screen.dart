import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reworked_flutter_course/providers/cart.dart';

import 'package:reworked_flutter_course/screens/cart_screen.dart';
import 'package:reworked_flutter_course/widgets/app_drawer.dart';
import 'package:reworked_flutter_course/widgets/badge.dart';
import 'package:reworked_flutter_course/widgets/products_grid.dart';

//to manage pop menu available options
enum FilterOptions { Favorites, All }

//we need to display a grid of products
//(like a regular shop app).

class ProductsOverviewScreen extends StatefulWidget {
  ProductsOverviewScreen({Key key}) : super(key: key);

  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _showFavorites = false;

  @override
  Widget build(BuildContext context) {
    //final productsContainer = Provider.of<Products>(context, listen: false);
    //final cart =  Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('My Shop'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions opt) {
              // if (opt == FilterOptions.Favorites)
              //   productsContainer.showFavoritesOnly();
              // else
              //   productsContainer.showAll();
              setState(() {
                _showFavorites = (opt == FilterOptions.Favorites);
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only favorites'),
                value: FilterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text('Show all'),
                value: FilterOptions.All,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (_, Cart cartData, Widget ch) => Badge(
              value: cartData.itemCount.toString(),
              child: ch,
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          )
        ],
      ),

      drawer: AppDrawer(),

      // GridView builder render a grid of
      //widget from an array of objects.
      body: ProductsGrid(
        showFavs: _showFavorites,
      ),
    );
  }
}

//
