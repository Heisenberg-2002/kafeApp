import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'dashboard_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  void login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    final user = await _authService.login(email, password);

    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erreur de connexion")),
      );
    }
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
                  Image.asset('assets/images/logo.png',
                      height: 100), // Adapter le chemin
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
              decoration:
                  const InputDecoration(hintText: 'Choisissez un mot de passe'),
            ),

            const SizedBox(height: 20),

            // 🚀 Bouton Connexion
            Center(
              child: ElevatedButton(
                onPressed: login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text("Connexion"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
