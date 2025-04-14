import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../services/gemini_service.dart';

class LawBuddyScreen extends StatefulWidget {
  @override
  _LawBuddyScreenState createState() => _LawBuddyScreenState();
}

class _LawBuddyScreenState extends State<LawBuddyScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  final String _apiKey = 'AIzaSyDE-wZKEI11AWjQ_Y3CEqWja7AfL68kydg';
  final String _endpoint =
      'https://generativelanguage.googleapis.com/v1/models/gemini-1.5-pro-002:generateContent';
  final String _lawyerPrompt =
      "Anda adalah LawBuddy, seorang asisten hukum profesional dari Indonesia. Anda memiliki pengetahuan mendalam tentang hukum Indonesia dan bertugas untuk memberikan informasi hukum yang akurat dan mudah dipahami. Berikan saran dengan bahasa yang formal namun ramah. Selalu ingatkan bahwa ini adalah informasi umum dan untuk kasus spesifik sebaiknya berkonsultasi dengan pengacara. Berikut pertanyaan dari pengguna: ";

  Future<void> _sendMessage() async {
    final userMessage = _controller.text.trim();
    if (userMessage.isEmpty) return;

    setState(() {
      _messages.add({'role': 'user', 'text': userMessage});
      _isLoading = true;
    });
    _controller.clear();

    final response = await GeminiService().sendMessage(userMessage);

    setState(() {
      _messages.add({'role': 'lawbuddy', 'text': response});
      _isLoading = false;
    });
  }

  Widget _buildMessage(Map<String, String> message) {
    final isUser = message['role'] == 'user';
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(14),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        decoration: BoxDecoration(
          color: isUser ? Colors.blue[100] : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(message['text']!, style: TextStyle(fontSize: 16)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LawBuddy Chat'),
        backgroundColor: const Color.fromARGB(255, 187, 190, 191),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(top: 12),
              itemCount: _messages.length,
              itemBuilder: (context, index) => _buildMessage(_messages[index]),
            ),
          ),
          if (_isLoading)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            color: Colors.grey[100],
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _sendMessage(),
                    decoration: InputDecoration(
                      hintText: 'Ketik pertanyaan hukum...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                  color: const Color.fromARGB(255, 113, 146, 162),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
