import 'package:flutter/material.dart';
import '../models/product.dart';
import '../widgets/products_grid.dart';
import 'package:provider/provider.dart';

class ProductOverviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Shopaholic"),
        ),
        body: ProductsGrid(loadedProducts: _loadedProducts));
  }
}
