import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/food_item.dart';

class FoodRepository {
  Future<FoodItem?> getFood(String query) async {
    late Uri url;

    if (RegExp(r'^\d+$').hasMatch(query)) {
      // Barcode search
      url = Uri.parse('https://world.openfoodfacts.org/api/v0/product/$query.json');
      final res = await http.get(url);
      if (res.statusCode != 200) return null;

      final data = jsonDecode(res.body);
      if (data['status'] != 1) return null;

      final product = data['product'];
      return FoodItem(
        name: product['product_name'] ?? 'Unknown',
        calories: (product['nutriments']?['energy-kcal_100g'] ?? 0).toDouble(),
        proteins: (product['nutriments']?['proteins_100g'] ?? 0).toDouble(),
        fats: (product['nutriments']?['fat_100g'] ?? 0).toDouble(),
        carbs: (product['nutriments']?['carbohydrates_100g'] ?? 0).toDouble(),
      );
    } else {
      // Text search
      url = Uri.parse(
          'https://world.openfoodfacts.org/cgi/search.pl?search_terms=$query&search_simple=1&action=process&json=1');
      final res = await http.get(url);
      if (res.statusCode != 200) return null;

      final data = jsonDecode(res.body);
      final products = data['products'] as List;
      if (products.isEmpty) return null;

      final product = products.first;
      return FoodItem(
        name: product['product_name'] ?? 'Unknown',
        calories: (product['nutriments']?['energy-kcal_100g'] ?? 0).toDouble(),
        proteins: (product['nutriments']?['proteins_100g'] ?? 0).toDouble(),
        fats: (product['nutriments']?['fat_100g'] ?? 0).toDouble(),
        carbs: (product['nutriments']?['carbohydrates_100g'] ?? 0).toDouble(),
      );
    }
  }
}
