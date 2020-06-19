import 'package:flutter/material.dart';

class ProductDetailScreen extends StatelessWidget {
  static const String routeName = "/product-detail";
  final String productId = ModalRoute().settings.arguments as String;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(productId),
      ),
    );
  }
}
