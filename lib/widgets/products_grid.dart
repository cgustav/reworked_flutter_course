import 'package:flutter/material.dart';

import 'package:reworked_flutter_course/providers/products.dart';
import 'package:reworked_flutter_course/widgets/product_item.dart';
import 'package:provider/provider.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavs;
  ProductsGrid({this.showFavs = false});

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = showFavs ? productsData.favoriteItems : productsData.items;
    return GridView.builder(
      //using const here would help you with APP
      //performance.
      //Padding around the greed
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,
      //GridDelegate allows us to define how the
      //grid generally should be structured, so
      //how many columns it should have, etc.
      // - sliverGridDeleg.. means i can define
      //   that i want to have a certain amount
      //   amount of columns and it will simply
      //   squeeze the items onto the screen so
      //   that this criteria is met.
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),

      //In this case we use the ChangeNotifierProvider
      //class to pass the selected product item to the
      //next widget in the widget tree hierarchy.
      itemBuilder: (BuildContext ctx, int i) => ChangeNotifierProvider.value(
        //builder: (BuildContext c) => products[i],
        value: products[i],
        child: ProductItem(
            // id: products[i].id,
            // title: products[i].title,
            // imageUrl: products[i].imageUrl,
            ),
      ),
    );
  }
}
