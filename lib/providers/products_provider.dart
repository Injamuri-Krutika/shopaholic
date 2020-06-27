import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './product_provider.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favItems {
    return [..._items.where((element) => element.isFavorite == true)];
  }

  Future<void> fetchAndSetProducts() async {
    const url = 'https://flutter-update-cd3c8.firebaseio.com/products.json';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProdcts = [];
      extractedData.forEach((key, value) {
        loadedProdcts.add(Product(
            id: key,
            title: value['title'],
            subtitle: value['subtitle'],
            price: value['price'],
            imageURL: value['imageURL'],
            isFavorite: value['isFavorite']));
      });
      _items = loadedProdcts;
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> addProduct(Product product) async {
    const url = 'https://flutter-update-cd3c8.firebaseio.com/products.json';
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'subtitle': product.subtitle,
            'imageURL': product.imageURL,
            'price': product.price,
            'isFavorite': product.isFavorite,
          }));

      final newProduct = Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          subtitle: product.subtitle,
          price: product.price,
          imageURL: product.imageURL);
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  void updateProduct(String id, Product newProduct) {
    final prodIndx = _items.indexWhere((prod) => (prod.id == id));
    if (prodIndx > 0) {
      _items[prodIndx] = newProduct;
      notifyListeners();
    } else {
      print("...");
    }
  }

  void deleteProduct(String id) {
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }
}
