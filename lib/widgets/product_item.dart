import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/product_detail_screen.dart';
import '../providers/product_provider.dart';
import '../providers/cart_provider.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                arguments: product.id);
          },
          child: Image.network(
            product.imageURL,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          leading: IconButton(
            icon: Icon(
              Icons.shopping_cart,
              color: Theme.of(context).accentColor,
            ),
            onPressed: () {
              cart.addItem(product.id, product.price, product.title);
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(
                SnackBar(
                    content: Text(
                      "Added item to cart!",
                    ),
                    duration: Duration(seconds: 5),
                    action: SnackBarAction(
                        label: "Undo",
                        onPressed: () {
                          cart.removeSingleItem(product.id);
                        })),
              );
            },
          ),
          trailing: Consumer<Product>(
            builder: (ctx, product, child) => IconButton(
                icon: product.isFavorite
                    ? Icon(
                        Icons.favorite,
                        color: Theme.of(context).accentColor,
                      )
                    : Icon(
                        Icons.favorite_border,
                        color: Theme.of(context).accentColor,
                      ),
                onPressed: () {
                  product.toggleFavoriteStatus();
                }),
          ),
        ),
      ),
    );
  }
}
