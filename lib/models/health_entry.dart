class HealthEntry {
  final int? id;
  final DateTime date;
  final double bmi;
  final double caloriesBurned;
  final double caloriesConsumed;

  HealthEntry({
    this.id,
    required this.date,
    required this.bmi,
    required this.caloriesBurned,
    required this.caloriesConsumed,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'date': date.toIso8601String(),
        'bmi': bmi,
        'caloriesBurned': caloriesBurned,
        'caloriesConsumed': caloriesConsumed,
      };

  factory HealthEntry.fromMap(Map<String, dynamic> map) => HealthEntry(
        id: map['id'],
        date: DateTime.parse(map['date']),
        bmi: map['bmi'],
        caloriesBurned: map['caloriesBurned'],
        caloriesConsumed: map['caloriesConsumed'],
      );
}
