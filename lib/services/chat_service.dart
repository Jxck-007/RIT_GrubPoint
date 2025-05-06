import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ChatService {
  static String? _userName;
  static List<Map<String, String>> messages = [];
  static String? _apiKey;
  static bool _isApiKeyConfigured = false;

  // Singleton pattern
  static final ChatService _instance = ChatService._internal();

  factory ChatService() {
    return _instance;
  }

  ChatService._internal() {
    _initializeApiKey();
  }

  static Future<void> _initializeApiKey() async {
    // First try to get from environment variables
    _apiKey = dotenv.env['OPENAI_API_KEY'];
    
    // If not found in env, try to get from SharedPreferences
    if (_apiKey == null) {
      final prefs = await SharedPreferences.getInstance();
      _apiKey = prefs.getString('openai_api_key');
    }
    
    _isApiKeyConfigured = _apiKey != null && _apiKey!.isNotEmpty;
  }

  static Future<void> setApiKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('openai_api_key', key);
    _apiKey = key;
    _isApiKeyConfigured = true;
  }

  static bool get isApiKeyConfigured => _isApiKeyConfigured;

  static String getApiKeyWarning() {
    return 'Warning: AI chat feature is not configured. Please set up your API key in the app settings.';
  }
  
  // Update user name (call this when user name changes)
  static Future<void> updateUserName() async {
    final prefs = await SharedPreferences.getInstance();
    _userName = prefs.getString('user_name') ?? 'User';
  }

  // Get a response for the chat
  static String getResponse(String message) {
    if (!_isApiKeyConfigured) {
      return getApiKeyWarning();
    }
    
    message = message.toLowerCase();
    
    if (message.contains('hi') || message.contains('hello') || message.contains('hey')) {
      return 'Hello! I\'m Jarvix, your food assistant. I can help you with:\n\n• Menu items and prices\n• Special dishes and recommendations\n• Dietary preferences and allergies\n• Order status and delivery times\n\nWhat would you like to know?';
    }

    if (message.contains('menu') || message.contains('what') || message.contains('available')) {
      return 'Here\'s our complete menu:\n\n• Lunch: Veg Thali, Chicken Biryani, Paneer Butter Masala, Dal Makhani, Fish Curry Rice\n• Chaat: Pani Puri, Bhel Puri, Samosa Chaat, Dahi Puri, Papdi Chaat\n• Drinks: Masala Chai, Fresh Lime Soda, Mango Lassi, Cold Coffee, Fresh Fruit Juice\n• Snacks: Vada Pav, Samosa, French Fries, Cheese Sandwich, Spring Roll\n\nWhich category would you like to know more about?';
    }

    if (message.contains('lunch')) {
      return 'Our lunch specials include:\n\n• Veg Thali (₹120) - A complete meal with 3 curries, rice, roti, dal, and dessert\n• Chicken Biryani (₹150) - Fragrant basmati rice with tender chicken pieces\n• Paneer Butter Masala (₹130) - Soft paneer in rich tomato gravy\n• Dal Makhani (₹110) - Creamy black lentils slow-cooked with spices\n• Fish Curry Rice (₹140) - Fresh fish in coconut-based curry with steamed rice\n\nAll dishes are served with fresh salad and papad. Would you like to know about any specific dish?';
    }

    if (message.contains('chaat')) {
      return 'Our chaat selection includes:\n\n• Pani Puri (₹40) - Crispy puris filled with spicy water and potatoes\n• Bhel Puri (₹50) - Puffed rice with chutneys and crunchy sev\n• Samosa Chaat (₹60) - Crumbled samosa topped with yogurt and chutneys\n• Dahi Puri (₹45) - Puris filled with yogurt and sweet-spicy chutneys\n• Papdi Chaat (₹55) - Crispy papdis with yogurt, chutneys, and sev\n\nAll chaat items are made fresh to order. Would you like to try any of these?';
    }

    if (message.contains('drink') || message.contains('beverage')) {
      return 'Our refreshing drinks menu:\n\n• Masala Chai (₹20) - Spiced tea with ginger and cardamom\n• Fresh Lime Soda (₹30) - Sparkling soda with fresh lime juice\n• Mango Lassi (₹50) - Sweet yogurt drink with mango pulp\n• Cold Coffee (₹60) - Iced coffee with milk and cream\n• Fresh Fruit Juice (₹40) - Seasonal fruits blended fresh\n\nAll drinks are made with fresh ingredients. Which one would you like to try?';
    }

    if (message.contains('snack')) {
      return 'Our quick bites include:\n\n• Vada Pav (₹30) - Spicy potato fritter in a bun with chutneys\n• Samosa (₹25) - Crispy pastry filled with spiced potatoes\n• French Fries (₹70) - Golden crispy fries with seasoning\n• Cheese Sandwich (₹60) - Grilled sandwich with cheese and vegetables\n• Spring Roll (₹50) - Crispy rolls with vegetable filling\n\nPerfect for a quick snack! Would you like to know more about any of these?';
    }

    if (message.contains('popular') || message.contains('best') || message.contains('recommend')) {
      return 'Our most popular items are:\n\n• Chicken Biryani - Our signature dish with aromatic spices\n• Pani Puri - A crowd favorite with tangy-spicy water\n• Mango Lassi - Perfect balance of sweet and tangy\n• Vada Pav - Mumbai\'s favorite street food\n\nThese items are highly recommended by our customers. Would you like to know more about any of these?';
    }

    if (message.contains('price') || message.contains('cost') || message.contains('how much')) {
      return 'Our price ranges are:\n\n• Drinks: ₹20-60\n• Snacks: ₹25-70\n• Chaat: ₹40-60\n• Lunch: ₹110-150\n\nAll prices are inclusive of taxes. Would you like to know the price of any specific item?';
    }

    if (message.contains('vegetarian') || message.contains('veg')) {
      return 'We have many vegetarian options:\n\n• Veg Thali\n• Paneer Butter Masala\n• Dal Makhani\n• All chaat items\n• Vada Pav\n• Cheese Sandwich\n• Spring Roll\n\nAll vegetarian items are prepared separately to maintain purity. Would you like to know more about any of these?';
    }

    if (message.contains('spicy') || message.contains('hot')) {
      return 'We can adjust spice levels according to your preference. Our spiciest items are:\n\n• Chicken Biryani\n• Fish Curry Rice\n• Pani Puri (spicy water)\n• Samosa Chaat\n\nWould you like to know about mild options instead?';
    }

    if (message.contains('thank')) {
      return 'You\'re welcome! Feel free to ask me anything else about our menu, prices, or recommendations. I\'m here to help!';
    }

    return 'I\'m not sure about that. I can help you with:\n\n• Menu items and prices\n• Special dishes and recommendations\n• Dietary preferences\n• Order status\n\nWhat would you like to know?';
  }

  static void addMessage(Map<String, String> message) {
    messages.add(message);
  }
} 