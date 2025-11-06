import 'package:flutter/material.dart';
import '../repositories/exercise_repository.dart';
import '../models/exercise.dart';

class ExerciseScreen extends StatefulWidget {
  const ExerciseScreen({super.key});

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  final ExerciseRepository repo = ExerciseRepository();
  late Future<List<Exercise>> exercises;

  @override
  void initState() {
    super.initState();
    _loadExercises();
  }

  void _loadExercises() {
    setState(() {
      exercises = repo.getExercises();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Exercises')),
      body: FutureBuilder<List<Exercise>>(
        future: exercises,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Show friendly error and retry button
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Failed to load exercises.\n${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _loadExercises,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '⚠️ On Chrome, ensure the Flask server is running at http://127.0.0.1:5000',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No exercises found.'));
          }

          final data = snapshot.data!;
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final ex = data[index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text(ex.name),
                  subtitle: ex.description.isNotEmpty
                      ? Text(ex.description)
                      : const Text('No description'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
