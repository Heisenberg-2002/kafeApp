import 'package:flutter/material.dart';
import 'login_page.dart';
import 'register_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8DC), // beige clair
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 📌 Logo Coffee Clash
            const Image(
              image: AssetImage('assets/images/logo.png'),
              height: 160,
            ),
            const SizedBox(height: 60),

            // 🔐 Bouton Se connecter
            SizedBox(
              width: 220,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6D4C41), // couleur chocolat
                  foregroundColor: Colors.white, // texte blanc
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero, // rectangulaire
                  ),
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                ),
                child: const Text("Se connecter"),
              ),
            ),

            const SizedBox(height: 20),

            // 📝 Bouton Créer un compte
            SizedBox(
              width: 220,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6D4C41),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterPage()),
                ),
                child: const Text("Créer un compte"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
