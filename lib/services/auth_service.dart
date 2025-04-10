import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Connexion
  Future<User?> login(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      print('Erreur de connexion: $e');
      return null;
    }
  }

  /// Inscription + création du document joueur lié à l'UID Firebase
  Future<User?> register(String email, String password, String firstName, String lastName) async {
    try {
      // Création de l'utilisateur dans Firebase Auth
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = result.user;

      if (user != null) {
        // Création du document joueur dans Firestore
        await _firestore.collection('joueurs').doc(user.uid).set({
          'nom': lastName,
          'prenom': firstName,
          'email': email,
          'deevee': 10,
          'grains_or': 500,
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

  /// Déconnexion
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Écoute en temps réel de l'état de l'utilisateur connecté
  Stream<User?> get user => _auth.authStateChanges();
}
