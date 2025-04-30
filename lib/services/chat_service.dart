import 'package:shared_preferences/shared_preferences.dart';

class ChatService {
  static String _userName = 'User';

  // Singleton pattern
  static final ChatService _instance = ChatService._internal();

  factory ChatService() {
    return _instance;
  }

  ChatService._internal();
  
  // Update user name (call this when user name changes)
  static Future<void> updateUserName() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _userName = prefs.getString('user_name') ?? 'User';
    } catch (e) {
      print('Error updating user name: $e');
    }
  }

  // Get a response for the chat
  static String getResponse(String message) {
    message = message.toLowerCase();
    
    if (message.contains('hello') || message.contains('hi')) {
      return 'Hi! How can I help you with our menu today?';
    } else if (message.contains('menu') || message.contains('food') || message.contains('eat')) {
      return 'We have a great selection of food available! Here are our restaurants and their specialties:\n\n' +
             '1. Aaharam (South Indian):\n' +
             '   - IDLY: Soft steamed rice cakes with sambar and chutney (₹30)\n' +
             '   - GHEE ROAST: Crispy dosa with clarified butter (₹35)\n' +
             '   - MEALS: Complete South Indian thali (₹60)\n\n' +
             '2. Little Rangoon (Indo-Chinese):\n' +
             '   - GOBI MANCHURIAN: Crispy cauliflower in spicy sauce (₹70)\n' +
             '   - CHILLI PANEER: Paneer cubes in spicy sauce (₹80)\n' +
             '   - VEG FRIED RICE: Stir-fried rice with vegetables (₹50)\n\n' +
             '3. The Pacific Cafe:\n' +
             '   - COLD COFFEE: Refreshing coffee with ice cream (₹60)\n' +
             '   - FRUIT SMOOTHIE: Fresh fruit smoothie (₹70)\n' +
             '   - ICED TEA: Refreshing iced tea (₹40)\n\n' +
             '4. Cantina de Naples:\n' +
             '   - CHEESE PIZZA: Classic pizza with mozzarella (₹70)\n' +
             '   - PASTA ALFREDO: Creamy pasta with parmesan (₹85)\n' +
             '   - MARGHERITA PIZZA: Pizza with fresh basil (₹80)\n\n' +
             '5. Calcutta in a Box:\n' +
             '   - CHICKEN BIRYANI: Fragrant rice with chicken (₹120)\n' +
             '   - BUTTER CHICKEN: Creamy tomato curry (₹140)\n' +
             '   - PANEER BUTTER MASALA: Paneer in creamy sauce (₹120)\n\n' +
             'What would you like to know more about?';
    } else if (message.contains('order') || message.contains('delivery')) {
      return 'You can place an order by selecting items from the menu. Just browse through the options, add what you like to your cart, and proceed to checkout. Would you like me to suggest some popular items?';
    } else if (message.contains('payment') || message.contains('pay')) {
      return 'We accept various payment methods including credit/debit cards and campus meal plans. All transactions are secure and processed instantly.';
    } else if (message.contains('time') || message.contains('delivery')) {
      return 'Food is typically ready within 15-30 minutes after ordering. You can track your order status in real-time.';
    } else if (message.contains('thank')) {
      return 'You\'re welcome! Let me know if you need any more help with the menu.';
    } else if (message.contains('price') || message.contains('cost')) {
      return 'Our prices are very reasonable:\n' +
             '- South Indian items: ₹30-60\n' +
             '- Indo-Chinese dishes: ₹50-80\n' +
             '- Beverages: ₹40-70\n' +
             '- Pizzas and Pastas: ₹70-90\n' +
             '- North Indian dishes: ₹120-140\n\n' +
             'Would you like to know the price of any specific item?';
    } else if (message.contains('special') || message.contains('today')) {
      return 'Today\'s specials include:\n' +
             '- Aaharam: Special Masala Dosa (₹40)\n' +
             '- Little Rangoon: Schezwan Fried Rice (₹65)\n' +
             '- The Pacific Cafe: Mango Smoothie (₹75)\n' +
             '- Cantina de Naples: Veg Supreme Pizza (₹85)\n' +
             '- Calcutta in a Box: Chicken Tikka Masala (₹130)';
    } else {
      return 'I\'m here to help with menu-related questions! You can ask me about:\n' +
             '- Today\'s specials\n' +
             '- Prices of items\n' +
             '- Popular dishes\n' +
             '- Food descriptions\n' +
             '- Ordering process\n' +
             'What would you like to know?';
    }
  }
} 