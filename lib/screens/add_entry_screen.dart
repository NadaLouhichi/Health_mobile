import 'package:flutter/material.dart';
import '../repositories/health_repository.dart';
import '../models/health_entry.dart';
import '../services/business_logic.dart';

class AddEntryScreen extends StatefulWidget {
  const AddEntryScreen({super.key});

  @override
  State<AddEntryScreen> createState() => _AddEntryScreenState();
}

class _AddEntryScreenState extends State<AddEntryScreen> {
  final repo = HealthRepository();

  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _exerciseController = TextEditingController();
  final _durationController = TextEditingController();

  bool _saving = false;
  String? _message;

  Future<void> _saveEntry() async {
    final weight = double.tryParse(_weightController.text);
    final height = double.tryParse(_heightController.text);
    final duration = int.tryParse(_durationController.text);
    final exercise = _exerciseController.text.trim();

    if (weight == null ||
        height == null ||
        duration == null ||
        exercise.isEmpty) {
      setState(
        () => _message = 'Veuillez remplir tous les champs correctement.',
      );
      return;
    }

    setState(() => _saving = true);

    final bmi = calculateBMI(weight, height);
    final calories = calculateCalories(exercise, duration, weight);

    final entry = HealthEntry(
      date: DateTime.now(),
      bmi: bmi,
      caloriesBurned: calories,
      caloriesConsumed: 0,
    );

    await repo.addHealthEntry(entry);
    final all = await repo.getAllEntries();
    print('✅ Total entries saved: ${all.length}'); // confirmation log

    setState(() {
      _saving = false;
      _message = 'Entrée enregistrée avec succès ✅';
    });

    _weightController.clear();
    _heightController.clear();
    _exerciseController.clear();
    _durationController.clear();

    Navigator.pop(context, true); // 👈 tell previous screen to refresh
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nouvelle Entrée Santé')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Poids (kg)'),
              ),
              TextField(
                controller: _heightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Taille (cm)'),
              ),
              TextField(
                controller: _exerciseController,
                decoration: const InputDecoration(
                  labelText:
                      'Type d\'exercice (Running, Cycling, Swimming, Running)',
                ),
              ),
              TextField(
                controller: _durationController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Durée (minutes)'),
              ),
              const SizedBox(height: 20),
              _saving
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _saveEntry,
                      child: const Text('Enregistrer'),
                    ),
              const SizedBox(height: 20),
              if (_message != null)
                Text(
                  _message!,
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
