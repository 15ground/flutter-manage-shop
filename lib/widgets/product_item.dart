import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/auth.dart';
import '../providers/cart.dart';
import '../screens/product_details_screen.dart';
import '../providers/product.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        // ignore: sort_child_properties_last
        child: GestureDetector(
          onTap: () {
            Navigator.of(context)
                .pushNamed(ProductDetails.routeName, arguments: product);
          },
          child: Image.network(
            product.imgSrc,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          leading: Consumer<Product>(
            builder: (context, product, child) => IconButton(
              icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border),
              onPressed: () {
                product.toggleFavoriteStatus(auth.token!, auth.userId);
              },
              color: Colors.red,
            ),
          ),
          title: Text(
            product.name,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              cart.addItem(product);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  'Added item to cart!',
                ),
                duration: Duration(seconds: 2),
                action: SnackBarAction(
                  label: 'UNDO',
                  onPressed: () {
                    cart.removeSingleItem(product.id);
                  },
                ),
              ));
            },
          ),
        ),
      ),
    );
  }
}
