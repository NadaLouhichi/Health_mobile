import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../repositories/health_repository.dart';
import '../models/health_entry.dart';
import 'add_entry_screen.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  final repo = HealthRepository();
  late Future<List<HealthEntry>> entries;

  @override
  void initState() {
    super.initState();
    _reloadData();
  }

  void _reloadData() {
    setState(() {
      entries = repo.getAllEntries();
    });
  }

  Future<void> _deleteEntry(int id) async {
    await repo.deleteHealthEntry(id);
    _reloadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Health Stats')),
      body: FutureBuilder<List<HealthEntry>>(
        future: entries,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available.'));
          }

          final data = snapshot.data!;
          final bmiSpots = data.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.bmi)).toList();
          final calSpots = data.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.caloriesBurned)).toList();

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final entry = data[index];
                    return Card(
                      margin: const EdgeInsets.all(8),
                      child: ListTile(
                        title: Text('BMI: ${entry.bmi.toStringAsFixed(2)}'),
                        subtitle: Text('Calories brûlées: ${entry.caloriesBurned.toStringAsFixed(1)} kcal'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteEntry(entry.id!),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              const Text('Graphiques Santé', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Expanded(
                child: LineChart(
                  LineChartData(
                    lineBarsData: [
                      LineChartBarData(spots: bmiSpots, isCurved: true, color: Colors.blue),
                      LineChartBarData(spots: calSpots, isCurved: true, color: Colors.orange),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (_) => const AddEntryScreen()));
          _reloadData();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
