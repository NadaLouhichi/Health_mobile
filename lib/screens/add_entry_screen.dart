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
  final _formKey = GlobalKey<FormState>();

  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _durationController = TextEditingController();
  final _ageController = TextEditingController();

  String? selectedGender;
  String? selectedExercise;
  String? selectedActivity;

  bool _saving = false;
  String? _message;

  @override
  void initState() {
    super.initState();
    if (widget.entry != null) {
      _weightController.text = widget.entry!.weight.toString();
      _heightController.text = widget.entry!.height.toString();
      _ageController.text = widget.entry!.age.toString();
      selectedGender = widget.entry!.gender;
      selectedActivity = widget.entry!.activityLevel;
      selectedExercise = widget.entry!.exerciseType;
      _durationController.text = widget.entry!.caloriesBurnedDuration
          .toString();
    }
  }

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    _durationController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future<void> _saveEntry() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);

    final weight = double.parse(_weightController.text);
    final height = double.parse(_heightController.text);
    final duration = int.tryParse(_durationController.text) ?? 0;
    final exercise = selectedExercise ?? 'None';
    final age = int.parse(_ageController.text);
    final gender = selectedGender!;

    final bmi = calculateBMI(weight, height);
    double caloriesBurned = 0;
    if (exercise != 'None' && duration > 0) {
      caloriesBurned = calculateCalories(exercise, duration, weight);
    }
    final bmr = calculateBMR(gender, weight, height, age);
    final daily = dailyCalories(bmr, selectedActivity ?? 'light');

    final entry = HealthEntry(
      id: widget.entry?.id,
      date: widget.entry?.date ?? DateTime.now(),
      bmi: bmi,
      caloriesBurned: caloriesBurned,
      caloriesBurnedDuration: duration,
      caloriesConsumed: widget.entry?.caloriesConsumed ?? 0,
      exerciseType: exercise,
      bmr: bmr,
      dailyCalories: daily,
      gender: gender,
      age: age,
      activityLevel: selectedActivity ?? 'light',
      height: height,
      weight: weight,
    );

    if (widget.entry == null) {
      await repo.addHealthEntry(entry);
    } else {
      await repo.updateHealthEntry(entry);
    }

    setState(() {
      _saving = false;
      _message = widget.entry == null
          ? 'Entrée enregistrée avec succès ✅'
          : 'Entrée mise à jour avec succès ✅';
    });

    Navigator.pop(context, true);
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
      errorStyle: const TextStyle(color: Colors.red),
    );
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
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                // Poids
                TextFormField(
                  controller: _weightController,
                  keyboardType: TextInputType.number,
                  decoration: _inputDecoration('Poids (kg)'),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Veuillez entrer le poids';
                    final v = double.tryParse(value);
                    if (v == null || v <= 0) return 'Poids invalide';
                    if (v > 300) return 'Le poids ne doit pas dépasser 300 kg';
                    return null;
                  },
                ),
                const SizedBox(height: 10),

                // Taille
                TextFormField(
                  controller: _heightController,
                  keyboardType: TextInputType.number,
                  decoration: _inputDecoration('Taille (cm)'),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Veuillez entrer la taille';
                    final v = double.tryParse(value);
                    if (v == null || v <= 0) return 'Taille invalide';
                    if (v > 250) return 'La taille ne doit pas dépasser 250 cm';
                    return null;
                  },
                ),
                const SizedBox(height: 10),

                // Durée
                TextFormField(
                  controller: _durationController,
                  keyboardType: TextInputType.number,
                  decoration: _inputDecoration('Durée (minutes, facultatif)'),
                  validator: (value) {
                    if (value == null || value.isEmpty) return null;
                    final v = int.tryParse(value);
                    if (v == null || v < 0) return 'Durée invalide';
                    if (v > 600)
                      return 'La durée ne doit pas dépasser 600 minutes';
                    return null;
                  },
                ),
                const SizedBox(height: 10),

                // Exercise
                DropdownButtonFormField<String>(
                  value: selectedExercise,
                  items: const [
                    DropdownMenuItem(value: 'Running', child: Text('Running')),
                    DropdownMenuItem(value: 'Cycling', child: Text('Cycling')),
                    DropdownMenuItem(value: 'Walking', child: Text('Walking')),
                    DropdownMenuItem(
                      value: 'Swimming',
                      child: Text('Swimming'),
                    ),
                    DropdownMenuItem(value: 'None', child: Text('None')),
                  ],
                  onChanged: (v) => setState(() => selectedExercise = v),
                  decoration: _inputDecoration('Type d\'exercice'),
                ),
                const SizedBox(height: 10),

                // Genre
                DropdownButtonFormField<String>(
                  value: selectedGender,
                  items: const [
                    DropdownMenuItem(value: 'male', child: Text('Homme')),
                    DropdownMenuItem(value: 'female', child: Text('Femme')),
                  ],
                  onChanged: (v) => setState(() => selectedGender = v),
                  decoration: _inputDecoration('Genre'),
                  validator: (value) =>
                      value == null ? 'Veuillez sélectionner le genre' : null,
                ),
                const SizedBox(height: 10),

                // Âge
                TextFormField(
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  decoration: _inputDecoration('Âge (années)'),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Veuillez entrer l’âge';
                    final v = int.tryParse(value);
                    if (v == null || v <= 0) return 'Âge invalide';
                    if (v > 120) return 'L’âge ne doit pas dépasser 120 ans';
                    return null;
                  },
                ),
                const SizedBox(height: 10),

                // Activité
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
                  onChanged: (v) => setState(() => selectedActivity = v),
                  decoration: _inputDecoration('Niveau d\'activité'),
                  validator: (value) => value == null
                      ? 'Veuillez sélectionner le niveau d’activité'
                      : null,
                ),
                const SizedBox(height: 20),

                // Save button
                _saving
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _saveEntry,
                        child: Text(
                          isEditing ? 'Mettre à jour' : 'Enregistrer',
                        ),
                      ),
                if (_message != null) ...[
                  const SizedBox(height: 20),
                  Text(
                    _message!,
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
