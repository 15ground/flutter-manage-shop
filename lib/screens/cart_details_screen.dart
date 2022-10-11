import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/orders.dart';
import 'package:shopping_app/widgets/cart_item.dart';
import '../components/AppBar.dart';
import '../providers/cart.dart';

class CartDetails extends StatelessWidget {
  static const routeName = '/cart';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: BaseAppBar(
          appBar: AppBar(), title: const Text('Your cart'), widgets: []),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(fontSize: 20),
                    ),
                    const Spacer(),
                    Chip(
                      label: Text(
                        '\$${cart.totalAmount.toStringAsFixed(2)}',
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    OrderButton(cart: cart)
                  ],
                )),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
              child: ListView.builder(
            itemBuilder: (context, index) {
              return CartItemDetails(cart.carts.values.toList()[index],
                  cart.carts.keys.toList()[index]);
            },
            itemCount: cart.carts.length,
          ))
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: (widget.cart.totalAmount <= 0 || _isLoading)
            ? null
            : () async {
                setState(() {
                  _isLoading = true;
                });
                await Provider.of<Order>(context, listen: false).addOrder(
                    widget.cart.carts.values.toList(), widget.cart.totalAmount);
                setState(() {
                  _isLoading = false;
                });
                widget.cart.clear();
              },
        child: Text('Order now'));
  }
}
