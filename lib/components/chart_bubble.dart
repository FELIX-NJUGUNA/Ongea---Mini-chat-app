import 'package:flutter/material.dart';
import 'package:ongea_chat_app/themes/theme_provider.dart';
import 'package:provider/provider.dart';

class ChartBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;
  const ChartBubble(
      {super.key, required this.message, required this.isCurrentUser});

  @override
  Widget build(BuildContext context) {
    // light vs dark mode for the correct bubble color
    bool isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;

    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isCurrentUser
              ? (isDarkMode ? Colors.green.shade600 : Colors.green.shade500)
              : (isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200)),
      padding: const EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(vertical: 2, horizontal: 20),
      child: Text(
        message,
        style: TextStyle(
            color: isCurrentUser
                ? Colors.white
                : (isDarkMode ? Colors.white : Colors.black)),
      ),
    );
  }
}
