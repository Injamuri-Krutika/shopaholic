import 'package:flutter/material.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String title;
  final double price;
  final int quantity;

  CartItem(
      {@required this.id,
      @required this.title,
      @required this.price,
      @required this.quantity});

  @override
  Widget build(BuildContext context) {
    return Card(
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
                    color: Theme.of(context).primaryTextTheme.headline6.color),
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
    );
  }
}
