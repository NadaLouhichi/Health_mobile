double calculateBMI(double weightKg, double heightCm) {
  final heightM = heightCm / 100;
  return weightKg / (heightM * heightM);
}

double calculateCalories(String exerciseType, int durationMinutes, double weightKg) {
  final metValues = {
    'Running': 9.8,
    'Cycling': 7.5,
    'Walking': 3.8,
    'Swimming': 8.0,
  };
  final met = metValues[exerciseType] ?? 5.0;
  return (met * 3.5 * weightKg / 200) * durationMinutes;
}
