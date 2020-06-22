import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String prodId;
  final String title;
  final double price;
  final int quantity;

  CartItem(
      {@required this.id,
      @required this.prodId,
      @required this.title,
      @required this.price,
      @required this.quantity});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(Icons.delete, color: Colors.white, size: 40),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.all(10),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(prodId);
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: EdgeInsets.all(5),
                child: FittedBox(
                    child: Text(
                  "\$$price",
                  style: TextStyle(
                      color:
                          Theme.of(context).primaryTextTheme.headline6.color),
                )),
              ),
              backgroundColor: Theme.of(context).primaryColor,
            ),
            title: Text(title),
            subtitle: Text("Total: \$${price * quantity}"),
            trailing: Text("$quantity x"),
          ),
          padding: EdgeInsets.all(8),
        ),
      ),
    );
  }
}
