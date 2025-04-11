import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kafe/services/sechage_service.dart';
import '../models/kafe_model.dart';
import '../services/kafe_service.dart';
import '../services/pousse_service.dart';

class ChampGestionPage extends StatefulWidget {
  final String champId;

  const ChampGestionPage({Key? key, required this.champId}) : super(key: key);

  @override
  State<ChampGestionPage> createState() => _ChampGestionPageState();
}

class _ChampGestionPageState extends State<ChampGestionPage> {
  User? user;
  List<Kafe> kafes = [];
  Timer? _timer;
  Timestamp? finPousse;
  String statut = 'Vide';
  String kafeId = '';
  int rendement = 0;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    _loadKafes();
    _loadPlan();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => setState(() {}));
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadKafes() async {
    final loaded = await KafeService.fetchKafesFromFirestore();
    setState(() {
      kafes = loaded;
    });
  }

  Future<void> _loadPlan() async {
    if (user == null) return;
    final doc = await FirebaseFirestore.instance
        .collection('joueurs')
        .doc(user!.uid)
        .collection('champs')
        .doc(widget.champId)
        .collection('plans')
        .doc('planActif1')
        .get();

    final data = doc.data();
    if (data != null) {
      setState(() {
        statut = data['statut'] ?? 'Vide';
        finPousse = data['date_plantation'];
        kafeId = data['id_kafe'] ?? '';
        rendement = data['rendement_effectif'] ?? 0;
      });
    }
  }

  Future<void> _planterKafe(Kafe kafe) async {
    await PousseService.lancerPousse(
      champId: widget.champId,
      planId: 'planActif1',
      kafe: kafe,
    );
    await _loadPlan();
  }

  Future<void> _recolter() async {
    await SechageService.recolterEtEnvoyerAuSechage(
      user: user,
      champId: widget.champId,
      planId: 'planActif1',
      kafeId: kafeId,
    );
    await _loadPlan();
  }

  void _showKafeSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Choisissez un type de Kafé'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: kafes.length,
              itemBuilder: (context, index) {
                final kafe = kafes[index];
                return Card(
                  child: ListTile(
                    leading: kafe.avatar.isNotEmpty
                        ? Image.network(kafe.avatar, width: 40)
                        : const Icon(Icons.coffee),
                    title: Text(kafe.nom),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Coût : ${kafe.cout} DV'),
                        Text(
                            'Goût : ${kafe.gout} | Amertume : ${kafe.amertume}'),
                        Text(
                            'Teneur : ${kafe.teneur} | Odorat : ${kafe.odorat}'),
                        Text(
                            'Rendement : ${kafe.rendementFruit}g | Durée : ${kafe.dureePousse} min'),
                      ],
                    ),
                    onTap: () async {
                      Navigator.pop(context);
                      await _planterKafe(kafe);
                    },
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> _updateKafeQuantity(String kafeId, int quantityUsed) async {
    final kafeRef = FirebaseFirestore.instance.collection('kafes').doc(kafeId);
    final kafeSnapshot = await kafeRef.get();

    if (kafeSnapshot.exists) {
      final kafeData = kafeSnapshot.data() as Map<String, dynamic>;
      final currentQuantity = kafeData['quantite'] ?? 0;

      // Update the quantity after usage
      final newQuantity = currentQuantity - quantityUsed;
      if (newQuantity <= 0) {
        // If quantity reaches 0, remove kafe from the list
        await kafeRef.delete();
      } else {
        await kafeRef.update({'quantite': newQuantity});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool pousseEnCours = (statut == 'En cours' &&
        finPousse != null &&
        !PousseService.pousseTerminee(finPousse!));
    final bool pousseFinie = (statut == 'En cours' &&
        finPousse != null &&
        PousseService.pousseTerminee(finPousse!));

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
                  _buildActivePlan(pousseEnCours, pousseFinie),
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

  Widget _buildActivePlan(bool pousseEnCours, bool pousseFinie) {
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
          const SizedBox(height: 12),
          if (pousseEnCours && finPousse != null)
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: null,
                  icon: const Icon(Icons.timer, size: 18),
                  label: const Text('Pousse en cours'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade300,
                    disabledBackgroundColor: Colors.green.shade300,
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  PousseService.afficherTempsRestant(finPousse!),
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ],
            )
          else if (pousseFinie)
            ElevatedButton(
              onPressed: _recolter,
              child: const Text('Récolter'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            )
          else
            ElevatedButton(
              onPressed: _showKafeSelectionDialog,
              child: const Text('Faire pousser'),
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
