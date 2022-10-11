import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:shopping_app/providers/product.dart';

class CartItem {
  final String id;
  final String name;
  final int quantity;
  final double price;
  CartItem(
      {required this.id,
      required this.name,
      required this.quantity,
      required this.price});
}

class Cart extends ChangeNotifier {
  Map<String, CartItem> _carts = {};
  Map<String, CartItem> get carts {
    return {..._carts};
  }

  void addItem(Product product) {
    if (_carts.containsKey(product.id)) {
      _carts.update(
          product.id,
          (existingCart) => CartItem(
              id: existingCart.id,
              name: existingCart.name,
              quantity: existingCart.quantity + 1,
              price: existingCart.price));
    } else {
      _carts.putIfAbsent(
          product.id,
          () => CartItem(
              id: DateTime.now().toString(),
              name: product.name,
              price: product.price,
              quantity: 1));
    }
    notifyListeners();
  }

  int get itemCount {
    return _carts.length;
  }

  double get totalAmount {
    var total = 0.0;
    _carts.forEach((key, cartItems) {
      total += cartItems.price * cartItems.quantity;
    });
    return total;
  }

  void removeItem(String productId) {
    _carts.remove(productId);
    notifyListeners();
  }

  void clear() {
    _carts = {};
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_carts.containsKey(productId)) {
      return;
    }
    if (_carts[productId]!.quantity > 1) {
      _carts.update(
          productId,
          (existingCartItem) => CartItem(
              id: existingCartItem.id,
              name: existingCartItem.name,
              quantity: existingCartItem.quantity - 1,
              price: existingCartItem.price));
    } else {
      _carts.remove(productId);
    }
    notifyListeners();
  }
}
