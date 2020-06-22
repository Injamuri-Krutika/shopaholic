import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../widgets/crat_item.dart' as CI;

class CartScreen extends StatelessWidget {
  static const routeName = "/cart-screen";
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
        appBar: AppBar(title: const Text("Your Cart")),
        body: Column(
          children: [
            Card(
              elevation: 5,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Total:",
                        style: TextStyle(
                          fontSize: 20,
                        )),
                    Spacer(),
                    Consumer<Cart>(
                        builder: (_, cart, _2) => Chip(
                              label: FittedBox(
                                child: Text(
                                  "\$${cart.totalAmount}",
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .primaryTextTheme
                                          .headline6
                                          .color),
                                ),
                              ),
                              backgroundColor: Theme.of(context).primaryColor,
                            )),
                    FlatButton(
                      onPressed: () {},
                      child: Text("ORDER NOW"),
                      textColor: Theme.of(context).primaryColor,
                    )
                  ],
                ),
              ),
              margin: EdgeInsets.all(15),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
                child: ListView.builder(
              itemBuilder: (ctx, i) => CI.CartItem(
                  id: cart.items.values.toList()[i].id,
                  prodId: cart.items.keys.toList()[i],
                  title: cart.items.values.toList()[i].title,
                  quantity: cart.items.values.toList()[i].quantity,
                  price: cart.items.values.toList()[i].price),
              itemCount: cart.itemCount,
            ))
          ],
        ));
  }
}
