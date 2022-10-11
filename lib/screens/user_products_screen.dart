import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/screens/edit_product_screen.dart';
import 'package:shopping_app/widgets/add_product_item.dart';
import 'package:shopping_app/widgets/app_drawer.dart';
import '../providers/products.dart';
import '../components/AppBar.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/user-products';
  Future<void> refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    // final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: BaseAppBar(
        appBar: AppBar(),
        title: const Text('Your products'),
        widgets: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName);
              },
              icon: const Icon(Icons.add))
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: refreshProducts(context),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => refreshProducts(context),
                    child: Consumer<Products>(
                      builder: (context, pData, _) => Padding(
                          padding: const EdgeInsets.all(8),
                          child: ListView.builder(
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  AddProductItem(pData.list[index]),
                                  Divider()
                                ],
                              );
                            },
                            itemCount: pData.list.length,
                          )),
                    ),
                  ),
      ),
    );
  }
}
