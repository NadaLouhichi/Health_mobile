double calculateBMI(double weightKg, double heightCm) {
  final heightM = heightCm / 100;
  return weightKg / (heightM * heightM);
}

double calculateBMR(String gender, double weightKg, double heightCm, int age) {
  if (gender.toLowerCase() == 'male') {
    return 88.36 + (13.4 * weightKg) + (4.8 * heightCm) - (5.7 * age);
  } else {
    return 447.6 + (9.2 * weightKg) + (3.1 * heightCm) - (4.3 * age);
  }
}

double dailyCalories(double bmr, String activityLevel) {
  // Normalize input (e.g. "Active" -> "active")
  final level = activityLevel.toLowerCase().trim();

  switch (level) {
    case 'sedentary': // Little or no exercise
      return bmr * 1.2;
    case 'light': // Light exercise 1–3 days/week
      return bmr * 1.375;
    case 'moderate': // Moderate exercise 3–5 days/week
      return bmr * 1.55;
    case 'active': // Hard exercise 6–7 days/week
      return bmr * 1.725;
    case 'very active': // Very hard exercise & physical job
      return bmr * 1.9;
    default:
      // If no valid selection, assume 'lightly active'
      return bmr * 1.375;
  }
}

double calculateCalories(
  String exerciseType,
  int durationMinutes,
  double weightKg,
) {
  final metValues = {
    'Running': 9.8,
    'Cycling': 7.5,
    'Walking': 3.8,
    'Swimming': 8.0,
  };
  final met = metValues[exerciseType] ?? 5.0;
  return (met * 3.5 * weightKg / 200) * durationMinutes;
}
