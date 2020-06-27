import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/main_drawer.dart';
import '../providers/orders_provider.dart' show OrdersProvider;
import '../widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = "/orders";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Your Orders"),
        ),
        drawer: MainDrawer(),
        body: FutureBuilder(
            future: Provider.of<OrdersProvider>(context, listen: false)
                .fetchAndSetOrders(),
            builder: (ctx, dataSnapshot) {
              print(dataSnapshot.connectionState);
              if (dataSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                if (dataSnapshot.error != null) {
                  //Error Handling
                  return Center(child: Text("An error occured!"));
                } else {
                  return Consumer<OrdersProvider>(
                      builder: (ctx, orderData, child) => ListView.builder(
                            itemBuilder: (ctx, i) =>
                                OrderItem(orderData.orders[i]),
                            itemCount: orderData.orders.length,
                          ));
                }
              }
            }));
  }
}
