import 'dart:io';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class PreviewScreen extends StatelessWidget {
  final String imagePath;

  PreviewScreen({required this.imagePath});

  Future<void> _shareImage() async {
    await Share.shareXFiles(
      [XFile(imagePath)],
      text: 'Check out this photo!',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Preview')),
      body: Column(
        children: [
          Expanded(child: Image.file(File(imagePath))),
          ElevatedButton(
            onPressed: _shareImage,
            child: Text('Share Image'),
          ),
        ],
      ),
    );
  }
}
