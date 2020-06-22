import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/main_drawer.dart';
import '../providers/orders_provider.dart' show OrdersProvider;
import '../widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = "/orders";
  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<OrdersProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Orders"),
      ),
      drawer: MainDrawer(),
      body: ListView.builder(
        itemBuilder: (ctx, i) => OrderItem(orderData.orders[i]),
        itemCount: orderData.orders.length,
      ),
    );
  }
}
