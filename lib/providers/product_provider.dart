import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopaholic/models/http_exception.dart';

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

  Future<void> toggleFavoriteStatus() async {
    isFavorite = !isFavorite;
    notifyListeners();

    final url = 'https://flutter-update-cd3c8.firebaseio.com/products/$id.json';
    final response =
        await http.patch(url, body: json.encode({'isFavorite': isFavorite}));
    if (response.statusCode >= 400) {
      print(response.statusCode);
      print(response.body);
      isFavorite = !isFavorite;
      notifyListeners();
      throw HttpException('Could not update Favorite');
    }
  }
}
