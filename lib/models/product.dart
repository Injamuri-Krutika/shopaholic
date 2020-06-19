import 'package:flutter/foundation.dart';

class Product {
  final String id;
  final String title;
  final String imageURL;
  final String subtitle;
  final double price;
  final bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.subtitle,
    @required this.price,
    @required this.imageURL,
    this.isFavorite,
  });
}
