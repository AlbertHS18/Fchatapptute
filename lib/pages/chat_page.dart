import 'package:fchatapptute/services/auth/auth_service.dart';
import 'package:fchatapptute/services/chat/chat_service.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget{
  final String receiverEmail;



    ChatPage({
      super.key, 
      required this.receiverEmail, required receiverID,
    });

    final TextEditingController _messageController = TextEditingController();

    final ChatService _chatService = ChatService();
    final AuthService _authService = AuthService();


    void sendMessage() async {
      if (_messageController.text.isNotEmpty) {
        await _chatService.sendMessage(receiverID, _messageController.text);
      

      }

    }
    

      
      @override
      Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(title: Text(receiverEmail)),
      
        );
      }

}