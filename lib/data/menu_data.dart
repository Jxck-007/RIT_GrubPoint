import '../models/menu_item.dart';

final List<MenuItem> demoMenuItems = [
  // Aaharam (South Indian)
  MenuItem(
    id: 1,
    name: 'IDLY',
    description: 'Soft and fluffy steamed rice cakes',
    price: 30,
    imageUrl: 'https://example.com/idly.jpg',
    category: 'Aaharam',
  ),
  MenuItem(
    id: 2,
    name: 'PLAIN DOSA',
    description: 'Crispy rice and lentil crepe',
    price: 30,
    imageUrl: 'https://example.com/dosa.jpg',
    category: 'Aaharam',
  ),
  MenuItem(
    id: 3,
    name: 'GHEE ROAST',
    description: 'Crispy dosa roasted with clarified butter',
    price: 35,
    imageUrl: 'https://example.com/ghee-roast.jpg',
    category: 'Aaharam',
  ),
  MenuItem(
    id: 4,
    name: 'VADAI',
    description: 'Crispy lentil fritters',
    price: 10,
    imageUrl: 'https://example.com/vadai.jpg',
    category: 'Aaharam',
  ),
  MenuItem(
    id: 5,
    name: 'MEALS',
    description: 'Complete South Indian thali with rice and curries',
    price: 60,
    imageUrl: 'https://example.com/meals.jpg',
    category: 'Aaharam',
  ),

  // Little Rangoon (Indo-Chinese)
  MenuItem(
    id: 6,
    name: 'VEG FRIED RICE',
    description: 'Stir-fried rice with mixed vegetables',
    price: 50,
    imageUrl: 'https://example.com/veg-fried-rice.jpg',
    category: 'Little Rangoon',
  ),
  MenuItem(
    id: 7,
    name: 'EGG FRIED RICE',
    description: 'Stir-fried rice with scrambled eggs',
    price: 60,
    imageUrl: 'https://example.com/egg-fried-rice.jpg',
    category: 'Little Rangoon',
  ),
  MenuItem(
    id: 8,
    name: 'GOBI NOODLES',
    description: 'Noodles with cauliflower in Indo-Chinese style',
    price: 50,
    imageUrl: 'https://example.com/gobi-noodles.jpg',
    category: 'Little Rangoon',
  ),

  // The Pacific Cafe
  MenuItem(
    id: 9,
    name: 'CHOCOLATE MILK',
    description: 'Rich and creamy chocolate milkshake',
    price: 60,
    imageUrl: 'https://example.com/chocolate-milk.jpg',
    category: 'The Pacific Cafe',
  ),
  MenuItem(
    id: 10,
    name: 'COLD COFFEE',
    description: 'Refreshing cold coffee with ice cream',
    price: 60,
    imageUrl: 'https://example.com/cold-coffee.jpg',
    category: 'The Pacific Cafe',
  ),

  // Cantina de Naples
  MenuItem(
    id: 11,
    name: 'CHEESE PIZZA',
    description: 'Classic pizza with mozzarella cheese',
    price: 70,
    imageUrl: 'https://example.com/cheese-pizza.jpg',
    category: 'Cantina de Naples',
  ),
  MenuItem(
    id: 12,
    name: 'VEG PUFFS',
    description: 'Flaky pastry filled with spiced vegetables',
    price: 15,
    imageUrl: 'https://example.com/veg-puffs.jpg',
    category: 'Cantina de Naples',
  ),

  // Calcutta in a Box
  MenuItem(
    id: 13,
    name: 'SAMOSA',
    description: 'Crispy pastry filled with spiced potatoes',
    price: 12,
    imageUrl: 'https://example.com/samosa.jpg',
    category: 'Calcutta in a Box',
  ),
  MenuItem(
    id: 14,
    name: 'PANI POORI',
    description: 'Hollow crispy puris with spiced water',
    price: 30,
    imageUrl: 'https://example.com/pani-poori.jpg',
    category: 'Calcutta in a Box',
  ),
];

// Helper function to get unique restaurant names
List<String> getRestaurantNames() {
  return demoMenuItems.map((item) => item.category).toSet().toList();
}

// Helper function to get menu items for a specific restaurant
List<MenuItem> getMenuItemsByRestaurant(String restaurantName) {
  return demoMenuItems.where((item) => item.category == restaurantName).toList();
} 