import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/kafe_model.dart';

class PousseService {
  static Future<void> lancerPousse({
    required String champId,
    required String planId,
    required Kafe kafe,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    final champRef = FirebaseFirestore.instance
        .collection('joueurs')
        .doc(user!.uid)
        .collection('champs')
        .doc(champId)
        .collection('plans')
        .doc(planId);

    final now = DateTime.now();
    final finPousse = now.add(Duration(minutes: kafe.dureePousse));

    await champRef.set({
      'statut': 'En cours',
      'id_kafe': kafe.id,
      'date_plantation': Timestamp.fromDate(finPousse),
      'rendement_effectif': kafe.rendementFruit.toInt(),
    }, SetOptions(merge: true));
  }

  static bool pousseTerminee(Timestamp finPousse) {
    return finPousse.toDate().isBefore(DateTime.now());
  }

  static String afficherTempsRestant(Timestamp finPousse) {
    final reste = finPousse.toDate().difference(DateTime.now());
    if (reste.isNegative) return 'Terminé';
    final minutes = reste.inMinutes;
    final seconds = reste.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')} restantes';
  }

  static Future<void> recolterEtEnvoyerAuSechage({
    required User? user,
    required String champId,
    required String planId,
    required String kafeId,
    required int rendement,
  }) async {
    if (user == null || kafeId.isEmpty) return;

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

    await sechageRef.set({
      'kafe_id': kafeId,
      'quantite': rendement,
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
