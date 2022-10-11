import 'package:flutter/foundation.dart';
import '../providers/cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime date;

  OrderItem(
      {required this.id,
      required this.amount,
      required this.products,
      required this.date});
}

class Order with ChangeNotifier {
  List<OrderItem> _orders = [];
  String? authToken;
  String? userId;
  Order(this.authToken, this.userId, this._orders);
  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final url = Uri.parse(
        'https://flutter-app-eb779-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken');
    final res = await http.get(url);
    final extractedData = json.decode(res.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    final List<OrderItem> loadedOrders = [];
    extractedData.forEach((oId, oData) {
      loadedOrders.add(OrderItem(
          id: oId,
          amount: oData['amount'],
          products: (oData['products'] as List<dynamic>)
              .map((p) => CartItem(
                  id: p['id'],
                  name: p['name'],
                  quantity: p['quantity'],
                  price: p['price']))
              .toList(),
          date: DateTime.parse(oData['date'])));
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = Uri.parse(
        'https://flutter-app-eb779-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken');
    final timeStamp = DateTime.now();
    final res = await http.post(url,
        body: json.encode({
          'amount': total,
          'date': timeStamp.toIso8601String(),
          'products': cartProducts
              .map((cp) => {
                    'id': cp.id,
                    'name': cp.name,
                    'price': cp.price,
                    'quantity': cp.quantity
                  })
              .toList()
        }));
    _orders.insert(
        0,
        OrderItem(
            id: json.decode(res.body)['name'],
            amount: total,
            products: cartProducts,
            date: timeStamp));
    notifyListeners();
  }
}
