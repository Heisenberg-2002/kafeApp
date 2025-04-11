import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/kafe_model.dart';

class KafeService {
  /// Récupère tous les kafes une seule fois
  static Future<List<Kafe>> fetchKafesFromFirestore() async {
    final snapshot = await FirebaseFirestore.instance.collection('kafes').get();
    return snapshot.docs
        .map((doc) => Kafe.fromMap(doc.id, doc.data()))
        .toList();
  }

  /// Récupère un seul kafe par ID
  static Future<DocumentSnapshot> getKafeById(String id) {
    return FirebaseFirestore.instance.collection('kafes').doc(id).get();
  }

  /// Récupère tous les kafes en temps réel
  static Stream<List<Kafe>> watchKafes() {
    return FirebaseFirestore.instance.collection('kafes').snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => Kafe.fromMap(doc.id, doc.data()))
              .toList(),
        );
  }

  /// Envoie une liste de kafes dans Firestore (utile pour le seed)
  static Future<void> seedKafes(List<Kafe> kafes) async {
    for (final kafe in kafes) {
      await FirebaseFirestore.instance
          .collection('kafes')
          .doc(kafe.id)
          .set(kafe.toMap());
    }
  }
}
