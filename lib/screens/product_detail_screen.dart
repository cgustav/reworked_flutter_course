import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reworked_flutter_course/providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
  // final String title;
  // final double price;
  // ProductDetailScreen({@required this.title, @required this.price});

  static const routeName = '/product´detail';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    //Is necesseary to set the listen argument
    //on flase to prevent this widget to rebuild
    //its content when we execute the findById
    //method.
    final loadedProduct =
        Provider.of<Products>(context, listen: false).findById(productId);
    // final selectedProduct =
    //     .firstWhere((product) => product.id == productId);

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(loadedProduct.title),
      // ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(loadedProduct.title),
              background: Hero(
                tag: loadedProduct.id,
                child: Image.network(loadedProduct.imageUrl, fit: BoxFit.cover),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              //   Container(
              //   height: 300,
              //   width: double.infinity,
              //   child:
              // ),
              SizedBox(
                height: 10,
              ),
              Text(
                '\$${loadedProduct.price}',
                style: TextStyle(color: Colors.grey, fontSize: 20),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                width: double.infinity,
                child: Text(
                  loadedProduct.description,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                  softWrap: true,
                ),
              )
            ]),
          ),
        ],
      ),
    );
  }
}
