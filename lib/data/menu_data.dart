import '../models/menu_item.dart';

final Map<String, String> shopImages = {
  'Calcutta in a Box': 'assets/shops/calcutta_in_a_box.jpg',
  'Cantina de Naples': 'assets/shops/cantina_de_naples.jpg',
  'Little Rangoon': 'assets/shops/little_rangoon.jpg',
  'The Pacific Cafe': 'assets/shops/pacific_cafe.jpg',
  'Aaharam': 'assets/shops/aaharam.jpg',
};

final List<MenuItem> demoMenuItems = [
  // Aaharam (South Indian)
  MenuItem(
    id: 1,
    name: 'IDLY',
    description: 'Soft and fluffy steamed rice cakes served with sambar and chutney',
    price: 30,
    imageUrl: 'https://example.com/idly.jpg',
    category: 'Aaharam',
    rating: 4.5,
  ),
  MenuItem(
    id: 2,
    name: 'PLAIN DOSA',
    description: 'Crispy rice and lentil crepe served with sambar and coconut chutney',
    price: 30,
    imageUrl: 'https://example.com/dosa.jpg',
    category: 'Aaharam',
    rating: 4.3,
  ),
  MenuItem(
    id: 3,
    name: 'GHEE ROAST',
    description: 'Crispy dosa roasted with clarified butter, served with sambar and chutney',
    price: 35,
    imageUrl: 'https://example.com/ghee-roast.jpg',
    category: 'Aaharam',
    rating: 4.7,
  ),
  MenuItem(
    id: 4,
    name: 'VADAI',
    description: 'Crispy lentil fritters served with sambar and coconut chutney',
    price: 10,
    imageUrl: 'https://example.com/vadai.jpg',
    category: 'Aaharam',
    rating: 4.2,
  ),
  MenuItem(
    id: 5,
    name: 'MEALS',
    description: 'Complete South Indian thali with rice, sambar, rasam, curries, and papad',
    price: 60,
    imageUrl: 'https://example.com/meals.jpg',
    category: 'Aaharam',
    rating: 4.6,
  ),

  // Little Rangoon (Indo-Chinese)
  MenuItem(
    id: 6,
    name: 'VEG FRIED RICE',
    description: 'Stir-fried rice with mixed vegetables and Indo-Chinese spices',
    price: 50,
    imageUrl: 'https://example.com/veg-fried-rice.jpg',
    category: 'Little Rangoon',
    rating: 4.4,
  ),
  MenuItem(
    id: 7,
    name: 'EGG FRIED RICE',
    description: 'Stir-fried rice with scrambled eggs and vegetables',
    price: 60,
    imageUrl: 'https://example.com/egg-fried-rice.jpg',
    category: 'Little Rangoon',
    rating: 4.5,
  ),
  MenuItem(
    id: 8,
    name: 'GOBI MANCHURIAN',
    description: 'Crispy cauliflower florets tossed in spicy Indo-Chinese sauce',
    price: 70,
    imageUrl: 'https://example.com/gobi-manchurian.jpg',
    category: 'Little Rangoon',
    rating: 4.6,
  ),
  MenuItem(
    id: 9,
    name: 'CHILLI PANEER',
    description: 'Crispy paneer cubes in spicy Indo-Chinese sauce',
    price: 80,
    imageUrl: 'https://example.com/chilli-paneer.jpg',
    category: 'Little Rangoon',
    rating: 4.7,
  ),
  MenuItem(
    id: 10,
    name: 'VEG HAKKA NOODLES',
    description: 'Stir-fried noodles with mixed vegetables and Indo-Chinese spices',
    price: 60,
    imageUrl: 'https://example.com/veg-noodles.jpg',
    category: 'Little Rangoon',
    rating: 4.5,
  ),

  // The Pacific Cafe
  MenuItem(
    id: 11,
    name: 'CHOCOLATE MILKSHAKE',
    description: 'Rich and creamy chocolate milkshake with whipped cream',
    price: 60,
    imageUrl: 'https://example.com/chocolate-milk.jpg',
    category: 'The Pacific Cafe',
    rating: 4.8,
  ),
  MenuItem(
    id: 12,
    name: 'COLD COFFEE',
    description: 'Refreshing cold coffee with ice cream and whipped cream',
    price: 60,
    imageUrl: 'https://example.com/cold-coffee.jpg',
    category: 'The Pacific Cafe',
    rating: 4.7,
  ),
  MenuItem(
    id: 13,
    name: 'FRUIT SMOOTHIE',
    description: 'Fresh fruit smoothie with yogurt and honey',
    price: 70,
    imageUrl: 'https://example.com/fruit-smoothie.jpg',
    category: 'The Pacific Cafe',
    rating: 4.6,
  ),
  MenuItem(
    id: 14,
    name: 'ICED TEA',
    description: 'Refreshing iced tea with lemon and mint',
    price: 40,
    imageUrl: 'https://example.com/iced-tea.jpg',
    category: 'The Pacific Cafe',
    rating: 4.4,
  ),
  MenuItem(
    id: 15,
    name: 'FRESH JUICE',
    description: 'Freshly squeezed seasonal fruit juice',
    price: 50,
    imageUrl: 'https://example.com/fresh-juice.jpg',
    category: 'The Pacific Cafe',
    rating: 4.5,
  ),

  // Cantina de Naples
  MenuItem(
    id: 16,
    name: 'CHEESE PIZZA',
    description: 'Classic pizza with mozzarella cheese and tomato sauce',
    price: 70,
    imageUrl: 'https://example.com/cheese-pizza.jpg',
    category: 'Cantina de Naples',
    rating: 4.6,
  ),
  MenuItem(
    id: 17,
    name: 'PEPPERONI PIZZA',
    description: 'Classic pizza with pepperoni and mozzarella cheese',
    price: 90,
    imageUrl: 'https://example.com/pepperoni-pizza.jpg',
    category: 'Cantina de Naples',
    rating: 4.7,
  ),
  MenuItem(
    id: 18,
    name: 'MARGHERITA PIZZA',
    description: 'Classic pizza with fresh basil, tomatoes, and mozzarella',
    price: 80,
    imageUrl: 'https://example.com/margherita-pizza.jpg',
    category: 'Cantina de Naples',
    rating: 4.8,
  ),
  MenuItem(
    id: 19,
    name: 'PASTA ALFREDO',
    description: 'Creamy pasta with parmesan cheese sauce',
    price: 85,
    imageUrl: 'https://example.com/pasta-alfredo.jpg',
    category: 'Cantina de Naples',
    rating: 4.6,
  ),
  MenuItem(
    id: 20,
    name: 'PASTA ARRABBIATA',
    description: 'Spicy pasta with tomato sauce and chili flakes',
    price: 85,
    imageUrl: 'https://example.com/pasta-arrabbiata.jpg',
    category: 'Cantina de Naples',
    rating: 4.5,
  ),

  // Calcutta in a Box
  MenuItem(
    id: 21,
    name: 'CHICKEN BIRYANI',
    description: 'Fragrant rice dish with tender chicken and aromatic spices',
    price: 120,
    imageUrl: 'https://example.com/chicken-biryani.jpg',
    category: 'Calcutta in a Box',
    rating: 4.8,
  ),
  MenuItem(
    id: 22,
    name: 'VEG BIRYANI',
    description: 'Fragrant rice dish with mixed vegetables and aromatic spices',
    price: 100,
    imageUrl: 'https://example.com/veg-biryani.jpg',
    category: 'Calcutta in a Box',
    rating: 4.6,
  ),
  MenuItem(
    id: 23,
    name: 'BUTTER CHICKEN',
    description: 'Creamy tomato-based curry with tender chicken pieces',
    price: 140,
    imageUrl: 'https://example.com/butter-chicken.jpg',
    category: 'Calcutta in a Box',
    rating: 4.7,
  ),
  MenuItem(
    id: 24,
    name: 'PANEER BUTTER MASALA',
    description: 'Creamy tomato-based curry with soft paneer cubes',
    price: 120,
    imageUrl: 'https://example.com/paneer-butter-masala.jpg',
    category: 'Calcutta in a Box',
    rating: 4.6,
  ),
  MenuItem(
    id: 25,
    name: 'NAAN',
    description: 'Soft and fluffy Indian bread',
    price: 30,
    imageUrl: 'https://example.com/naan.jpg',
    category: 'Calcutta in a Box',
    rating: 4.5,
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

List<MenuItem> getAllMenuItems() {
  List<MenuItem> allItems = [];
  
  // Add items from each restaurant
  allItems.addAll(getMenuItemsByRestaurant('Aaharam'));
  allItems.addAll(getMenuItemsByRestaurant('Little Rangoon'));
  allItems.addAll(getMenuItemsByRestaurant('The Pacific Cafe'));
  allItems.addAll(getMenuItemsByRestaurant('Cantina de Naples'));
  allItems.addAll(getMenuItemsByRestaurant('Calcutta in a Box'));
  
  return allItems;
} 