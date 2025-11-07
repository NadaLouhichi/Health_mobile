import 'package:hive/hive.dart';

part 'health_entry.g.dart';

@HiveType(typeId: 0)
class HealthEntry extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  DateTime date;

  @HiveField(2)
  double bmi;

  @HiveField(3)
  double caloriesBurned;

  @HiveField(4)
  double caloriesConsumed;

  HealthEntry({
    this.id,
    required this.date,
    required this.bmi,
    required this.caloriesBurned,
    required this.caloriesConsumed,
  });

  // For SQLite
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
