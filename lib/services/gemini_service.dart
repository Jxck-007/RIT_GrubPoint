import 'package:http/http.dart' as http;
import 'dart:convert';

class GeminiService {
  static const String _apiKey = 'AIzaSyDqOL6vdOxgorPqlN75DXV2f4kOjpBpWPE';
  static const String _baseUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent';

  static Future<String> getResponse(String prompt) async {
    final url = Uri.parse('$_baseUrl?key=$_apiKey');
    
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": prompt}
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['candidates']?[0]?['content']?['parts']?[0]?['text'] ?? 'No response';
      } else {
        throw Exception('Failed to get response: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error communicating with Gemini API: $e');
    }
  }
} 