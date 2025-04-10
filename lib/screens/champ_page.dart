import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'champs_gestion_page.dart';

class ChampsPage extends StatefulWidget {
  const ChampsPage({Key? key}) : super(key: key);

  @override
  State<ChampsPage> createState() => _ChampsPageState();
}

class _ChampsPageState extends State<ChampsPage> {
  final user = FirebaseAuth.instance.currentUser;
  final TextEditingController _nomChampController = TextEditingController();
  String? _selectedSpecificite;

  Future<List<Map<String, dynamic>>> _loadChamps() async {
    final champsSnapshot = await FirebaseFirestore.instance
        .collection('joueurs')
        .doc(user!.uid)
        .collection('champs')
        .get();

    return champsSnapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return data;
    }).toList();
  }

  void _goToChampGestion(String champId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChampGestionPage(champId: champId),
      ),
    );
  }

  void _showAcheterChampDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Acheter un nouveau champ'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nomChampController,
                decoration: const InputDecoration(labelText: 'Nom du champ'),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedSpecificite,
                decoration: const InputDecoration(labelText: 'Spécialité'),
                items: [
                  DropdownMenuItem(
                      value: 'rendement_x2', child: Text('Rendement x2')),
                  DropdownMenuItem(
                      value: 'temps_div_2', child: Text('Temps ÷2')),
                  DropdownMenuItem(value: 'neutre', child: Text('Neutre')),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedSpecificite = value;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: _acheterChamp,
              child: const Text('Confirmer'),
            ),
          ],
        );
      },
    );
  }

  void _acheterChamp() async {
    final joueurRef =
        FirebaseFirestore.instance.collection('joueurs').doc(user!.uid);
    final joueurDoc = await joueurRef.get();
    final currentDeeVee = joueurDoc['deevee'] ?? 0;
    final nomChamp = _nomChampController.text.trim();
    final specificite = _selectedSpecificite;

    if (nomChamp.isEmpty || specificite == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs.')),
      );
      return;
    }

    if (currentDeeVee >= 15) {
      await joueurRef.update({
        'deevee': currentDeeVee - 15,
      });

      await joueurRef.collection('champs').add({
        'nom': nomChamp,
        'specificite': specificite,
        'createdAt': FieldValue.serverTimestamp(),
      });

      Navigator.of(context).pop();
      _nomChampController.clear();
      setState(() {
        _selectedSpecificite = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Champ acheté avec succès !')),
      );

      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Pas assez de DeeVee pour acheter un champ.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDE7),
      appBar: AppBar(
        title: const Text('Page Gestion des Champs'),
        backgroundColor: Colors.brown.shade400,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _loadChamps(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Aucun champ trouvé.'));
          }

          final champs = snapshot.data!;

          return ListView.builder(
            itemCount: champs.length,
            itemBuilder: (context, index) {
              final champ = champs[index];
              return Card(
                color: Colors.grey[200],
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: ListTile(
                  title: Text(champ['nom'] ?? 'Sans nom'),
                  subtitle:
                      Text('Spécialité : ${champ['specificite'] ?? 'N/A'}'),
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown.shade400,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () => _goToChampGestion(champ['id']),
                    child: const Text('Gérer'),
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.brown.shade700,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape:
                const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            foregroundColor: Colors.white,
          ),
          onPressed: _showAcheterChampDialog,
          child: const Text('Acheter un champ'),
        ),
      ),
    );
  }
}
