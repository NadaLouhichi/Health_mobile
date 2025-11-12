import 'package:flutter/material.dart';
import '../repositories/health_repository.dart';
import '../models/health_entry.dart';
import 'add_entry_screen.dart';
import '../services/export_service.dart';

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
      appBar: AppBar(
        title: const Text('Santé & Fitness'),
        actions: [
          if (entries.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.download),
              tooltip: 'Télécharger le rapport PDF',
              onPressed: () async {
                await ExportService.generateHealthReport(entries);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Rapport téléchargé avec succès ✅'),
                    ),
                  );
                }
              },
            ),
        ],
      ),
      body: entries.isEmpty
          ? const Center(child: Text('Aucune donnée disponible'))
          : RefreshIndicator(
              onRefresh: loadEntries,
              child: ListView.builder(
                itemCount: entries.length,
                itemBuilder: (context, index) {
                  final entry = entries[index];
                  return ListTile(
                    title: Text('BMI: ${entry.bmi.toStringAsFixed(2)}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Genre: ${entry.gender}, Âge: ${entry.age}, Taille: ${entry.height} cm, Poids: ${entry.weight} kg',
                        ),
                        if (entry.caloriesBurned > 0)
                          Text(
                            'Calories brûlées: ${entry.caloriesBurned.toStringAsFixed(1)} kcal',
                          ),
                        Text('BMR: ${entry.bmr.toStringAsFixed(1)} kcal'),
                        Text(
                          'Besoins quotidiens: ${entry.dailyCalories.toStringAsFixed(1)} kcal',
                        ),
                        const SizedBox(height: 4),
                      ],
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) async {
                        if (value == 'edit') {
                          final shouldRefresh = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AddEntryScreen(entry: entry),
                            ),
                          );
                          if (shouldRefresh == true) loadEntries();
                        } else if (value == 'delete') {
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text('Confirmer la suppression'),
                              content: const Text(
                                'Voulez-vous vraiment supprimer cette entrée ?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: const Text('Annuler'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text('Supprimer'),
                                ),
                              ],
                            ),
                          );
                          if (confirmed == true) {
                            await repo.deleteHealthEntry(entry.id!);
                            loadEntries();
                          }
                        }
                      },
                      itemBuilder: (context) => const [
                        PopupMenuItem(value: 'edit', child: Text('Modifier')),
                        PopupMenuItem(
                          value: 'delete',
                          child: Text('Supprimer'),
                        ),
                      ],
                      child: Text(
                        '${entry.date.day}/${entry.date.month}/${entry.date.year}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final shouldRefresh = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddEntryScreen()),
          );
          if (shouldRefresh == true) loadEntries();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
