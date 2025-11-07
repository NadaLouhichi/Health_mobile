import 'package:html/parser.dart' as html_parser;

class Exercise {
  final int id;
  final String name;
  final String category;
  final String description;

  Exercise({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    final rawDesc = json['description'] ?? '';
    final parsedDesc = html_parser.parse(rawDesc).body?.text ?? ''; // strip HTML

    return Exercise(
      id: json['id'],
      name: json['name'] ?? 'Unknown',
      category: json['category']?.toString() ?? '',
      description: parsedDesc.isNotEmpty ? parsedDesc : 'No description available',
    );
  }
}
