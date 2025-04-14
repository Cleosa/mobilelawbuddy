import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  final String _apiKey = 'AIzaSyDE-wZKEI11AWjQ_Y3CEqWja7AfL68kydg';
  final String _endpoint =
      'https://generativelanguage.googleapis.com/v1/models/gemini-1.5-pro-002:generateContent';
  final String _lawyerPrompt =
      "Anda adalah LawBuddy, seorang asisten hukum profesional dari Indonesia. "
      "Anda memiliki pengetahuan mendalam tentang hukum Indonesia dan bertugas untuk memberikan informasi hukum "
      "yang akurat dan mudah dipahami. Berikan saran dengan bahasa yang formal namun ramah. "
      "Selalu ingatkan bahwa ini adalah informasi umum dan untuk kasus spesifik sebaiknya berkonsultasi dengan pengacara. "
      "Berikut pertanyaan dari pengguna: ";

  Future<String> sendMessage(String message) async {
    final uri = Uri.parse('$_endpoint?key=$_apiKey');

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "contents": [
          {
            "parts": [
              {"text": _lawyerPrompt + message},
            ],
          },
        ],
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final result = data['candidates']?[0]?['content']?['parts']?[0]?['text'];
      return result ?? 'Tidak ada respons dari LawBuddy.';
    } else {
      print('ERROR: ${response.statusCode} - ${response.body}');
      return 'Terjadi kesalahan saat menghubungi LawBuddy.';
    }
  }
}
