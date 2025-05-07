import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dialogflow_service.dart';

class ChatService {
  static String? _userName;
  static List<Map<String, String>> messages = [];
  static bool _isInitialized = false;

  // Singleton pattern
  static final ChatService _instance = ChatService._internal();

  factory ChatService() {
    return _instance;
  }

  ChatService._internal() {
    _initialize();
  }

  static Future<void> _initialize() async {
    if (_isInitialized) return;
    
    await DialogflowService.initialize();
    _isInitialized = true;
  }

  static bool get isApiKeyConfigured => _isInitialized;

  static String getApiKeyWarning() {
    return 'Warning: Chat feature is not configured. Please check your Dialogflow credentials.';
  }
  
  // Update user name (call this when user name changes)
  static Future<void> updateUserName() async {
    final prefs = await SharedPreferences.getInstance();
    _userName = prefs.getString('user_name') ?? 'User';
  }

  // Get a response for the chat
  static Future<String> getResponse(String message) async {
    if (!_isInitialized) {
      await _initialize();
    }
    
    try {
      return await DialogflowService.getResponse(message);
    } catch (e) {
      return 'Sorry, I encountered an error. Please try again.';
    }
  }

  static void addMessage(Map<String, String> message) {
    messages.add(message);
  }
} 