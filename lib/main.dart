import 'package:flutter/material.dart';
import 'conversation/views/messages_list_page.dart'; // ✅ mets le bon chemin vers ta page



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'YansNet',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const MessagesListPage(), // 🏁 ta page principale
    );
  }
}
