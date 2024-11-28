import 'package:fchatapptute/components/my_drawer.dart';
import 'package:fchatapptute/components/user_tile.dart';
import 'package:fchatapptute/pages/chat_page.dart';
import 'package:fchatapptute/services/auth/auth_service.dart';
import 'package:fchatapptute/services/chat/chat_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget{
     HomePage ({super.key});

    //chat & auth service
    final ChatService _chatService = ChatService();
    final AuthService _authService = AuthService();



  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        
        ),
        drawer: const MyDrawer(),
        body: _builduserList(),
    );
  }
    Widget _builduserList() {
      return StreamBuilder(
        stream: _chatService.getUsersStream(),
        builder: (context, snapshot) {
          // error 
            if (snapshot.hasError){
              return const Text("Error");
            }


          // loading..
             if (snapshot.connectionState == ConnectionState.waiting){
              return const Text("Loading..");
            }


          // return list view
            return ListView(
              children: snapshot.data!.map<Widget>((userData) => _buildUserListItem(userData, context))
              .toList(),
            );
        },
      );
    }
      Widget _buildUserListItem(
          Map<String, dynamic> userData, BuildContext context){

            if (userData["email"] != _authService.getCurrentUser()!.email){
                return UserTile (
              text: userData["email"],
              onTap: () {

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatPage(
                      receiverEmail: userData["email"],
                    ),
                    ),
                );
              },

            );
            } else {
              return Container();
            }

          }
    }

