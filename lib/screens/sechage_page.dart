import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/sechage_service.dart';

class SechagePage extends StatelessWidget {
  const SechagePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("Utilisateur non connecté.")),
      );
    }

    final sechageRef = FirebaseFirestore.instance
        .collection('joueurs')
        .doc(user.uid)
        .collection('sechage')
        .orderBy('date_recolte', descending: true);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Séchage en cours"),
        backgroundColor: Colors.brown.shade400,
      ),
      backgroundColor: const Color(0xFFFFFDE7),
      body: StreamBuilder<QuerySnapshot>(
        stream: sechageRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
                child: Text("Aucune récolte en attente de séchage."));
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>;
              final kafe_nom = data['kafe_nom'] ?? "Inconnu";
              final kafeId = data['kafe_id'] ?? "";
              final quantite = data['quantite'] ?? 0;
              final statut = data['statut'] ?? "en attente";
              final date = (data['date_recolte'] as Timestamp?)?.toDate();

              return Card(
                margin: const EdgeInsets.all(12),
                child: ListTile(
                  leading: const Icon(Icons.local_cafe, color: Colors.brown),
                  title: FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('kafes')
                        .doc(kafeId)
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text("Chargement du nom du kafé...");
                      }
                      if (!snapshot.hasData || !snapshot.data!.exists) {
                        return Text("Kafé inconnu (ID : $kafeId)");
                      }
                      final nomKafe = snapshot.data!.get('nom') ?? 'Inconnu';
                      return Text("Kafé : $kafe_nom");
                    },
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Quantité séchée : $quantite g"),
                      Text("Statut : $statut"),
                      if (date != null) Text("Récolté le : ${date.toLocal()}"),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
