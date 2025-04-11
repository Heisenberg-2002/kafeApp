import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kafe/screens/concours_page.dart';

class AssemblagePage extends StatefulWidget {
  const AssemblagePage({
    super.key,
    required this.grainsDisponibles,
  });

  final List<Map<String, dynamic>> grainsDisponibles;

  @override
  State<AssemblagePage> createState() => _AssemblagePageState();
}

class _AssemblagePageState extends State<AssemblagePage> {
  final Map<String, int> selectedQuantities = {};
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("Utilisateur non connecté.")),
      );
    }

    final grains = widget.grainsDisponibles;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Créer un Assemblage"),
        backgroundColor: Colors.brown.shade400,
      ),
      backgroundColor: const Color(0xFFFFFDE7),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: grains.length,
                itemBuilder: (context, index) {
                  final kafeId = grains[index]['kafe_id'];
                  final quantite = grains[index]['quantite'];

                  return Card(
                    child: ListTile(
                      title: FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('kafes')
                            .doc(kafeId)
                            .get(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData ||
                              !snapshot.data!.exists ||
                              snapshot.connectionState ==
                                  ConnectionState.waiting) {
                            return const Text("Chargement du nom...");
                          }
                          final nom = snapshot.data!.get('nom') ?? 'Inconnu';
                          return Text("Kafé : $nom");
                        },
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Quantité disponible : $quantite g"),
                          Row(
                            children: [
                              const Text("Utiliser : "),
                              Expanded(
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    final parsed = int.tryParse(value) ?? 0;
                                    setState(() {
                                      selectedQuantities[kafeId] = parsed;
                                    });
                                  },
                                  decoration: const InputDecoration(
                                    hintText: 'Quantité (en g)',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _validerAssemblage,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text("Créer l'assemblage"),
            ),
          ],
        ),
      ),
    );
  }

  void _validerAssemblage() async {
    final total = selectedQuantities.values.fold(0, (a, b) => a + b);
    if (total < 1000) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Il faut au moins 1kg pour créer un assemblage."),
        ),
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final stockRef = FirebaseFirestore.instance
        .collection('joueurs')
        .doc(user.uid)
        .collection('stocks_fruit')
        .doc('global');

    final kafesRef = FirebaseFirestore.instance.collection('kafes');
    final sechageRef = FirebaseFirestore.instance
        .collection('joueurs')
        .doc(user.uid)
        .collection('sechage');

    final stockSnapshot = await stockRef.get();
    if (!stockSnapshot.exists) return;

    final stockData = stockSnapshot.data() as Map<String, dynamic>;

    int totalGout = 0;
    int totalAmertume = 0;
    int totalTeneur = 0;
    int totalOdorat = 0;

    for (final entry in selectedQuantities.entries) {
      final kafeId = entry.key;
      final quantiteUtilisee = entry.value;

      final doc = await kafesRef.doc(kafeId).get();
      if (!doc.exists) continue;

      final data = doc.data() as Map<String, dynamic>;

      final gout = (data['gout'] as num).toInt();
      final amertume = (data['amertume'] as num).toInt();
      final teneur = (data['teneur'] as num).toInt();
      final odorat = (data['odorat'] as num).toInt();

      totalGout += gout * quantiteUtilisee;
      totalAmertume += amertume * quantiteUtilisee;
      totalTeneur += teneur * quantiteUtilisee;
      totalOdorat += odorat * quantiteUtilisee;

      final stockActuel = stockData[kafeId] ?? 0;
      final nouveauStock = stockActuel - quantiteUtilisee;
      stockData[kafeId] = nouveauStock < 0 ? 0 : nouveauStock;

      // Mise à jour de la collection 'sechage' si quantité = 0, supprimer l'élément
      if (nouveauStock == 0) {
        await sechageRef
            .doc(kafeId)
            .delete(); // Supprimer le kafe de 'sechage' si la quantité est 0
      }
    }

    await stockRef.set(stockData);

    final assemblageRef = FirebaseFirestore.instance
        .collection('joueurs')
        .doc(user.uid)
        .collection('assemblages')
        .doc();

    await assemblageRef.set({
      'quantite_totale': total,
      'gout': (totalGout / total).round(),
      'amertume': (totalAmertume / total).round(),
      'teneur': (totalTeneur / total).round(),
      'odorat': (totalOdorat / total).round(),
      'date': FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Assemblage enregistré avec succès !")),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const ConcoursPage()),
    );
  }
}
