import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fchatapptute/models/message.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  // Firestore y FirebaseAuth instancias
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Obtener flujo de usuarios
  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _firestore.collection("Users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final user = doc.data();
        return user;
      }).toList();
    });
  }

  // Enviar mensaje
  Future<void> sendMessage(String receiverID, String message) async {
    final User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception("Usuario no autenticado.");
    }

    final String currentUserID = currentUser.uid;
    final String currentUserEmail = currentUser.email!;
    final Timestamp timestamp = Timestamp.now();

    // Crear el nuevo mensaje
    Message newMessage = Message(
      senderID: currentUserID,  // Corrección aquí
      senderEmail: currentUserEmail,
      receiverID: receiverID,
      message: message,
      timestamp: timestamp,
    );

    // Crear el ID del chatroom
    List<String> ids = [currentUserID, receiverID];
    ids.sort();
    String chatRoomID = ids.join('_');

    // Añadir el mensaje a la colección
    try {
      await _firestore
          .collection("chat_rooms")
          .doc(chatRoomID)
          .collection("messages")
          .add(newMessage.toMap());
    } catch (e) {
      throw Exception("Error al enviar mensaje: $e");
    }
  }

  // Obtener mensajes de un chat
  Stream<QuerySnapshot> getMessages(String userID, String otherUserID) {
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');

    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }
}
