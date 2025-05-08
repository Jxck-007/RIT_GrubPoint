import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ChatService {
  static String? _userName;
  static List<Map<String, String>> messages = [];
  static bool _isInitialized = false;

  // Singleton pattern
  static final ChatService _instance = ChatService._internal();

  factory ChatService() => _instance;

  ChatService._internal();

  late final GenerativeModel _model;
  late final ChatSession _chat;

  bool get isApiKeyConfigured => _isInitialized;

  Future<void> initialize() async {
    if (_isInitialized) return;

    final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
    if (apiKey.isEmpty) {
      throw Exception('GEMINI_API_KEY not found in .env file');
    }

    _model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: apiKey,
    );
    _chat = _model.startChat();
    _isInitialized = true;
  }

  String getApiKeyWarning() {
    return 'Warning: Chat feature is not configured. Please check your Google Generative AI credentials.';
  }
  
  // Update user name (call this when user name changes)
  static Future<void> updateUserName() async {
    final prefs = await SharedPreferences.getInstance();
    _userName = prefs.getString('user_name') ?? 'User';
  }

  // Get a response for the chat
  Future<String> getResponse(String message) async {
    if (!_isInitialized) {
      await initialize();
    }
    
    try {
      return await sendMessage(message);
    } catch (e) {
      return 'Sorry, I encountered an error. Please try again.';
    }
  }

  static void addMessage(Map<String, String> message) {
    messages.add(message);
  }

  Future<String> sendMessage(String message) async {
    try {
      final response = await _chat.sendMessage(
        Content.text(message),
      );
      return response.text ?? 'Sorry, I could not process your request.';
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }

  void resetChat() {
    _chat = _model.startChat();
  }
} 