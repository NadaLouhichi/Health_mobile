import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Bienvenue dans votre application Santé & Fitness ',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const Text(
                "Cette application vous aide à suivre vos habitudes de santé et de bien-être :\n\n"
                "• Ajoutez vos entrées quotidiennes (IMC, Calories brulées) 📝\n"
                "• Consultez vos statistiques pour visualiser vos progrès 📊\n"
                "• Explorez des informations nutritionnelles sur vos aliments préférés 🍎\n"
                "•Explorez des exercices à faire depuis votre maison 💪 ",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 30),

              const SizedBox(height: 40),
              const Icon(Icons.favorite, color: Colors.red, size: 40),
              const SizedBox(height: 10),
              const Text(
                'Utilisez le menu en bas pour explorer toutes les fonctionnalités 👇',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
