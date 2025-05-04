import '../models/menu_item.dart';

final Map<String, Map<String, String>> shopImages = {
  'Calcutta in a Box': {
    'image': 'assets/shops/calcutta_in_a_box.jpg',
    'fallback': 'assets/LOGO.png',
  },
  'Cantina de Naples': {
    'image': 'assets/shops/cantina_de_naples.jpg',
    'fallback': 'assets/LOGO.png',
  },
  'Little Rangoon': {
    'image': 'assets/shops/little_rangoon.jpg',
    'fallback': 'assets/LOGO.png',
  },
  'The Pacific Cafe': {
    'image': 'assets/shops/pacific_cafe.jpg',
    'fallback': 'assets/LOGO.png',
  },
  'Aaharam': {
    'image': 'assets/shops/aaharam.jpg',
    'fallback': 'assets/LOGO.png',
  },
};

final Map<String, String> itemFallbackImages = {
  'idly': 'assets/LOGO.png',
  'ghee_roast': 'assets/LOGO.png',
  'plain_dosa': 'assets/LOGO.png',
  'vadai': 'assets/LOGO.png',
  'meals': 'assets/LOGO.png',
  'veg_fried_rice': 'assets/LOGO.png',
  'egg_fried_rice': 'assets/LOGO.png',
  'gobi_manchurian': 'assets/LOGO.png',
  'chilli_paneer': 'assets/LOGO.png',
  'veg_noodles': 'assets/LOGO.png',
  'pasta': 'assets/LOGO.png',
  'pizza': 'assets/LOGO.png',
  'burger': 'assets/LOGO.png',
  'sandwich': 'assets/LOGO.png',
  'coffee': 'assets/LOGO.png',
  'tea': 'assets/LOGO.png',
  'juice': 'assets/LOGO.png',
  'smoothie': 'assets/LOGO.png',
};

final List<MenuItem> demoMenuItems = [
  // Aaharam Items (South Indian)
  MenuItem(
    id: 1,
    name: 'Idly',
    description: 'Steamed rice cakes served with sambar and coconut chutney',
    price: 40,
    imageUrl: 'assets/images/idly.jpg',
    fallbackImageUrl: itemFallbackImages['idly']!,
    category: 'Aaharam',
    rating: 4.5,
  ),
  MenuItem(
    id: 2,
    name: 'Ghee Roast',
    description: 'Crispy dosa made with ghee, served with sambar and chutney',
    price: 90,
    imageUrl: 'assets/images/ghee_roast.jpg',
    fallbackImageUrl: itemFallbackImages['ghee_roast']!,
    category: 'Aaharam',
    rating: 4.7,
  ),
  MenuItem(
    id: 3,
    name: 'Plain Dosa',
    description: 'Classic crispy dosa served with sambar and coconut chutney',
    price: 60,
    imageUrl: 'assets/images/plain_dosa.jpg',
    fallbackImageUrl: itemFallbackImages['plain_dosa']!,
    category: 'Aaharam',
    rating: 4.6,
  ),
  MenuItem(
    id: 4,
    name: 'Vadai',
    description: 'Crispy fried lentil fritters served with sambar and chutney',
    price: 50,
    imageUrl: 'assets/images/vadai.jpg',
    fallbackImageUrl: itemFallbackImages['vadai']!,
    category: 'Aaharam',
    rating: 4.4,
  ),
  MenuItem(
    id: 5,
    name: 'Meals',
    description: 'Complete meal with rice, sambar, rasam, curd, 3 vegetables, papad, and pickle',
    price: 120,
    imageUrl: 'assets/images/meals.jpg',
    fallbackImageUrl: itemFallbackImages['meals']!,
    category: 'Aaharam',
    rating: 4.8,
  ),

  // Little Rangoon Items (Chinese/Indian Fusion)
  MenuItem(
    id: 6,
    name: 'Veg Fried Rice',
    description: 'Stir-fried rice with mixed vegetables and Chinese spices',
    price: 140,
    imageUrl: 'assets/images/veg_fried_rice.jpg',
    fallbackImageUrl: itemFallbackImages['veg_fried_rice']!,
    category: 'Little Rangoon',
    rating: 4.8,
  ),
  MenuItem(
    id: 7,
    name: 'Egg Fried Rice',
    description: 'Stir-fried rice with scrambled eggs and vegetables',
    price: 120,
    imageUrl: 'assets/images/egg_fried_rice.jpg',
    fallbackImageUrl: itemFallbackImages['egg_fried_rice']!,
    category: 'Little Rangoon',
    rating: 4.7,
  ),
  MenuItem(
    id: 8,
    name: 'Gobi Manchurian',
    description: 'Crispy fried cauliflower in spicy Chinese sauce',
    price: 130,
    imageUrl: 'assets/images/gobi_manchurian.jpg',
    fallbackImageUrl: itemFallbackImages['gobi_manchurian']!,
    category: 'Little Rangoon',
    rating: 4.6,
  ),
  MenuItem(
    id: 9,
    name: 'Chilli Paneer',
    description: 'Crispy paneer cubes in spicy Chinese sauce',
    price: 150,
    imageUrl: 'assets/images/chilli_paneer.jpg',
    fallbackImageUrl: itemFallbackImages['chilli_paneer']!,
    category: 'Little Rangoon',
    rating: 4.5,
  ),

  // The Pacific Cafe Items (Fast Food & Beverages)
  MenuItem(
    id: 10,
    name: 'Veg Noodles',
    description: 'Stir-fried noodles with mixed vegetables',
    price: 120,
    imageUrl: 'assets/images/veg_noodles.jpg',
    fallbackImageUrl: itemFallbackImages['veg_noodles']!,
    category: 'The Pacific Cafe',
    rating: 4.5,
  ),
  MenuItem(
    id: 11,
    name: 'Chocolate Milkshake',
    description: 'Rich and creamy chocolate milkshake with whipped cream',
    price: 140,
    imageUrl: 'assets/images/chocolate_milkshake.jpg',
    category: 'The Pacific Cafe',
    rating: 4.6,
  ),
  MenuItem(
    id: 12,
    name: 'Cold Coffee',
    description: 'Iced coffee with milk and sugar',
    price: 160,
    imageUrl: 'assets/images/cold_coffee.jpg',
    category: 'The Pacific Cafe',
    rating: 4.8,
  ),
  MenuItem(
    id: 13,
    name: 'Fruit Smoothie',
    description: 'Blended fresh fruits with yogurt and honey',
    price: 90,
    imageUrl: 'assets/images/fruit_smoothie.jpg',
    category: 'The Pacific Cafe',
    rating: 4.5,
  ),

  // Cantina de Naples Items (Italian)
  MenuItem(
    id: 14,
    name: 'Pizza',
    description: 'Classic pizza with tomato sauce, mozzarella, and choice of toppings',
    price: 180,
    imageUrl: 'assets/images/pizza.jpg',
    category: 'Cantina de Naples',
    rating: 4.8,
  ),
  MenuItem(
    id: 15,
    name: 'Spaghetti Pizza',
    description: 'Pizza topped with spaghetti and cheese',
    price: 150,
    imageUrl: 'assets/images/spaghetti_pizza.jpg',
    category: 'Cantina de Naples',
    rating: 4.7,
  ),
  MenuItem(
    id: 16,
    name: 'Risotto al Funghi',
    description: 'Creamy mushroom risotto with parmesan cheese',
    price: 170,
    imageUrl: 'assets/images/risotto.jpg',
    category: 'Cantina de Naples',
    rating: 4.6,
  ),
  MenuItem(
    id: 17,
    name: 'Tiramisu',
    description: 'Classic Italian dessert with coffee and mascarpone',
    price: 90,
    imageUrl: 'assets/images/tiramisu.jpg',
    category: 'Cantina de Naples',
    rating: 4.9,
  ),

  // Calcutta in a Box Items (Bengali)
  MenuItem(
    id: 18,
    name: 'Kathi Roll',
    description: 'Flaky paratha wrapped with spiced chicken or paneer',
    price: 100,
    imageUrl: 'assets/images/kathi_roll.jpg',
    category: 'Calcutta in a Box',
    rating: 4.7,
  ),
  MenuItem(
    id: 19,
    name: 'Fish Curry',
    description: 'Bengali style fish curry with mustard and poppy seeds',
    price: 150,
    imageUrl: 'assets/images/fish_curry.jpg',
    category: 'Calcutta in a Box',
    rating: 4.6,
  ),
  MenuItem(
    id: 20,
    name: 'Mutton Kosha',
    description: 'Slow-cooked mutton curry with Bengali spices',
    price: 180,
    imageUrl: 'assets/images/mutton_kosha.jpg',
    category: 'Calcutta in a Box',
    rating: 4.8,
  ),
  MenuItem(
    id: 21,
    name: 'Mishti Doi',
    description: 'Sweet Bengali style yogurt dessert',
    price: 60,
    imageUrl: 'assets/images/mishti_doi.jpg',
    category: 'Calcutta in a Box',
    rating: 4.9,
  ),
];

// Helper function to get unique restaurant names
List<String> getRestaurantNames() {
  return shopImages.keys.toList();
}

// Helper function to get menu items for a specific restaurant
List<MenuItem> getMenuItemsByRestaurant(String restaurantName) {
  return demoMenuItems.where((item) => item.category == restaurantName).toList();
}

List<MenuItem> getAllMenuItems() {
  return demoMenuItems;
} 