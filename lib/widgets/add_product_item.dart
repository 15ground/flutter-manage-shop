import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/product.dart';
import 'package:shopping_app/providers/products.dart';
import 'package:shopping_app/screens/edit_product_screen.dart';

class AddProductItem extends StatelessWidget {
  final Product product;
  AddProductItem(this.product);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(backgroundImage: NetworkImage(product.imgSrc)),
      title: Text(product.name),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName,
                  arguments: product.id);
            },
            color: Theme.of(context).primaryColor,
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              try {
                await Provider.of<Products>(context, listen: false)
                    .deleteProduct(product.id);
              } catch (e) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('Deleting failed!')));
              }
            },
            color: Theme.of(context).errorColor,
          ),
        ],
      ),
    );
  }
}
