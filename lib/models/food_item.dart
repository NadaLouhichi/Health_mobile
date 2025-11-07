class FoodItem {
  final String? id;
  final String name;
  final double? calories;
  final double? proteins;
  final double? carbs;
  final double? fats;

  FoodItem({
    this.id,
    required this.name,
    this.calories,
    this.proteins,
    this.carbs,
    this.fats,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    final nutriments = json['product']?['nutriments'] ?? {};
    return FoodItem(
      id: json['product']?['_id'] ?? json['product']?['code'],
      name: json['product']?['product_name'] ?? 'Unknown',
      calories: (nutriments['energy-kcal_100g'] ?? 0).toDouble(),
      proteins: (nutriments['proteins_100g'] ?? 0).toDouble(),
      carbs: (nutriments['carbohydrates_100g'] ?? 0).toDouble(),
      fats: (nutriments['fat_100g'] ?? 0).toDouble(),
    );
  }
}
