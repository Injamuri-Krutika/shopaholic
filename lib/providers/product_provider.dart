import 'package:flutter/material.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String imageURL;
  final String subtitle;
  final double price;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.subtitle,
    @required this.price,
    @required this.imageURL,
    this.isFavorite = false,
  });

  void toggleFavoriteStatus() {
    isFavorite = !isFavorite;
    notifyListeners();
  }
}
