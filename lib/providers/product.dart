import 'package:flutter/foundation.dart';

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

  ///Changes the favorite status of a
  ///product item to [true], favorite
  ///or [false], not favorite.
  void toggleFavoriteStatus() {
    this.isFavorite = !isFavorite;
    notifyListeners();
  }
}
