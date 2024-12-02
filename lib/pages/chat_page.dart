import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fchatapptute/components/chat_bubble.dart';
import 'package:fchatapptute/components/my_textfield.dart';
import 'package:fchatapptute/services/auth/auth_service.dart';
import 'package:fchatapptute/services/chat/chat_service.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;

  ChatPage({
    super.key,
    required this.receiverEmail,
    required this.receiverID,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();

  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

    FocusNode myFocusNode = FocusNode();

    @override
    void initState() {
      super.initState();

      myFocusNode.addListener(() {
        if (myFocusNode.hasFocus) {
           Future.delayed(const Duration(milliseconds: 500),
            () => scrollDown(),

           );
        
        }

      });

      Future.delayed(
        const Duration(
          milliseconds: 500),
          () => scrollDown(),
        );

    }

    @override
 void dispose() {
  myFocusNode.dispose();
  super.dispose();

 }
   
   final ScrollController _scrollController = ScrollController();
   void scrollDown(){
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
      
      );

   }

  



  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {

        await _chatService.sendMessage(widget.receiverID, _messageController.text);

        // Clear text controller
        _messageController.clear();

    }
        scrollDown();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
        title: Text(widget.receiverEmail),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Display all messages
          Expanded(
            child: _buildMessageList(),
          ), // Expanded

          // User input
          _buildUserInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    String senderID = _authService.getCurrentUser()!.uid;

    return StreamBuilder<QuerySnapshot>(
      stream: _chatService.getMessages(widget.receiverID, senderID),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text("Error al cargar mensajes"));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No hay mensajes"));
        }

        // Muestra los mensajes si existen
        return ListView(
          controller: _scrollController,
          children: snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    bool isCurrentUser = data['senderID'] == _authService.getCurrentUser()!.uid;

    var alignment =
      isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;


    return Container(
      alignment: alignment,
      child: Column(
        crossAxisAlignment: 
            isCurrentUser ?  CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              ChatBubble(
                message: data["message"], 
                isCurrentUser: isCurrentUser,
                )
            ],
      ),
    );

  }

  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50.0),
      child: Row(
        children: [
          // Campo de texto para escribir mensajes
          Expanded(
            child: MyTextField(
              controller: _messageController,
              hintText: "Type a message",
              obscureText: false,
              focusNode: myFocusNode,
            ),
          ),

          // Botón para enviar el mensaje
          Container(
            decoration: const BoxDecoration(color: Colors.green,
            shape: BoxShape.circle,
            ),
            margin: const EdgeInsets.only(right: 25),
            child: IconButton(
              onPressed: sendMessage,
              icon: const Icon(
                Icons.arrow_upward,
                color: Colors.white,
                ),
            ),
          ),
        ],
      ),
    );
  }
}
