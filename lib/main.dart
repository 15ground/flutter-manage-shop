import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/auth.dart';
import 'package:shopping_app/providers/orders.dart';
import 'package:shopping_app/screens/auth_screen.dart';
import 'package:shopping_app/screens/cart_details_screen.dart';
import 'package:shopping_app/screens/edit_product_screen.dart';
import 'package:shopping_app/screens/order_details_screen.dart';
import 'package:shopping_app/screens/user_products_screen.dart';
import './providers/cart.dart';
import './providers/products.dart';
import './screens/product_details_screen.dart';
import './screens/products_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (context, value, previous) => Products(
              value.token, value.userId, previous == null ? [] : previous.list),
          create: (context) => Products(null, null, []),
        ),
        ChangeNotifierProvider(
          create: (_) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Order>(
          update: (context, value, previous) => Order(value.token, value.userId,
              previous == null ? [] : previous.orders),
          create: (_) => Order(null, null, []),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, child) => MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
              primarySwatch: Colors.deepPurple,
              accentColor: Colors.deepOrange,
              fontFamily: 'Lato'),
          home: auth.isAuth ? ProductsListScreen() : AuthScreen(),
          routes: {
            ProductDetails.routeName: (context) => ProductDetails(),
            CartDetails.routeName: (context) => CartDetails(),
            OrderDetails.routeName: (context) => OrderDetails(),
            UserProductScreen.routeName: (context) => UserProductScreen(),
            EditProductScreen.routeName: (context) => EditProductScreen(),
          },
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
