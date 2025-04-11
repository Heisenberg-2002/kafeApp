import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/kafe_model.dart';

class SechageService {
  static Future<void> recolterEtEnvoyerAuSechage({
    required User? user,
    required String champId,
    required String planId,
    required Kafe kafe,
  }) async {
    if (user == null || kafe.id.isEmpty) return;

    final planRef = FirebaseFirestore.instance
        .collection('joueurs')
        .doc(user.uid)
        .collection('champs')
        .doc(champId)
        .collection('plans')
        .doc(planId);

    final sechageRef = FirebaseFirestore.instance
        .collection('joueurs')
        .doc(user.uid)
        .collection('sechage')
        .doc();

    final quantiteFinale = (kafe.rendementFruit.toDouble() * 0.9542).round();

    await sechageRef.set({
      'kafe_id': kafe.id,
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
