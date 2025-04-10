import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChampPage extends StatelessWidget {
  const ChampPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final userDoc = FirebaseFirestore.instance.collection('users').doc(user?.uid);
    final champsCollection = FirebaseFirestore.instance.collection('champs').where('userId', isEqualTo: user?.uid);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Champs'),
        backgroundColor: const Color(0xFFF8F8DC),
      ),
      backgroundColor: const Color(0xFFF8F8DC),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Vos Champs',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    title: const Text('Champ Nord'),
                    subtitle: const Text('Statut: Inactif'),
                    trailing: ElevatedButton(
                      onPressed: () {},
                      child: const Text('Activer'),
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Logique pour acheter un nouveau champ
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
              child: const Text('Acheter un champ'),
            ),
          ],
        ),
      ),
    );
  }
} 