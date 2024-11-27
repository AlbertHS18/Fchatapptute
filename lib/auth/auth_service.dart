import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // Instancia de FirebaseAuth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Método para iniciar sesión con email y contraseña
  Future<UserCredential> signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }


  /// Método para cerrar sesión
  Future<void> signOut() async {
    await _auth.signOut();
  }


}
