import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // Instancia de FirebaseAuth & auth
  final FirebaseAuth _auth = FirebaseAuth.instance;
   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

   // get current user
   User? getCurrentUser() {
    return _auth.currentUser;

   }

  /// Método para iniciar sesión con email y contraseña
  Future<UserCredential> signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // save user info if it doesn't already exist
      _firestore.collection("Users").doc(userCredential.user!.uid).set(
        {
          'uid': userCredential.user!.uid,
          'email': email,
        },
        );


      
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }
  // sign up
  Future<UserCredential> signUpWithEmailAndPassword(String email, password) async{
    try {
      // create user
      UserCredential userCredencial = 
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
       
      // save user info in a separate doc
      _firestore.collection("Users").doc(userCredencial.user!.uid).set(
        {
          'uid': userCredencial.user!.uid,
          'email': email,
        },
        );

        
      return userCredencial;
    } on FirebaseAuthException catch (e) {
        throw Exception(e.code);
    }
  }
  
  /// Método para cerrar sesión
  Future<void> signOut() async {
    await _auth.signOut();
  }


}
