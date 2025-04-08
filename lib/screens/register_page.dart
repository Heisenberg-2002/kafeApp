import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  void _register() async {
    if (_firstNameController.text.isEmpty || _lastNameController.text.isEmpty || 
        _emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez remplir tous les champs"))
      );
      return;
    }

    final user = await _authService.register(
      _emailController.text,
      _passwordController.text,
      _firstNameController.text,
      _lastNameController.text
    );
    
    if (user != null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Compte créé !")));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Erreur à l'inscription")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F8DC),
        title: const Text('Inscription'),
        centerTitle: true,
      ),

      backgroundColor: const Color(0xFFF8F8DC),
      
      body: Padding(
        padding: const EdgeInsets.all(32.0),
          
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          
          
          children: [

           
            const Image(image: AssetImage('assets/images/logo.png'), height: 80),
            
            const SizedBox(height: 24),
            TextField(
              controller: _firstNameController,
              decoration: const InputDecoration(
                labelText: "Prénom",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _lastNameController,
              decoration: const InputDecoration(
                labelText: "Nom",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: "Mot de passe",
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _register,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero, // rectangulaire
                  ),
              ),
              child: const Text("Inscription"),
            ),
          ],
        ),
      ),
    );
  }
}
