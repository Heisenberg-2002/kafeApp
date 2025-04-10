import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class ChampGestionPage extends StatefulWidget {
  final String champId;

  const ChampGestionPage({Key? key, required this.champId}) : super(key: key);

  @override
  State<ChampGestionPage> createState() => _ChampGestionPageState();
}

class _ChampGestionPageState extends State<ChampGestionPage> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDE7),
      appBar: AppBar(
        title: const Text('Gestion du Champ'),
        backgroundColor: Colors.brown.shade400,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Votre champ contient 1 plan actif et 3 plans à débloquer.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildActivePlan(),
                  _buildLockedPlan(),
                  _buildLockedPlan(),
                  _buildLockedPlan(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivePlan() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade700, width: 2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.local_florist, size: 48, color: Colors.green),
          const SizedBox(height: 12),
          const Text('Plan Actif',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Gérer'),
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700),
          ),
        ],
      ),
    );
  }

  Widget _buildLockedPlan() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.lock_outline, size: 48, color: Colors.grey),
          const SizedBox(height: 12),
          const Text('Plan verrouillé', style: TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {},
            child: const Icon(Icons.add),
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown.shade400),
          ),
        ],
      ),
    );
  }
}
