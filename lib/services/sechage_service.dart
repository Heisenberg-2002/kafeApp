import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/kafe_model.dart';
import 'kafe_service.dart';

class SechageService {
  static Future<void> recolterEtEnvoyerAuSechage({
    required User? user,
    required String champId,
    required String planId,
    required String kafeId,
  }) async {
    if (user == null || kafeId.isEmpty) return;

    final doc = await KafeService.getKafeById(kafeId);
    if (!doc.exists) return;

    final data = doc.data() as Map<String, dynamic>;
    final kafe = Kafe.fromMap(doc.id, data);

    final int poidsAvant = kafe.rendementFruit;
    final int quantiteFinale = (poidsAvant * 0.9542).round();

    final sechageRef = FirebaseFirestore.instance
        .collection('joueurs')
        .doc(user.uid)
        .collection('sechage')
        .doc();

    final planRef = FirebaseFirestore.instance
        .collection('joueurs')
        .doc(user.uid)
        .collection('champs')
        .doc(champId)
        .collection('plans')
        .doc(planId);

    await sechageRef.set({
      'kafe_id': kafe.id,
      'kafe_nom': kafe.nom, // ✅ Ajout ici
      'quantite': quantiteFinale,
      'champ_id': champId,
      'plan_id': planId,
      'statut': 'en attente',
      'date_recolte': FieldValue.serverTimestamp(),
    });

    await planRef.set({
      'statut': 'Vide',
      'id_kafe': null,
      'date_plantation': null,
      'rendement_effectif': 0,
    }, SetOptions(merge: true));
  }
}
