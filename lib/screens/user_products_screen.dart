import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopaholic/screens/edit_product_screen.dart';
import '../widgets/main_drawer.dart';
import '../providers/products_provider.dart';
import '../widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<ProductsProvider>(context, listen: false)
        .fetchAndSetProducts();
    print('fetched products');
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Products"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          )
        ],
      ),
      drawer: MainDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListView.builder(
            itemBuilder: (ctx, i) => Column(children: [
              UserProductItem(
                id: productsData.items[i].id,
                title: productsData.items[i].title,
                imageURL: productsData.items[i].imageURL,
              ),
              Divider()
            ]),
            itemCount: productsData.items.length,
          ),
        ),
      ),
    );
  }
}
