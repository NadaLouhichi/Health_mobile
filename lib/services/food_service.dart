import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/food_item.dart';

class FoodService {
  Future<FoodItem?> fetchFood(String query) async {
    try {
      final url = Uri.parse('https://world.openfoodfacts.org/api/v2/product/$query.json');
      final res = await http.get(url);

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);

        if (data['product'] != null) {
          final product = data['product'];
          final nutriments = product['nutriments'] ?? {};

          return FoodItem(
            id: product['_id'] ?? '',
            name: product['product_name'] ?? 'Unknown',
            calories: nutriments['energy-kcal_100g']?.toDouble() ?? 0.0,
            proteins: nutriments['proteins_100g']?.toDouble() ?? 0.0,
            carbs: nutriments['carbohydrates_100g']?.toDouble() ?? 0.0,
            fats: nutriments['fat_100g']?.toDouble() ?? 0.0,
          );
        }
      }
      return null;
    } catch (e) {
      print('Error fetching food: $e');
      return null;
    }
  }
}
