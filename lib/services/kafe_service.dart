import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/kafe_model.dart';

class KafeService {
  static Future<List<Kafe>> fetchKafesFromFirestore() async {
    final snapshot = await FirebaseFirestore.instance.collection('kafes').get();
    return snapshot.docs
        .map((doc) => Kafe.fromMap(doc.id, doc.data()))
        .toList();
  }

  static Future<DocumentSnapshot> getKafeById(String id) {
    return FirebaseFirestore.instance.collection('kafes').doc(id).get();
  }

  static Stream<List<Kafe>> watchKafes() {
    return FirebaseFirestore.instance.collection('kafes').snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => Kafe.fromMap(doc.id, doc.data()))
              .toList(),
        );
  }

  static Future<void> seedKafes(List<Kafe> kafes) async {
    for (final kafe in kafes) {
      await FirebaseFirestore.instance
          .collection('kafes')
          .doc(kafe.id)
          .set(kafe.toMap());
    }
  }
}
