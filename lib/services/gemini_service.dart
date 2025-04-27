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
      
      // Initialize with a system prompt for context
      await _initializeWithSystemPrompt();
    } catch (e) {
      print('Error initializing Gemini: $e');
      _isInitialized = false;
      rethrow;
    }
  }
  
  // Initialize the chat with a system prompt for context
  static Future<void> _initializeWithSystemPrompt() async {
    try {
      final systemPrompt = """
You are Jarvix, a helpful canteen preordering assistant for RIT GrubPoint.
Your primary purpose is to help students order food from the canteen.
Be helpful, friendly, and concise when replying to the user $_userName.

You can help with:
- Menu suggestions based on food preferences
- Information about today's special dishes
- Popular orders among students
- Preorder guidance and process steps
- Answering FAQs about payment options
- Providing pickup and delivery time information

Always address the user by their name: $_userName
If you don't know an answer, suggest checking the menu page or asking the canteen staff.
""";
      
      final content = Content.text(systemPrompt);
      await _chatSession!.sendMessage(content);
    } catch (e) {
      print('Error setting system prompt: $e');
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
      // Include user name in the prompt if not already there
      String prompt = message;
      if (!prompt.contains(_userName)) {
        prompt = '$_userName: $message';
      }
      
      final content = Content.text(prompt);
      final response = await _chatSession!.sendMessage(content);
      return response.text ?? 'Sorry, I couldn\'t generate a response.';
    } catch (e) {
      print('Error sending message to Gemini: $e');
      return 'Jarvix is currently unavailable. Please try again shortly.';
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
      return 'Hello $_userName! How can I assist you with your food order today?';
    } else if (message.contains('menu') || message.contains('food') || message.contains('eat')) {
      return 'We have various food options available today. You can check the full menu in the Home tab. Would you like me to suggest some popular items?';
    } else if (message.contains('order') || message.contains('delivery')) {
      return 'You can place an order by selecting items from the menu and adding them to your cart. Would you like help with placing an order, $_userName?';
    } else if (message.contains('payment') || message.contains('pay')) {
      return 'We accept multiple payment methods including credit/debit cards and campus meal plans. All payments are processed securely.';
    } else if (message.contains('time') || message.contains('delivery')) {
      return 'Typical delivery times are 15-30 minutes, depending on current demand. You can track your order status in real-time after placing it.';
    } else if (message.contains('thank')) {
      return 'You\'re welcome, $_userName! Is there anything else I can help you with regarding your food order?';
    } else {
      return 'I\'m not sure how to respond to that. Could you try asking about today\'s menu, placing an order, delivery times, or payment options?';
    }
  }
  
  // Reset the chat session
  static void resetChat() {
    try {
      if (_model != null) {
        _chatSession = _model!.startChat();
        _initializeWithSystemPrompt();
      }
    } catch (e) {
      print('Error resetting chat: $e');
    }
  }
} 