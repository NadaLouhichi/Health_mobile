import 'dart:convert';
import 'package:flutter/foundation.dart'; // for kIsWeb
import 'package:http/http.dart' as http;
import '../models/exercise.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ExerciseRepository {
  Future<List<Exercise>> getExercises({int limit = 15}) async {
    Uri url;
    Map<String, String> headers = {};

    if (kIsWeb) {
      // On Web: use Flask proxy
      url = Uri.parse('http://127.0.0.1:5000/exercises?limit=$limit');
      // No headers needed for Flask proxy
    } else {
      // On Mobile: call Wger API directly
      final apiKey = dotenv.env['WGER_API_KEY'] ?? '';
      url = Uri.parse('https://wger.de/api/v2/exercise/?language=2&limit=$limit');
      headers = {'Authorization': 'Token $apiKey'};
    }

    final res = await http.get(url, headers: headers);

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      final results = data['results'] as List;

      // Filter valid entries
      return results
          .map((e) => Exercise.fromJson(e))
          .where((ex) => ex.name.isNotEmpty && ex.name != 'Unnamed')
          .toList();
    } else {
      throw Exception('Failed to load exercises');
    }
  }
}
