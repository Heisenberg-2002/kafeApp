import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ConcoursPage extends StatelessWidget {
  const ConcoursPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("Utilisateur non connecté.")),
      );
    }

    final assemblagesRef = FirebaseFirestore.instance
        .collection('joueurs')
        .doc(user.uid)
        .collection('assemblages')
        .orderBy('date', descending: true);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Concours CMTM"),
        backgroundColor: Colors.brown.shade400,
      ),
      backgroundColor: const Color(0xFFFFFDE7),
      body: StreamBuilder<QuerySnapshot>(
        stream: assemblagesRef.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Aucun assemblage créé."));
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>;
              final quantite = data['quantite_totale'] ?? 0;
              final gout = data['gout'] ?? 0;
              final amertume = data['amertume'] ?? 0;
              final teneur = data['teneur'] ?? 0;
              final odorat = data['odorat'] ?? 0;
              final date = (data['date'] as Timestamp?)?.toDate();
              final dejaSoumis = data['soumis'] == true;

              return Card(
                margin: const EdgeInsets.all(12),
                child: ListTile(
                  title: Text(
                      "Assemblage du ${date?.toLocal().toString().split('.').first ?? 'inconnu'}"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Quantité : $quantite g"),
                      Text(
                          "Goût : $gout | Amertume : $amertume | Teneur : $teneur | Odorat : $odorat"),
                      const SizedBox(height: 8),
                      if (quantite >= 1000 && !dejaSoumis)
                        ElevatedButton(
                          onPressed: () => _soumettreAssemblage(
                              context, user.uid, doc.id, data),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text("Soumettre au concours"),
                        )
                      else if (dejaSoumis)
                        const Text(
                          "Déjà soumis au concours.",
                          style: TextStyle(color: Colors.green),
                        )
                      else
                        const Text(
                          "Assemblage trop léger pour le concours.",
                          style: TextStyle(color: Colors.redAccent),
                        ),
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

  Future<void> _soumettreAssemblage(BuildContext context, String userId,
      String assemblageId, Map<String, dynamic> assemblage) async {
    final concoursRef = FirebaseFirestore.instance
        .collection('joueurs')
        .doc(userId)
        .collection('concours')
        .doc();

    final assemblageRef = FirebaseFirestore.instance
        .collection('joueurs')
        .doc(userId)
        .collection('assemblages')
        .doc(assemblageId);

    final userRef =
        FirebaseFirestore.instance.collection('joueurs').doc(userId);
    await userRef.update({
      'deevee': FieldValue.increment(5),
    });

    await concoursRef.set({
      ...assemblage,
      'soumis_le': FieldValue.serverTimestamp(),
    });

    await assemblageRef.update({'soumis': true});

    await assemblageRef.delete();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text("Assemblage soumis avec succès et 5 Deevee ajoutés !")),
    );
  }
}
