import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';

class CartItemDetails extends StatelessWidget {
  final CartItem cart;
  final String productId;
  CartItemDetails(this.cart, this.productId);
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(cart.id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(Icons.delete, color: Colors.white, size: 40),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      confirmDismiss: (direction) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Are you sure?'),
          content: Text('Do you want to remove this item from cart?'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text('No')),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text('Yes'))
          ],
        ),
      ),
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: Padding(
                padding: EdgeInsets.all(5),
                child: FittedBox(
                    child: CircleAvatar(child: Text('\$${cart.price}')))),
            title: Text(cart.name),
            subtitle: Text('Total: \$${cart.price * cart.quantity}'),
            trailing: Text('${cart.quantity} x'),
          ),
        ),
      ),
    );
  }
}
