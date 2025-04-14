import 'package:flutter/material.dart';
import 'screens/lawbuddy_screen.dart'; // Tambahkan ini

void main() {
  runApp(CameraApp());
}

class CameraApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LawBuddy',
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      home: LawBuddyScreen(), // Ubah ke halaman chatbot
    );
  }
}
