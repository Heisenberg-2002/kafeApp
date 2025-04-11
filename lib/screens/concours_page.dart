import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ConcoursPage extends StatefulWidget {
  const ConcoursPage({super.key});

  @override
  State<ConcoursPage> createState() => _ConcoursPageState();
}

class _ConcoursPageState extends State<ConcoursPage> {
  Duration timeLeft = const Duration();
  Timer? countdownTimer;

  @override
  void initState() {
    super.initState();
    _updateTimeLeft();
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateTimeLeft();
    });
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    super.dispose();
  }

  void _updateTimeLeft() {
    final now = DateTime.now();
    final minutesSinceEpoch = now.millisecondsSinceEpoch ~/ 60000;
    final nextDrawIn = 19 - (minutesSinceEpoch % 19);
    final secondsLeft = 60 - now.second;

    setState(() {
      timeLeft = Duration(minutes: nextDrawIn - 1, seconds: secondsLeft);
    });
  }

  String _getStatus(Map<String, dynamic> data) {
    final Timestamp? submittedAt = data['soumis_le'] as Timestamp?;
    if (submittedAt == null) return 'Résultat en attente';

    final DateTime now = DateTime.now();
    final DateTime submissionTime = submittedAt.toDate();
    final difference = now.difference(submissionTime);

    if (difference.inMinutes < 19) return 'Résultat en attente';

    final hash = data['kafe_id'].hashCode;
    final random = Random(hash);
    final result = random.nextInt(10); // 0 à 9

    if (result == 0) return '🎉 Gagné ! Vous avez reçu 10 Deevee';
    return 'Perdu 😢';
  }

  Color _getStatusColor(String status) {
    if (status.contains("Gagné")) return Colors.green.shade700;
    if (status.contains("Perdu")) return Colors.red.shade300;
    return Colors.orange.shade700;
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("Utilisateur non connecté.")),
      );
    }

    final concoursRef = FirebaseFirestore.instance
        .collection('joueurs')
        .doc(user.uid)
        .collection('concours')
        .orderBy('soumis_le', descending: true);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Concours CMTM"),
        backgroundColor: Colors.brown.shade400,
      ),
      backgroundColor: const Color(0xFFFFFDE7),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.brown.shade200,
            child: Column(
              children: [
                const Text(
                  "⏳ Prochain concours dans :",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  "${timeLeft.inMinutes.remainder(60).toString().padLeft(2, '0')} min ${timeLeft.inSeconds.remainder(60).toString().padLeft(2, '0')} sec",
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: concoursRef.snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                      child: Text("Aucune participation au concours."));
                }

                final docs = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final doc = docs[index];
                    final data = doc.data() as Map<String, dynamic>;
                    final nomKafe = data['nom_kafe'] ?? 'Inconnu';
                    final quantite = data['quantite'] ?? 0;
                    final date = (data['soumis_le'] as Timestamp?)?.toDate();
                    final status = _getStatus(data);

                    return Card(
                      margin: const EdgeInsets.all(12),
                      child: ListTile(
                        leading: const Icon(Icons.emoji_events,
                            color: Colors.orange),
                        title: Text("Kafé : $nomKafe"),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Quantité : $quantite g"),
                            Text(
                                "Soumis le : ${date?.toLocal().toString().split('.').first ?? 'inconnu'}"),
                            const SizedBox(height: 6),
                            Text(
                              status,
                              style: TextStyle(
                                color: _getStatusColor(status),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
