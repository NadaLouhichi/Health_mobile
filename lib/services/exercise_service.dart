import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/exercise.dart';
import 'api_constants.dart';

class ExerciseService {
  Future<List<Exercise>> fetchExercises() async {
    final url = Uri.parse('${ApiConstants.wgerBaseUrl}exercise/?language=2&limit=10');
    final response = await http.get(url, headers: {
      'Authorization': 'Token ${ApiConstants.wgerApiKey}',
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List exercises = data['results'];
      return exercises.map((e) => Exercise.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load exercises');
    }
  }
}
