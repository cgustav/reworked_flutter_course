import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:reworked_flutter_course/helpers/http_resources.dart';

class Product with ChangeNotifier {
  //Server side stored product id
  String id;
  String title;
  String description;
  double price;
  String imageUrl;
  bool isFavorite;

  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.imageUrl,
      this.isFavorite = false});

  factory Product.fromMap(Map mapObject) {
    return Product(
        id: mapObject['id'],
        title: mapObject['title'],
        description: mapObject['description'],
        price: mapObject['price'],
        imageUrl: mapObject['imageUrl'],
        isFavorite: mapObject['isFavorite']);
  }

  void _setFavValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  ///Changes the favorite status of a
  ///product item to [true], favorite
  ///or [false], not favorite.
  Future<void> toggleFavoriteStatus(
      {@required String authToken, String userId}) async {
    final oldStatus = isFavorite;
    this.isFavorite = !isFavorite;
    notifyListeners();

    final url = HttpResources.firestoreDB.baseUrl +
        '/userFavorites/$userId/$id.json?auth=$authToken';
    try {
      var response = await http.put(
          // HttpResources.firestoreDB.resourceUrl(
          //     collection: 'products',
          //     sufix: '/${this.id}',
          //     authToken: authToken),
          url,
          body: json.encode(this.isFavorite));

      if (response.statusCode >= 400) throw new Exception(response.body);
    } catch (error) {
      //print('[product] Error at setting isFavorite prop');
      //print(error);
      _setFavValue(oldStatus);
    }
  }

  Map<String, dynamic> get toMap => {
        //'id': this.id,
        'title': this.title,
        'description': this.description,
        'price': this.price,
        'imageUrl': this.imageUrl,
        'isFavorite': this.isFavorite
      };
}
