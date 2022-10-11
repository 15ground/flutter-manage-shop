import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/widgets/app_drawer.dart';
import 'package:shopping_app/widgets/order_item.dart';
import '../providers/orders.dart' show Order;
import '../components/AppBar.dart';

class OrderDetails extends StatefulWidget {
  static const routeName = '/order';

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  var _isLoading = false;
  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) async {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<Order>(context, listen: false).fetchAndSetOrders();
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Order>(context);

    return Scaffold(
      appBar: BaseAppBar(
          appBar: AppBar(), title: Text('Order details'), widgets: []),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemBuilder: (context, index) {
                return OrderCartItem(orderData.orders[index]);
              },
              itemCount: orderData.orders.length,
            ),
      drawer: AppDrawer(),
    );
  }
}
