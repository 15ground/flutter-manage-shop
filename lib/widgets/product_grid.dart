import 'package:flutter/material.dart';
import '../providers/products.dart';
import '../widgets/product_item.dart';
import 'package:provider/provider.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavorites;
  ProductsGrid(this.showFavorites);
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products =
        showFavorites ? productsData.favoriteItems : productsData.list;
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
      itemBuilder: (context, index) {
        return ChangeNotifierProvider.value(
            value: products[index], child: ProductItem());
      },
      itemCount: products.length,
    );
  }
}
