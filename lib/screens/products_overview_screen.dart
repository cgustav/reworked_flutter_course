import 'package:flutter/material.dart';
import 'package:reworked_flutter_course/models/product.dart';
import 'package:reworked_flutter_course/widgets/product_item.dart';

//we need to display a grid of products
//(like a regular shop app).
class ProductsOverviewScreen extends StatelessWidget {
  ProductsOverviewScreen({Key key}) : super(key: key);
  //Instance of a static array of products to be displayed
  //later.
  final List<Product> loadedProducts = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Shop'),
      ),

      // GridView builder render a grid of
      //widget from an array of objects.
      body: GridView.builder(
        //using const here would help you with APP
        //performance.
        //Padding around the greed
        padding: const EdgeInsets.all(10.0),
        itemCount: loadedProducts.length,
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
        itemBuilder: (BuildContext ctx, int i) => ProductItem(
          id: loadedProducts[i].id,
          title: loadedProducts[i].title,
          imageUrl: loadedProducts[i].imageUrl,
        ),
      ),
    );
  }
}
