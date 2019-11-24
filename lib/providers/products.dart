import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:reworked_flutter_course/models/http_exception.dart';
import 'package:reworked_flutter_course/providers/product.dart';
import 'package:reworked_flutter_course/helpers/http_resources.dart';
import 'package:http/http.dart' as http;
//you can implement the ChangeNotifier
//mixin in your classes to to then trigger
//notifyListeners() whenever you want to
//update all places in your app that listen
//to your data.

class Products with ChangeNotifier {
  // bool _showFavoritesOnly = false;

  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  final String authToken;
  final String userId;

  Products({this.authToken, List<Product> items, this.userId}) {
    _items = items;
  }

  List<Product> get items => List.of(_items);

  List<Product> get favoriteItems =>
      _items.where((product) => product.isFavorite).toList();

  Future<void> fetchAndSetProducts({bool filterByUser = false}) async {
    final String filterArguments =
        (filterByUser) ? '&orderBy="creatorId"&equalTo="$userId"' : '';
    try {
      var response = await http.get(
        HttpResources.firestoreDB.resourceUrl(
            collection: 'products',
            authToken: this.authToken,
            extraElements: filterArguments),
      );

      if (response.statusCode != 200 && response.statusCode != 201)
        throw new Exception(response.body);

      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      //we fetch the list of our favorite
      //items, following the approach of
      //separate liked items from actually
      //item list fetched here.
      final fetchFavsResponse =
          await http.get(HttpResources.firestoreDB.resourceUrl(
        collection: 'userFavorites',
        sufix: '/$userId',
        authToken: this.authToken,
      ));

      final favoriteData = json.decode(fetchFavsResponse.body);

      List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        // print('ID  : $prodId');
        // print('DATA: $prodData');

        loadedProducts.add(Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            imageUrl: prodData['imageUrl'],
            isFavorite:
                favoriteData == null ? false : favoriteData[prodId] ?? false));
      });

      _items = loadedProducts;

      notifyListeners();
    } catch (error) {
      print('ERROR FETCHING DATA: $error');
    }
  }

  Future<void> addProduct(Product item) async {
    //custom firebase url to save something in our "products"
    //collection

    try {
      //request body must be a json object
      var response = await http.post(
          HttpResources.firestoreDB
              .resourceUrl(collection: 'products', authToken: this.authToken),
          //body: json.encode(item.toMap)
          body: json.encode({
            'title': item.title,
            'description': item.description,
            'imageUrl': item.imageUrl,
            'price': item.price,
            'creatorId': userId
          }));

      if (response.statusCode != 200 && response.statusCode != 201)
        throw new Exception(response.body);

      item.id = json.decode(response.body)['name'];
      _items.add(item);

      //item.id = DateTime.now().toString();

    } catch (error) {
      print('[products]ERROR SENDING DATA -> $error');
      throw error;
    }

    //NotifyListeners interacts with all
    //listeners involved to
    //widgets responsible of displaying
    //this data
    notifyListeners();
  }

  Future<void> editProduct(Product newProduct) async {
    final int ex = _items.indexWhere((product) => product.id == newProduct.id);
    if (ex >= 0) {
      try {
        var response = await http.patch(
            HttpResources.firestoreDB.resourceUrl(
                collection: 'products',
                sufix: '/${newProduct.id}',
                authToken: this.authToken),
            body: json.encode(newProduct.toMap));

        if (response.statusCode != 200 && response.statusCode != 201)
          throw new Exception(response.body);

        _items[ex] = newProduct;
      } catch (error) {
        print('[products]ERROR PATCHING DATA -> $error');
        throw error;
      }
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String productId) async {
    //NOTE: Using optimistic updating pattern
    var existingProductIndex =
        _items.indexWhere((product) => product.id == productId);
    var existingProduct = _items[existingProductIndex];

    _items.removeAt(existingProductIndex);
    notifyListeners();

    var response = await http.delete(HttpResources.firestoreDB.resourceUrl(
        collection: 'products',
        sufix: '/$productId',
        authToken: this.authToken));

    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();

      throw HttpException(response.body);
    }

    existingProduct = null;
  }

  //Return a product that match with an existing
  //product [id] item
  Product findById(String id) =>
      _items.firstWhere((Product product) => product.id == id);
}
