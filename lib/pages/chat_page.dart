import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fchatapptute/components/my_textfield.dart';
import 'package:fchatapptute/services/auth/auth_service.dart';
import 'package:fchatapptute/services/chat/chat_service.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget{
  final String receiverEmail;
  final String receiverID;



    ChatPage({
      super.key, 
      required this.receiverEmail, 
      required this.receiverID
    });

    final TextEditingController _messageController = TextEditingController();

    final ChatService _chatService = ChatService();
    final AuthService _authService = AuthService();


    void sendMessage() async {
      if (_messageController.text.isNotEmpty) {
        await _chatService.sendMessage(receiverID, _messageController.text);


          // clear text controller
        _messageController.clear();
      } 

    }

      @override
      Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(title: Text(receiverEmail)),
            body: Column(
              children: [
                // display all messages
                  Expanded(
                    child: _buildMessageList(),
                 ), // Expanded
              ],
            ),
        );
      }

      Widget _buildMessageList() {
        String senderID = _authService.getCurrentUser()!.uid;
        return StreamBuilder(
          stream: _chatService.getMessages(receiverID, senderID),
          builder: (context, shapshot) {
            if (shapshot.hasError) {
              return const Text("Error");
            }

            if (shapshot.connectionState == ConnectionState.waiting){
              return const Text("Loading..");
            }

            return ListView(
                children:
                   shapshot.data!.docs.map((doc) => _builMessageItem(doc)).toList(),
            );
          },
        );  
      }

      Widget _builMessageItem(DocumentSnapshot doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        return Text(data["message"]);
      }
            
      Widget _builUserInput(){
        return Row(
          children: [

            Expanded(
              child:MyTextField(
                controller: _messageController,
                hintText: "Type a message",
                obscureText: false,
              ),
           ),

            IconButton(
              onPressed: sendMessage,
              icon: const Icon(Icons.arrow_upward),

            ),

          ],

        );

    }
  }