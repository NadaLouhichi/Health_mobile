import 'dart:convert';
import 'package:flutter/foundation.dart'; // for kIsWeb
import 'package:http/http.dart' as http;
import '../models/exercise.dart';

class ExerciseRepository {
  Future<List<Exercise>> getExercises({int limit = 15}) async {
    // 👇 Replace with your local IP when testing on mobile
    final baseUrl = kIsWeb
        ? 'http://127.0.0.1:5000/exercises'
        : 'http://192.168.1.106:5000/exercises';

    final url = Uri.parse('$baseUrl?limit=$limit');
    final res = await http.get(url);

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);

      // 🟢 Flask returns a list
      if (data is List) {
        return data.map((e) => Exercise.fromJson(e)).toList();
      }

      // 🟡 Direct WGER fallback (if needed)
      final results = data['results'] as List;
      return results.map((e) => Exercise.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load exercises');
    }
  }
}
