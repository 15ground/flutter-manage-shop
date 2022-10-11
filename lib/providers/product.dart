import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier {
  final String id;
  final String name;
  final double price;
  final String imgSrc;
  final String desc;
  bool isFavorite;
  Product(
      {required this.id,
      required this.name,
      required this.price,
      required this.imgSrc,
      required this.desc,
      this.isFavorite = false});

  void _setFavoriteValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus(String token, String userId) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url = Uri.parse(
        'https://flutter-app-eb779-default-rtdb.firebaseio.com/userFavorites/$userId/$id.json?auth=$token');
    try {
      final res = await http.put(url, body: json.encode(isFavorite));
      if (res.statusCode >= 400) {
        _setFavoriteValue(oldStatus);
      }
    } catch (e) {
      _setFavoriteValue(oldStatus);
    }
  }
}
