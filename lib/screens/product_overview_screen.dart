import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/main_drawer.dart';
import '../screens/cart_screen.dart';
import '../providers/cart_provider.dart';
import '../providers/products_provider.dart';
import '../widgets/products_grid.dart';
import '../widgets/badge.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showOnlyFavorites = false;

  @override
  Widget build(BuildContext context) {
    final productsContainer = Provider.of<ProductsProvider>(context);

    return Scaffold(
        appBar: AppBar(
          title: const Text("Shopaholic"),
          actions: [
            PopupMenuButton(
              onSelected: (FilterOptions selectedValue) {
                print(selectedValue);
                setState(() {
                  if (selectedValue == FilterOptions.Favorites) {
                    _showOnlyFavorites = true;
                  } else {
                    _showOnlyFavorites = false;
                  }
                });
              },
              icon: Icon(Icons.more_vert),
              itemBuilder: (_) => [
                PopupMenuItem(
                    child: Text("Only Favorites"),
                    value: FilterOptions.Favorites),
                PopupMenuItem(
                    child: Text("Show All"), value: FilterOptions.All),
              ],
            ),
            Consumer<Cart>(
              builder: (_, cart, ch) =>
                  Badge(child: ch, value: cart.itemCount.toString()),
              child: IconButton(
                  icon: Icon(Icons.shopping_cart),
                  onPressed: () {
                    Navigator.of(context).pushNamed(CartScreen.routeName);
                  }),
            )
          ],
        ),
        drawer: MainDrawer(),
        body: ProductsGrid(_showOnlyFavorites));
  }
}
