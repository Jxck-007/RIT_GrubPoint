import 'package:shared_preferences/shared_preferences.dart';

class ChatService {
  static String? _userName;

  // Singleton pattern
  static final ChatService _instance = ChatService._internal();

  factory ChatService() {
    return _instance;
  }

  ChatService._internal();
  
  // Update user name (call this when user name changes)
  static Future<void> updateUserName() async {
    final prefs = await SharedPreferences.getInstance();
    _userName = prefs.getString('user_name') ?? 'User';
  }

  // Get a response for the chat
  static String getResponse(String message) {
    message = message.toLowerCase();
    
    if (message.contains('hi') || message.contains('hello') || message.contains('hey')) {
      return 'Hello! I\'m Jarvix, your food assistant. How can I help you today?';
    }

    if (message.contains('menu') || message.contains('what') || message.contains('available')) {
      return 'We have various categories including Lunch, Chaat, Drinks, and Snacks. What would you like to know about?';
    }

    if (message.contains('lunch')) {
      return 'For lunch, we have Veg Thali (₹120), Chicken Biryani (₹150), Paneer Butter Masala (₹130), Dal Makhani (₹110), and Fish Curry Rice (₹140). All served fresh and hot!';
    }

    if (message.contains('chaat')) {
      return 'In our chaat section, we offer Pani Puri (₹40), Bhel Puri (₹50), Samosa Chaat (₹60), Dahi Puri (₹45), and Papdi Chaat (₹55). All made with authentic ingredients!';
    }

    if (message.contains('drink') || message.contains('beverage')) {
      return 'Our drinks menu includes Masala Chai (₹20), Fresh Lime Soda (₹30), Mango Lassi (₹50), Cold Coffee (₹60), and Fresh Fruit Juice (₹40). Perfect to beat the heat!';
    }

    if (message.contains('snack')) {
      return 'For snacks, we have Vada Pav (₹30), Samosa (₹25), French Fries (₹70), Cheese Sandwich (₹60), and Spring Roll (₹50). Great for a quick bite!';
    }

    if (message.contains('popular') || message.contains('best') || message.contains('recommend')) {
      return 'Our most popular items are Chicken Biryani, Pani Puri, Mango Lassi, and Vada Pav. Would you like to know more about any of these?';
    }

    if (message.contains('price') || message.contains('cost') || message.contains('how much')) {
      return 'Our prices range from ₹20 for Masala Chai to ₹150 for Chicken Biryani. Which item\'s price would you like to know specifically?';
    }

    if (message.contains('thank')) {
      return 'You\'re welcome! Feel free to ask me anything else about our food items.';
    }

    return 'I\'m not sure about that. Would you like to know about our menu items, prices, or popular dishes?';
  }
} 