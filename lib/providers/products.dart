import 'package:flutter/material.dart';
import 'package:reworked_flutter_course/providers/product.dart';

//you can implement the ChangeNotifier
//mixin in your classes to to then trigger
//notifyListeners() whenever you want to
//update all places in your app that listen
//to your data.

class Products with ChangeNotifier {
  // bool _showFavoritesOnly = false;

  List<Product> _items = [
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

  List<Product> get items {
    // return (_showFavoritesOnly)
    //     ? _items.where((Product product) => product.isFavorite).toList()
    //     : List.of(_items);
    return List.of(_items);
  }

  List<Product> get favoriteItems =>
      _items.where((product) => product.isFavorite).toList();

  void addProduct(Product item) {
    item.id = DateTime.now().toString();
    _items.add(item);
    //This portion interacts with
    //listeners asociated with involved
    //widgets responsible of displaying
    //this data
    notifyListeners();
  }

  void editProduct(Product newProduct) {
    final int ex = _items.indexWhere((product) => product.id == newProduct.id);
    if (ex >= 0) {
      _items[ex] = newProduct;
      notifyListeners();
    }
  }

  void deleteProduct(String productId) {
    _items.removeWhere((product) => product.id == productId);
    notifyListeners();
  }

  //Return a product that match with an existing
  //product [id] item
  Product findById(String id) =>
      _items.firstWhere((Product product) => product.id == id);
}
