import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void login() {
    // 🔐 Implémentation Firebase Auth à mettre ici
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    print("Tentative de login avec $email / $password");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7E5),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),

             // 🔙 Bouton retour
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.brown),
              onPressed: () => Navigator.pop(context),
            ),
            const SizedBox(height: 20),

            // ☕ Logo
            Center(
              child: Column(
                children: [
                  Image.asset('assets/iamges/logo.png', height: 100), // Adapter le chemin
                  const SizedBox(height: 30),
                ],
              ),
            ),

            // ✉️ Email
            const Text("Email"),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(hintText: 'Votre email'),
            ),
            const SizedBox(height: 10),

            // 🔐 Mot de passe
            const Text("Mot de passe*"),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(hintText: 'Choisissez un mot de passe'),
            ),
           
            const SizedBox(height: 20),

            // 🚀 Bouton Connexion
            Center(
              child: ElevatedButton(
                onPressed: login,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
                child: const Text("Connexion"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
