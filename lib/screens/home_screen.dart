import 'package:flutter/material.dart';
import '../services/business_logic.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bmi = calculateBMI(70, 170);
    final calories = calculateCalories('Running', 30, 70);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Bienvenue dans votre application Santé & Fitness 💪',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text('Exemple d’IMC: ${bmi.toStringAsFixed(1)}',
                style: const TextStyle(fontSize: 16)),
            Text('Calories brûlées (30 min running): ${calories.toStringAsFixed(1)} kcal',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 40),
            const Icon(Icons.favorite, color: Colors.red, size: 40),
            const SizedBox(height: 10),
            const Text('Utilisez le menu en bas pour explorer 👇'),
          ],
        ),
      ),
    );
  }
}
