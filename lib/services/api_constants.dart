import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static const String wgerBaseUrl = 'https://wger.de/api/v2/';
  static final String wgerApiKey = dotenv.env['WGER_API_KEY'] ?? '';
  static const String openFoodBaseUrl = 'https://world.openfoodfacts.org/api/v0/';
}
