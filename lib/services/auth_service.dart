import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final User? user = result.user;

      if (user != null) {
        final DocumentSnapshot joueurDoc =
            await _firestore.collection('joueurs').doc(user.uid).get();

        if (joueurDoc.exists) {
          return joueurDoc.data() as Map<String, dynamic>;
        } else {
          print('Document Firestore du joueur non trouvé.');
          return null;
        }
      } else {
        print('Utilisateur null après connexion.');
        return null;
      }
    } catch (e) {
      print('Erreur de connexion: $e');
      return null;
    }
  }

  Future<User?> register(
      String email, String password, String firstName, String lastName) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = result.user;

      if (user != null) {
        await _firestore.collection('joueurs').doc(user.uid).set({
          'nom': lastName,
          'prenom': firstName,
          'email': email,
          'deevee': 100000000,
          'grains_or': 500,
          'avatar':
              'https://cdn-icons-png.flaticon.com/512/147/147144.png', // URL par défaut
        });

        return user;
      } else {
        print('Erreur : utilisateur null après création');
        return null;
      }
    } catch (e) {
      print('Erreur d\'inscription: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Stream<User?> get user => _auth.authStateChanges();
}
