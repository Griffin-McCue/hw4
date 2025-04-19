import 'package:flutter/material.dart';
import 'chat_screen.dart';
import '../widgets/drawer_widget.dart';

class HomeScreen extends StatelessWidget {
  final List<Map<String, dynamic>> boards = [
    {'name': 'Tech Talk', 'icon': Icons.computer},
    {'name': 'Random', 'icon': Icons.casino},
    {'name': 'Help Desk', 'icon': Icons.help_outline},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Message Boards")),
      drawer: DrawerWidget(),
      body: ListView.builder(
        itemCount: boards.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(boards[index]['icon']),
            title: Text(boards[index]['name']),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatScreen(boardName: boards[index]['name']),
                ),
              );
            },
          );
        },
      ),
    );
  }
}