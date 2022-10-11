import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import '../components/AppBar.dart';
import '../providers/product.dart';

class ProductDetails extends StatelessWidget {
  static const routeName = '/product-details';
  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)?.settings.arguments as Product;
    final loadedProduct = Provider.of<Products>(context).findById(product.id);

    return Scaffold(
      appBar: BaseAppBar(
          appBar: AppBar(), title: Text(loadedProduct.name), widgets: []),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              child: Image.network(
                loadedProduct.imgSrc,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              '\$${loadedProduct.price}',
              style: TextStyle(color: Colors.grey, fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Text(
                loadedProduct.desc,
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            )
          ],
        ),
      ),
    );
  }
}
