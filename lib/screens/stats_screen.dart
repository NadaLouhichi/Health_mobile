import 'package:flutter/material.dart';
import '../repositories/health_repository.dart';
import '../models/health_entry.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  final repo = HealthRepository();
  List<HealthEntry> entries = [];

  @override
  void initState() {
    super.initState();
    loadEntries();
  }

  Future<void> loadEntries() async {
    final allEntries = await repo.getAllEntries();
    setState(() => entries = allEntries);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: entries.isEmpty
          ? const Center(child: Text('Aucune donnée disponible'))
          : ListView.builder(
              itemCount: entries.length,
              itemBuilder: (context, index) {
                final entry = entries[index];
                return ListTile(
                  title: Text('BMI: ${entry.bmi.toStringAsFixed(2)}'),
                  subtitle: Text(
                      'Calories brûlées: ${entry.caloriesBurned}, consommées: ${entry.caloriesConsumed}'),
                  trailing: Text('${entry.date.day}/${entry.date.month}/${entry.date.year}'),
                );
              },
            ),
    );
  }
}
