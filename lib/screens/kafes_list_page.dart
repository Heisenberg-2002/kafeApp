import 'package:flutter/material.dart';
import '../services/kafe_service.dart';
import '../models/kafe_model.dart';

class KafesListPage extends StatefulWidget {
  const KafesListPage({super.key});

  @override
  State<KafesListPage> createState() => _KafesListPageState();
}

class _KafesListPageState extends State<KafesListPage> {
  late Future<List<Kafe>> _kafesFuture;

  @override
  void initState() {
    super.initState();
    _kafesFuture = KafeService.fetchKafesFromFirestore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des Kafés'),
        backgroundColor: Colors.brown.shade400,
      ),
      backgroundColor: const Color(0xFFFFFDE7),
      body: FutureBuilder<List<Kafe>>(
        future: _kafesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Aucun Kafé trouvé."));
          }

          final kafes = snapshot.data!;

          return ListView.builder(
            itemCount: kafes.length,
            itemBuilder: (context, index) {
              final kafe = kafes[index];
              final quantiteFinale = (kafe.rendementFruit * 0.9542).round();

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  leading: kafe.avatar.isNotEmpty
                      ? Image.network(kafe.avatar, width: 40)
                      : const Icon(Icons.coffee),
                  title: Text(kafe.nom),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          'Rendement (avant perte) : ${kafe.rendementFruit} g'),
                      Text('Rendement (après séchage) : $quantiteFinale g'),
                      Text('Durée de pousse : ${kafe.dureePousse} min'),
                      Text('Goût : ${kafe.gout} | Amertume : ${kafe.amertume}'),
                      Text('Teneur : ${kafe.teneur} | Odorat : ${kafe.odorat}'),
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
