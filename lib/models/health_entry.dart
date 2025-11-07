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

  @HiveField(5)
  double bmr;

  @HiveField(6)
  double dailyCalories;

  @HiveField(7)
  String gender;

  @HiveField(8)
  int age;

  @HiveField(9)
  String activityLevel;

  @HiveField(10)
  double height;

  @HiveField(11)
  double weight;

  HealthEntry({
    this.id,
    required this.date,
    required this.bmi,
    required this.caloriesBurned,
    required this.caloriesConsumed,
    required this.bmr,
    required this.dailyCalories,
    required this.gender,
    required this.age,
    required this.activityLevel,
    required this.height,
    required this.weight,
  });

  // For SQLite
  Map<String, dynamic> toMap() => {
    'id': id,
    'date': date.toIso8601String(),
    'bmi': bmi,
    'caloriesBurned': caloriesBurned,
    'caloriesConsumed': caloriesConsumed,
    'bmr': bmr,
    'dailyCalories': dailyCalories,
    'gender': gender,
    'age': age,
    'activityLevel': activityLevel,
    'weight': weight,
    'height': height,
  };

  factory HealthEntry.fromMap(Map<String, dynamic> map) => HealthEntry(
    id: map['id'],
    date: DateTime.parse(map['date']),
    bmi: map['bmi'],
    caloriesBurned: map['caloriesBurned'],
    caloriesConsumed: map['caloriesConsumed'],
    bmr: map['bmr'],
    dailyCalories: map['dailyCalories'],
    gender: map['gender'],
    age: map['age'],
    activityLevel: map['activityLevel'],
    weight: map['weight'],
    height: map['height'],
  );
}
