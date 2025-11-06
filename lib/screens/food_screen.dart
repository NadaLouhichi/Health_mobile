import 'package:flutter/material.dart';
import '../repositories/food_repository.dart';
import '../models/food_item.dart';

class FoodScreen extends StatefulWidget {
  const FoodScreen({super.key});

  @override
  State<FoodScreen> createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen> {
  final repo = FoodRepository();
  final controller = TextEditingController();
  FoodItem? food;

  Future<void> searchFood() async {
    final result = await repo.getFood(controller.text.trim());
    setState(() {
      food = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nutrition Info')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Enter product barcode or name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: searchFood,
              child: const Text('Search'),
            ),
            const SizedBox(height: 20),
            if (food != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(food!.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                      const SizedBox(height: 8),
                      Text('Calories: ${food!.calories ?? 0} kcal'),
                      Text('Proteins: ${food!.proteins ?? 0} g'),
                      Text('Carbs: ${food!.carbs ?? 0} g'),
                      Text('Fats: ${food!.fats ?? 0} g'),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
