import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GeminiService {
  // Change this to your actual API key in a real application
  // In production, this should be securely stored (e.g., environment variable)
  static const String _apiKey = 'YOUR_GEMINI_API_KEY';
  
  static GenerativeModel? _model;
  static ChatSession? _chatSession;
  static bool _isInitialized = false;
  static String _userName = 'User';

  // Singleton pattern
  static final GeminiService _instance = GeminiService._internal();

  factory GeminiService() {
    return _instance;
  }

  GeminiService._internal();
  
  static bool get isInitialized => _isInitialized;
  
  static Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      // Load user name from shared preferences
      final prefs = await SharedPreferences.getInstance();
      _userName = prefs.getString('user_name') ?? 'User';
      
      // Initialize Gemini model and create chat session
      _model = GenerativeModel(
        model: 'gemini-pro',
        apiKey: _apiKey,
      );
      _chatSession = _model?.startChat();
      _isInitialized = true;
    } catch (e) {
      print('Error initializing Gemini: $e');
      _isInitialized = false;
      rethrow;
    }
  }
  
  // Update user name (call this when user name changes)
  static Future<void> updateUserName() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _userName = prefs.getString('user_name') ?? 'User';
    } catch (e) {
      print('Error updating user name: $e');
    }
  }

  // Send a message to Gemini and get a response
  static Future<String> sendMessage(String message) async {
    if (!_isInitialized || _chatSession == null) {
      await initialize();
    }
    
    try {
      // Include user name in the prompt
      final prompt = '$_userName: $message';
      final content = Content.text(prompt);
      final response = await _chatSession!.sendMessage(content);
      return response.text ?? 'Sorry, I couldn\'t generate a response.';
    } catch (e) {
      print('Error sending message to Gemini: $e');
      return 'Sorry, I encountered an error while processing your request.';
    }
  }
  
  // Get a response from the Gemini API
  static Future<String> getResponse(String message) async {
    try {
      return await sendMessage(message);
    } catch (e) {
      return getFallbackResponse(message);
    }
  }
  
  // Get a fallback response if Gemini API is unavailable
  static String getFallbackResponse(String message) {
    message = message.toLowerCase();
    
    if (message.contains('hello') || message.contains('hi')) {
      return 'Hello $_userName! How can I assist you today?';
    } else if (message.contains('food') || message.contains('menu')) {
      return 'We have various food options available. You can check the menu in the Home tab.';
    } else if (message.contains('order') || message.contains('delivery')) {
      return 'You can place an order by selecting items from the menu and adding them to your cart.';
    } else if (message.contains('thank')) {
      return 'You\'re welcome, $_userName! Is there anything else I can help you with?';
    } else {
      return 'I\'m not sure how to respond to that. Could you try asking something else about the campus food options?';
    }
  }
  
  // Reset the chat session
  static void resetChat() {
    try {
      if (_model != null) {
        _chatSession = _model!.startChat();
      }
    } catch (e) {
      print('Error resetting chat: $e');
    }
  }
} 