import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/products.dart';
import 'package:shopping_app/screens/cart_details_screen.dart';
import 'package:shopping_app/widgets/app_drawer.dart';
import '../providers/cart.dart';
import '../widgets/badge.dart';
import '../widgets/product_grid.dart';
import '../components/AppBar.dart';

enum FilterOptions { Favorites, All }

class ProductsListScreen extends StatefulWidget {
  @override
  State<ProductsListScreen> createState() => _ProductsListScreenState();
}

class _ProductsListScreenState extends State<ProductsListScreen> {
  var _showOnlyFavorites = false;
  var _isInit = true;
  var _isLoading = false;
  @override
  void initState() {
    // Future.delayed(Duration.zero).then((value) {
    //   Provider.of<Products>(context).fetchAndSetProducts();
    // });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchAndSetProducts(true).then((value) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(appBar: AppBar(), title: Text('My shop'), widgets: [
        PopupMenuButton(
          onSelected: (FilterOptions value) {
            setState(() {
              if (value == FilterOptions.Favorites) {
                _showOnlyFavorites = true;
              } else {
                _showOnlyFavorites = false;
              }
            });
          },
          icon: const Icon(Icons.more_vert),
          itemBuilder: (_) => [
            const PopupMenuItem(
              // ignore: sort_child_properties_last
              child: Text('Only favorite'),
              value: FilterOptions.Favorites,
            ),
            const PopupMenuItem(
              // ignore: sort_child_properties_last
              child: Text('Show All'),
              value: FilterOptions.All,
            ),
          ],
        ),
        Consumer<Cart>(
          builder: (_, cart, ch) => Badge(
              child: ch as dynamic,
              value: cart.itemCount.toString(),
              color: Colors.red),
          child: IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.of(context).pushNamed(CartDetails.routeName);
            },
          ),
        )
      ]),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(_showOnlyFavorites),
    );
  }
}
