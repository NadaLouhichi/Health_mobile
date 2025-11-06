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
    return Exercise(
      id: json['id'],
      name: json['name'] ?? 'Unknown',
      category: json['category']?.toString() ?? '',
      description: json['description'] ?? '',
    );
  }
}
