import 'package:flutter/material.dart';
import 'package:shopping_app/models/http_exception.dart';
import 'product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Products with ChangeNotifier {
  List<Product> _products = [];
  String? authToken;
  String? userId;
  Products(this.authToken, this.userId, this._products);
  List<Product> get favoriteItems {
    return _products.where((p) => p.isFavorite).toList();
  }

  List<Product> get list {
    return [..._products];
  }

  Product findById(String id) {
    return _products.firstWhere((p) => p.id == id);
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    final filter = filterByUser ? 'orderBy="userId"&equalTo="$userId"' : '';
    var url = Uri.parse(
        'https://flutter-app-eb779-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filter');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      url = Uri.parse(
          'https://flutter-app-eb779-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$authToken');
      final favoriteRes = await http.get(url);
      final favoriteData = jsonDecode(favoriteRes.body);
      final List<Product> loadedProducts = [];
      extractedData.forEach((pId, pData) {
        loadedProducts.add(Product(
            id: pId,
            name: pData['name'],
            price: pData['price'],
            imgSrc: pData['imgSrc'],
            desc: pData['desc'],
            isFavorite:
                favoriteData == null ? false : favoriteData[pId] ?? false));
      });
      _products = loadedProducts;
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse(
        'https://flutter-app-eb779-default-rtdb.firebaseio.com/products.json?auth=$authToken');

    try {
      final response = await http.post(url,
          body: json.encode({
            'name': product.name,
            'desc': product.desc,
            'imgSrc': product.imgSrc,
            'price': product.price,
            'isFavorite': product.isFavorite,
            'userId': userId
          }));
      final newProduct = Product(
          id: json.decode(response.body)['name'],
          name: product.name,
          price: product.price,
          imgSrc: product.imgSrc,
          desc: product.desc);
      _products.add(newProduct);
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final productIndex = _products.indexWhere((p) => p.id == id);
    if (productIndex >= 0) {
      final url = Uri.parse(
          'https://flutter-app-eb779-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken');
      await http.patch(url,
          body: json.encode({
            'name': newProduct.name,
            'price': newProduct.price,
            'imgSrc': newProduct.imgSrc,
            'desc': newProduct.desc
          }));
      _products[productIndex] = newProduct;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse(
        'https://flutter-app-eb779-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken');
    final productIndex = _products.indexWhere((p) => p.id == id);
    Product? existProduct = _products[productIndex];
    _products.removeAt(productIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _products.insert(productIndex, existProduct);
      notifyListeners();
      throw HttpException('Could not delete product');
    }
    existProduct = null;
  }
}
