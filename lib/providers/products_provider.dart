import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';
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
      if (extractedData == null) return;
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

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndx = _items.indexWhere((prod) => prod.id == id);
    if (prodIndx >= 0) {
      final url =
          'https://flutter-update-cd3c8.firebaseio.com/products/$id.json';
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'subtitle': newProduct.subtitle,
            'imageURL': newProduct.imageURL,
            'price': newProduct.price,
          }));
      _items[prodIndx] = newProduct;
      notifyListeners();
    } else {
      print("...");
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = 'https://flutter-update-cd3c8.firebaseio.com/products/$id.json';
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProd = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProd);
      notifyListeners();
      throw HttpException('Could not delete product');
    }
    existingProd = null;
    notifyListeners();
  }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }
}
