import 'package:flutter/material.dart';
import '../repositories/health_repository.dart';
import '../models/health_entry.dart';
import '../services/business_logic.dart';

class AddEntryScreen extends StatefulWidget {
  final HealthEntry? entry;
  const AddEntryScreen({super.key, this.entry});

  @override
  State<AddEntryScreen> createState() => _AddEntryScreenState();
}

class _AddEntryScreenState extends State<AddEntryScreen> {
  final repo = HealthRepository();

  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _durationController = TextEditingController();
  final ageController = TextEditingController();

  String? selectedGender;
  String? selectedExercise;
  String? selectedActivity;

  bool _saving = false;
  String? _message;

  @override
  void initState() {
    super.initState();
    // Prefill fields if editing
    if (widget.entry != null) {
      _weightController.text = widget.entry!.weight.toString();
      _heightController.text = widget.entry!.height.toString();
      ageController.text = widget.entry!.age.toString();
      selectedGender = widget.entry!.gender;
      selectedActivity = widget.entry!.activityLevel;
    }
  }

  Future<void> _saveEntry() async {
    final weight = double.tryParse(_weightController.text);
    final height = double.tryParse(_heightController.text);
    final duration = int.tryParse(_durationController.text) ?? 0;
    final exercise = selectedExercise ?? 'None';
    final age = int.tryParse(ageController.text);
    final gender = selectedGender;

    if (weight == null || height == null || age == null || gender == null) {
      setState(() {
        _message = 'Veuillez remplir tous les champs correctement.';
      });
      return;
    }

    setState(() => _saving = true);

    // BMI
    final bmi = calculateBMI(weight, height);

    // Calories burned (optional)
    double caloriesBurned = 0;
    if (exercise != 'None' && duration > 0) {
      caloriesBurned = calculateCalories(exercise, duration, weight);
    }

    // BMR and daily calories
    final bmr = calculateBMR(gender, weight, height, age);
    final daily = dailyCalories(bmr, selectedActivity ?? 'light');

    // 🟩 If editing, keep the same date and ID
    final entry = HealthEntry(
      id: widget.entry?.id,
      date: widget.entry?.date ?? DateTime.now(),
      bmi: bmi,
      caloriesBurned: caloriesBurned,
      caloriesConsumed: widget.entry?.caloriesConsumed ?? 0,
      bmr: bmr,
      dailyCalories: daily,
      gender: gender,
      age: age,
      activityLevel: selectedActivity ?? 'light',
      height: height,
      weight: weight,
    );

    // 🟢 Add or Update
    if (widget.entry == null) {
      await repo.addHealthEntry(entry);
    } else {
      await repo.updateHealthEntry(entry);
    }

    final all = await repo.getAllEntries();
    print('✅ Total entries saved: ${all.length}');

    setState(() {
      _saving = false;
      _message = widget.entry == null
          ? 'Entrée enregistrée avec succès ✅'
          : 'Entrée mise à jour avec succès ✅';
    });

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.entry != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? 'Modifier Entrée Santé' : 'Nouvelle Entrée Santé',
        ),
      ),
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
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedExercise,
                items: const [
                  DropdownMenuItem(value: 'Running', child: Text('Running')),
                  DropdownMenuItem(value: 'Cycling', child: Text('Cycling')),
                  DropdownMenuItem(value: 'Swimming', child: Text('Swimming')),
                  DropdownMenuItem(
                    value: 'None',
                    child: Text('Does not apply'),
                  ),
                ],
                onChanged: (value) => setState(() => selectedExercise = value),
                decoration: const InputDecoration(
                  labelText: 'Type d\'exercice',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _durationController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Durée (minutes, optional)',
                ),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedGender,
                items: const [
                  DropdownMenuItem(value: 'male', child: Text('Homme')),
                  DropdownMenuItem(value: 'female', child: Text('Femme')),
                ],
                onChanged: (value) => setState(() => selectedGender = value),
                decoration: const InputDecoration(labelText: 'Genre'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Âge (en années)'),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedActivity,
                items: const [
                  DropdownMenuItem(
                    value: 'sedentary',
                    child: Text('Sédentaire'),
                  ),
                  DropdownMenuItem(
                    value: 'light',
                    child: Text('Légèrement actif'),
                  ),
                  DropdownMenuItem(
                    value: 'moderate',
                    child: Text('Modérément actif'),
                  ),
                  DropdownMenuItem(value: 'active', child: Text('Actif')),
                  DropdownMenuItem(
                    value: 'very_active',
                    child: Text('Très actif'),
                  ),
                ],
                onChanged: (value) => setState(() => selectedActivity = value),
                decoration: const InputDecoration(
                  labelText: 'Niveau d\'activité',
                ),
              ),
              const SizedBox(height: 20),
              _saving
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _saveEntry,
                      child: Text(isEditing ? 'Mettre à jour' : 'Enregistrer'),
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
