import 'package:flutter/material.dart';
import 'package:reworked_flutter_course/models/product.dart';
import 'package:reworked_flutter_course/screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  //const ProductItem({Key key}) : super(key: key);
  final String id;
  final String title;
  final String imageUrl;

  ProductItem({this.id, this.title, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    //ClipRRect simply forces the child widget it
    //wraps into a certain shape and therefore on
    //ClipRRect.

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext ctx) => ProductDetailScreen(
                      title: title,
                      price: 10.0,
                    )));
          },
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          title: Text(title, textAlign: TextAlign.center),
          backgroundColor: Colors.black87,
          leading: IconButton(
            icon: Icon(Icons.favorite),
            color: Theme.of(context).accentColor,
            onPressed: () {},
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.shopping_cart,
            ),
            color: Theme.of(context).accentColor,
            onPressed: () {},
          ),
        ),
      ),
    );
  }
}
