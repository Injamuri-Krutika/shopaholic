import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../widgets/crat_item.dart' as CI;
import '../providers/orders_provider.dart';

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
                                  "\$${cart.totalAmount.toStringAsFixed(2)}",
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .primaryTextTheme
                                          .headline6
                                          .color),
                                ),
                              ),
                              backgroundColor: Theme.of(context).primaryColor,
                            )),
                    OrderNowButton(cart: cart)
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

class OrderNowButton extends StatefulWidget {
  const OrderNowButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderNowButtonState createState() => _OrderNowButtonState();
}

class _OrderNowButtonState extends State<OrderNowButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: (widget.cart.totalAmount <= 0 || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              try {
                final response =
                    await Provider.of<OrdersProvider>(context, listen: false)
                        .addOrder(widget.cart.items.values.toList(),
                            widget.cart.totalAmount);
                _isLoading = false;
                widget.cart.clearCart();
              } catch (err) {
                print("Error in adding order : $err");
              }
            },
      child: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Text("ORDER NOW"),
      textColor: Theme.of(context).primaryColor,
    );
  }
}
