import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reworked_flutter_course/providers/products.dart';
import 'package:reworked_flutter_course/screens/edit_product.dart';
import 'package:reworked_flutter_course/widgets/app_drawer.dart';
import 'package:reworked_flutter_course/widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  static const String routeName = '/user-products';

  Future<void> _refreshProducts(BuildContext context) async {
    print('Refresh products');
    await Provider.of<Products>(context).fetchAndSetProducts();
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your products'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              //Navigate to the new products
              //screen (create product form)
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListView.builder(
            itemCount: productsData.items.length,
            itemBuilder: (_, int i) => Column(
              children: <Widget>[
                UserProductItem(
                  productId: productsData.items[i].id,
                  title: productsData.items[i].title,
                  imageUrl: productsData.items[i].imageUrl,
                ),
                Divider()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
