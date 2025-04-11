import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kafe/screens/concours_page.dart';
import '../services/kafe_service.dart';

class SechagePage extends StatefulWidget {
  const SechagePage({super.key});

  @override
  _SechagePageState createState() => _SechagePageState();
}

class _SechagePageState extends State<SechagePage> {
  final user = FirebaseAuth.instance.currentUser;
  List<Map<String, dynamic>> kafes = [];
  List<String> selectedKafes = [];

  @override
  void initState() {
    super.initState();
    _loadKafes();
  }

  Future<void> _loadKafes() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('joueurs')
        .doc(user!.uid)
        .collection('sechage')
        .orderBy('date_recolte', descending: true)
        .get();

    setState(() {
      kafes = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'kafe_id': data['kafe_id'],
          'quantite': data['quantite'] ?? 0,
          'statut': data['statut'],
        };
      }).toList();
    });
  }

  Future<void> _validerAssemblage() async {
    for (final kafeUniqueId in selectedKafes) {
      final kafe = kafes.firstWhere((k) => k['id'] == kafeUniqueId);
      final quantiteUtilisee = kafe['quantite'];
      final kafeId = kafe['kafe_id'];

      // Supprimer ou mettre à jour la quantité
      final docRef = FirebaseFirestore.instance
          .collection('joueurs')
          .doc(user!.uid)
          .collection('sechage')
          .doc(kafeUniqueId);

      if (quantiteUtilisee <= 0) {
        await docRef.delete();
      } else {
        await docRef.update({'quantite': 0}); // quantité totalement utilisée
      }

      // Récupérer le nom du kafé via KafeService
      final kafeDoc = await KafeService.getKafeById(kafeId);
      final data = kafeDoc.data() as Map<String, dynamic>?;
      final nomKafe = data?['nom'] ?? 'Inconnu';

      // Soumission dans concours
      final concoursRef = FirebaseFirestore.instance
          .collection('joueurs')
          .doc(user!.uid)
          .collection('concours')
          .doc();

      await concoursRef.set({
        'kafe_id': kafeId,
        'nom_kafe': nomKafe,
        'quantite': quantiteUtilisee,
        'soumis_le': FieldValue.serverTimestamp(),
      });
    }

    setState(() {
      selectedKafes.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text("Assemblage soumis au concours avec succès !")),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const ConcoursPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Séchage en cours"),
        backgroundColor: Colors.brown.shade400,
      ),
      backgroundColor: const Color(0xFFFFFDE7),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: kafes.length,
              itemBuilder: (context, index) {
                final kafe = kafes[index];
                final kafeId = kafe['kafe_id'];
                final quantite = kafe['quantite'];
                final statut = kafe['statut'];
                final kafeUniqueId = kafe['id'];

                return Card(
                  margin: const EdgeInsets.all(12),
                  child: ListTile(
                    leading: const Icon(Icons.local_cafe, color: Colors.brown),
                    title: FutureBuilder<DocumentSnapshot>(
                      future: KafeService.getKafeById(kafeId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Text("Chargement du nom du kafé...");
                        }
                        if (!snapshot.hasData || !snapshot.data!.exists) {
                          return Text("Kafé inconnu (ID : $kafeId)");
                        }
                        final nomKafe = snapshot.data?.get('nom') ?? 'Inconnu';
                        return Text("Kafé : $nomKafe");
                      },
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Quantité séchée : $quantite g"),
                        Text("Statut : $statut"),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        selectedKafes.contains(kafeUniqueId)
                            ? Icons.check_box
                            : Icons.check_box_outline_blank,
                        color: Colors.brown,
                      ),
                      onPressed: () {
                        setState(() {
                          if (selectedKafes.contains(kafeUniqueId)) {
                            selectedKafes.remove(kafeUniqueId);
                          } else {
                            selectedKafes.add(kafeUniqueId);
                          }
                        });
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton(
              onPressed: selectedKafes.isEmpty ? null : _validerAssemblage,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text("Valider les assemblages"),
            ),
          ),
        ],
      ),
    );
  }
}
