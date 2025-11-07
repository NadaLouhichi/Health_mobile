import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/home_screen.dart';
import 'screens/exercise_screen.dart';
import 'screens/food_screen.dart';
import 'screens/stats_screen.dart';
import 'services/db_service.dart'; // <- your new cross-platform DBService

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Initialize cross-platform database
  final dbService = DBService();
  await dbService.init();

  // Run the app
  runApp(const FitnessApp());
}

class FitnessApp extends StatefulWidget {
 const FitnessApp({super.key});
  @override
  State<FitnessApp> createState() => _FitnessAppState();
}

class _FitnessAppState extends State<FitnessApp> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    ExerciseScreen(),
    FoodScreen(),
    StatsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Santé & Fitness',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Santé & Fitness"),
          centerTitle: true,
        ),
        body: _screens[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            setState(() => _currentIndex = index);
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: "Exercise"),
            BottomNavigationBarItem(icon: Icon(Icons.restaurant), label: "Food"),
            BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: "Stats"),
          ],
        ),
      ),
    );
  }
}
