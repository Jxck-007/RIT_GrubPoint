import '../models/menu_item.dart';

final Map<String, String> shopImages = {
  'Calcutta in a Box': 'assets/shops/calcutta_in_a_box.jpg',
  'Cantina de Naples': 'assets/shops/cantina_de_naples.jpg',
  'Little Rangoon': 'assets/shops/little_rangoon.jpg',
  'The Pacific Cafe': 'assets/shops/pacific_cafe.jpg',
  'Aaharam': 'assets/shops/aaharam.jpg',
};

final List<MenuItem> demoMenuItems = [
  // Aaharam Items (South Indian)
  MenuItem(
    id: 1,
    name: 'Idly',
    description: 'Steamed rice cakes served with sambar and coconut chutney',
    price: 40,
    imageUrl: 'https://example.com/idly.jpg',
    category: 'Aaharam',
    rating: 4.5,
  ),
  MenuItem(
    id: 2,
    name: 'Ghee Roast',
    description: 'Crispy dosa made with ghee, served with sambar and chutney',
    price: 90,
    imageUrl: 'https://example.com/ghee-roast.jpg',
    category: 'Aaharam',
    rating: 4.7,
  ),
  MenuItem(
    id: 3,
    name: 'Plain Dosa',
    description: 'Classic crispy dosa served with sambar and coconut chutney',
    price: 60,
    imageUrl: 'https://example.com/plain-dosa.jpg',
    category: 'Aaharam',
    rating: 4.6,
  ),
  MenuItem(
    id: 4,
    name: 'Vadai',
    description: 'Crispy fried lentil fritters served with sambar and chutney',
    price: 50,
    imageUrl: 'https://example.com/vadai.jpg',
    category: 'Aaharam',
    rating: 4.4,
  ),
  MenuItem(
    id: 5,
    name: 'Meals',
    description: 'Complete meal with rice, sambar, rasam, curd, 3 vegetables, papad, and pickle',
    price: 120,
    imageUrl: 'https://example.com/meals.jpg',
    category: 'Aaharam',
    rating: 4.8,
  ),

  // Little Rangoon Items (Chinese/Indian Fusion)
  MenuItem(
    id: 6,
    name: 'Veg Fried Rice',
    description: 'Stir-fried rice with mixed vegetables and Chinese spices',
    price: 140,
    imageUrl: 'https://example.com/veg-fried-rice.jpg',
    category: 'Little Rangoon',
    rating: 4.8,
  ),
  MenuItem(
    id: 7,
    name: 'Egg Fried Rice',
    description: 'Stir-fried rice with scrambled eggs and vegetables',
    price: 120,
    imageUrl: 'https://example.com/egg-fried-rice.jpg',
    category: 'Little Rangoon',
    rating: 4.7,
  ),
  MenuItem(
    id: 8,
    name: 'Gobi Manchurian',
    description: 'Crispy fried cauliflower in spicy Chinese sauce',
    price: 130,
    imageUrl: 'https://example.com/gobi-manchurian.jpg',
    category: 'Little Rangoon',
    rating: 4.6,
  ),
  MenuItem(
    id: 9,
    name: 'Chilli Paneer',
    description: 'Crispy paneer cubes in spicy Chinese sauce',
    price: 150,
    imageUrl: 'https://example.com/chilli-paneer.jpg',
    category: 'Little Rangoon',
    rating: 4.5,
  ),

  // The Pacific Cafe Items (Fast Food & Beverages)
  MenuItem(
    id: 10,
    name: 'Veg Noodles',
    description: 'Stir-fried noodles with mixed vegetables and soy sauce',
    price: 180,
    imageUrl: 'https://example.com/veg-noodles.jpg',
    category: 'The Pacific Cafe',
    rating: 4.7,
  ),
  MenuItem(
    id: 11,
    name: 'Chocolate Milkshake',
    description: 'Rich and creamy chocolate milkshake with whipped cream',
    price: 140,
    imageUrl: 'https://example.com/chocolate-milkshake.jpg',
    category: 'The Pacific Cafe',
    rating: 4.6,
  ),
  MenuItem(
    id: 12,
    name: 'Cold Coffee',
    description: 'Iced coffee with milk and sugar',
    price: 160,
    imageUrl: 'https://example.com/cold-coffee.jpg',
    category: 'The Pacific Cafe',
    rating: 4.8,
  ),
  MenuItem(
    id: 13,
    name: 'Fruit Smoothie',
    description: 'Blended fresh fruits with yogurt and honey',
    price: 90,
    imageUrl: 'https://example.com/fruit-smoothie.jpg',
    category: 'The Pacific Cafe',
    rating: 4.5,
  ),

  // Cantina de Naples Items (Italian)
  MenuItem(
    id: 14,
    name: 'Pizza',
    description: 'Classic pizza with tomato sauce, mozzarella, and choice of toppings',
    price: 180,
    imageUrl: 'https://example.com/pizza.jpg',
    category: 'Cantina de Naples',
    rating: 4.8,
  ),
  MenuItem(
    id: 15,
    name: 'Spaghetti Pizza',
    description: 'Pizza topped with spaghetti and cheese',
    price: 150,
    imageUrl: 'https://example.com/spaghetti-pizza.jpg',
    category: 'Cantina de Naples',
    rating: 4.7,
  ),
  MenuItem(
    id: 16,
    name: 'Risotto al Funghi',
    description: 'Creamy mushroom risotto with parmesan cheese',
    price: 170,
    imageUrl: 'https://example.com/risotto.jpg',
    category: 'Cantina de Naples',
    rating: 4.6,
  ),
  MenuItem(
    id: 17,
    name: 'Tiramisu',
    description: 'Classic Italian dessert with coffee and mascarpone',
    price: 90,
    imageUrl: 'https://example.com/tiramisu.jpg',
    category: 'Cantina de Naples',
    rating: 4.9,
  ),

  // Calcutta in a Box Items (Bengali)
  MenuItem(
    id: 18,
    name: 'Kathi Roll',
    description: 'Flaky paratha wrapped with spiced chicken or paneer',
    price: 100,
    imageUrl: 'https://example.com/kathi-roll.jpg',
    category: 'Calcutta in a Box',
    rating: 4.7,
  ),
  MenuItem(
    id: 19,
    name: 'Fish Curry',
    description: 'Bengali style fish curry with mustard and poppy seeds',
    price: 150,
    imageUrl: 'https://example.com/fish-curry.jpg',
    category: 'Calcutta in a Box',
    rating: 4.6,
  ),
  MenuItem(
    id: 20,
    name: 'Mutton Kosha',
    description: 'Slow-cooked mutton curry with Bengali spices',
    price: 180,
    imageUrl: 'https://example.com/mutton-kosha.jpg',
    category: 'Calcutta in a Box',
    rating: 4.8,
  ),
  MenuItem(
    id: 21,
    name: 'Mishti Doi',
    description: 'Sweet Bengali style yogurt dessert',
    price: 60,
    imageUrl: 'https://example.com/mishti-doi.jpg',
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