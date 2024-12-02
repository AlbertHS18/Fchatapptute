import 'package:fchatapptute/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatBubble extends StatelessWidget {
    final String message;
    final bool isCurrentUser;

    const ChatBubble({
      super.key,
      required this.message,
      required this.isCurrentUser,
    });

      @override
          Widget build(BuildContext context) {
            bool isDartMode = 
            Provider.of<ThemeProvider>(context, listen: false).isDartMode;

            return Container(
              decoration: BoxDecoration(
                color: isCurrentUser 
                ? (isDartMode ? Colors.green.shade600: Colors.green.shade500)
                : (isDartMode ? Colors.grey.shade800: Colors.grey.shade200),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(vertical: 2.5, horizontal: 25),
              child: Text(
                message,
                style: TextStyle(
                  color:isCurrentUser 
                  ?  Colors.white 
                  : (isDartMode ? Colors.white : Colors.black)),
                ),
            );
        }
      }