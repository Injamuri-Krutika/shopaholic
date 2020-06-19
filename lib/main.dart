import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shopaholic/screens/product_detail_screen.dart';
import './screens/product_overview_screen.dart';
import './providers/products_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => ProductsProvider(),
      child: MaterialApp(
        theme: ThemeData(
            primaryColor: Colors.purple,
            accentColor: Colors.orange,
            fontFamily: 'Lato'),
        routes: {
          "/": (ctx) => ProductOverviewScreen(),
          ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
        },
      ),
    );
  }
}
