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
<<<<<<< HEAD
    description: 'Soft and fluffy steamed rice cakes',
    price: 30,
    imageUrl: 'https://example.com/idly.jpg',
    category: 'Aaharam',
=======
    description: 'Soft and fluffy steamed rice cakes served with sambar and chutney',
    price: 30,
    imageUrl: 'https://example.com/idly.jpg',
    category: 'Aaharam',
    rating: 4.5,
>>>>>>> ee47cadfc7141dbdf450a21f77a6f5469d4e36f9
  ),
  MenuItem(
    id: 2,
    name: 'PLAIN DOSA',
<<<<<<< HEAD
    description: 'Crispy rice and lentil crepe',
    price: 30,
    imageUrl: 'https://example.com/dosa.jpg',
    category: 'Aaharam',
=======
    description: 'Crispy rice and lentil crepe served with sambar and coconut chutney',
    price: 30,
    imageUrl: 'https://example.com/dosa.jpg',
    category: 'Aaharam',
    rating: 4.3,
>>>>>>> ee47cadfc7141dbdf450a21f77a6f5469d4e36f9
  ),
  MenuItem(
    id: 3,
    name: 'GHEE ROAST',
<<<<<<< HEAD
    description: 'Crispy dosa roasted with clarified butter',
    price: 35,
    imageUrl: 'https://example.com/ghee-roast.jpg',
    category: 'Aaharam',
=======
    description: 'Crispy dosa roasted with clarified butter, served with sambar and chutney',
    price: 35,
    imageUrl: 'https://example.com/ghee-roast.jpg',
    category: 'Aaharam',
    rating: 4.7,
>>>>>>> ee47cadfc7141dbdf450a21f77a6f5469d4e36f9
  ),
  MenuItem(
    id: 4,
    name: 'VADAI',
<<<<<<< HEAD
    description: 'Crispy lentil fritters',
    price: 10,
    imageUrl: 'https://example.com/vadai.jpg',
    category: 'Aaharam',
=======
    description: 'Crispy lentil fritters served with sambar and coconut chutney',
    price: 10,
    imageUrl: 'https://example.com/vadai.jpg',
    category: 'Aaharam',
    rating: 4.2,
>>>>>>> ee47cadfc7141dbdf450a21f77a6f5469d4e36f9
  ),
  MenuItem(
    id: 5,
    name: 'MEALS',
<<<<<<< HEAD
    description: 'Complete South Indian thali with rice and curries',
    price: 60,
    imageUrl: 'https://example.com/meals.jpg',
    category: 'Aaharam',
=======
    description: 'Complete South Indian thali with rice, sambar, rasam, curries, and papad',
    price: 60,
    imageUrl: 'https://example.com/meals.jpg',
    category: 'Aaharam',
    rating: 4.6,
>>>>>>> ee47cadfc7141dbdf450a21f77a6f5469d4e36f9
  ),

  // Little Rangoon (Indo-Chinese)
  MenuItem(
    id: 6,
    name: 'VEG FRIED RICE',
<<<<<<< HEAD
    description: 'Stir-fried rice with mixed vegetables',
    price: 50,
    imageUrl: 'https://example.com/veg-fried-rice.jpg',
    category: 'Little Rangoon',
=======
    description: 'Stir-fried rice with mixed vegetables and Indo-Chinese spices',
    price: 50,
    imageUrl: 'https://example.com/veg-fried-rice.jpg',
    category: 'Little Rangoon',
    rating: 4.4,
>>>>>>> ee47cadfc7141dbdf450a21f77a6f5469d4e36f9
  ),
  MenuItem(
    id: 7,
    name: 'EGG FRIED RICE',
<<<<<<< HEAD
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
=======
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
>>>>>>> ee47cadfc7141dbdf450a21f77a6f5469d4e36f9
  ),

  // The Pacific Cafe
  MenuItem(
<<<<<<< HEAD
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
=======
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
>>>>>>> ee47cadfc7141dbdf450a21f77a6f5469d4e36f9
  ),

  // Cantina de Naples
  MenuItem(
<<<<<<< HEAD
    id: 11,
    name: 'CHEESE PIZZA',
    description: 'Classic pizza with mozzarella cheese',
    price: 70,
    imageUrl: 'https://example.com/cheese-pizza.jpg',
    category: 'Cantina de Naples',
  ),
  MenuItem(
    id: 12,
=======
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
>>>>>>> ee47cadfc7141dbdf450a21f77a6f5469d4e36f9
    name: 'VEG PUFFS',
    description: 'Flaky pastry filled with spiced vegetables',
    price: 15,
    imageUrl: 'https://example.com/veg-puffs.jpg',
    category: 'Cantina de Naples',
<<<<<<< HEAD
=======
    rating: 4.3,
  ),
  MenuItem(
    id: 18,
    name: 'GARLIC BREAD',
    description: 'Toasted bread with garlic butter and herbs',
    price: 40,
    imageUrl: 'https://example.com/garlic-bread.jpg',
    category: 'Cantina de Naples',
    rating: 4.5,
  ),
  MenuItem(
    id: 19,
    name: 'MARGHERITA PIZZA',
    description: 'Classic pizza with tomato sauce, mozzarella, and basil',
    price: 80,
    imageUrl: 'https://example.com/margherita.jpg',
    category: 'Cantina de Naples',
    rating: 4.7,
  ),
  MenuItem(
    id: 20,
    name: 'CHEESE GARLIC BREAD',
    description: 'Garlic bread topped with melted cheese',
    price: 50,
    imageUrl: 'https://example.com/cheese-garlic-bread.jpg',
    category: 'Cantina de Naples',
    rating: 4.6,
>>>>>>> ee47cadfc7141dbdf450a21f77a6f5469d4e36f9
  ),

  // Calcutta in a Box
  MenuItem(
<<<<<<< HEAD
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
  MenuItem(
    id: 15,
    name: 'VEG CUTLET',
    description: 'Crispy vegetable cutlet',
    price: 15,
    imageUrl: 'https://via.placeholder.com/150',
    category: 'Calcutta in a Box',
  ),
  MenuItem(
    id: 16,
    name: 'ALOO S/W CUTLET',
    description: 'Aloo sandwich cutlet',
    price: 15,
    imageUrl: 'https://via.placeholder.com/150',
    category: 'Calcutta in a Box',
  ),
  MenuItem(
    id: 17,
    name: 'EGG CUTLET',
    description: 'Egg cutlet',
    price: 20,
    imageUrl: 'https://via.placeholder.com/150',
    category: 'Calcutta in a Box',
  ),
  MenuItem(
    id: 18,
    name: 'CHANNA MASALA',
    description: 'Spicy channa masala',
    price: 30,
    imageUrl: 'https://via.placeholder.com/150',
    category: 'Calcutta in a Box',
  ),
  MenuItem(
    id: 19,
    name: 'KACHORI',
    description: 'Crispy kachori',
    price: 20,
    imageUrl: 'https://via.placeholder.com/150',
    category: 'Calcutta in a Box',
  ),
  MenuItem(
    id: 20,
    name: 'BHEL POORI',
    description: 'Bhel poori',
    price: 40,
    imageUrl: 'https://via.placeholder.com/150',
    category: 'Calcutta in a Box',
  ),
  MenuItem(
    id: 21,
=======
    id: 21,
    name: 'SAMOSA',
    description: 'Crispy pastry filled with spiced potatoes and peas',
    price: 12,
    imageUrl: 'https://example.com/samosa.jpg',
    category: 'Calcutta in a Box',
    rating: 4.4,
  ),
  MenuItem(
    id: 22,
    name: 'PANI POORI',
    description: 'Hollow crispy puris with spiced water and chutneys',
    price: 30,
    imageUrl: 'https://example.com/pani-poori.jpg',
    category: 'Calcutta in a Box',
    rating: 4.7,
  ),
  MenuItem(
    id: 23,
    name: 'VEG CUTLET',
    description: 'Crispy vegetable cutlet with mint chutney',
    price: 15,
    imageUrl: 'https://example.com/veg-cutlet.jpg',
    category: 'Calcutta in a Box',
    rating: 4.3,
  ),
  MenuItem(
    id: 24,
    name: 'DAHI PURI',
    description: 'Crispy puris filled with yogurt and chutneys',
    price: 40,
    imageUrl: 'https://example.com/dahi-puri.jpg',
    category: 'Calcutta in a Box',
    rating: 4.6,
  ),
  MenuItem(
    id: 25,
    name: 'BHEL POORI',
    description: 'Crispy puris with puffed rice, vegetables, and chutneys',
    price: 40,
    imageUrl: 'https://example.com/bhel-puri.jpg',
    category: 'Calcutta in a Box',
    rating: 4.5,
  ),
  MenuItem(
    id: 26,
>>>>>>> ee47cadfc7141dbdf450a21f77a6f5469d4e36f9
    name: 'BREAD PANEER PAKKODA',
    description: 'Bread paneer pakkoda',
    price: 20,
    imageUrl: 'https://via.placeholder.com/150',
    category: 'Calcutta in a Box',
  ),
  MenuItem(
<<<<<<< HEAD
    id: 22,
=======
    id: 27,
>>>>>>> ee47cadfc7141dbdf450a21f77a6f5469d4e36f9
    name: 'GULAB JAMUN',
    description: 'Sweet gulab jamun',
    price: 20,
    imageUrl: 'https://via.placeholder.com/150',
    category: 'Calcutta in a Box',
  ),
  MenuItem(
<<<<<<< HEAD
    id: 23,
=======
    id: 28,
>>>>>>> ee47cadfc7141dbdf450a21f77a6f5469d4e36f9
    name: 'SAMOSA CHENNA',
    description: 'Samosa chenna',
    price: 40,
    imageUrl: 'https://via.placeholder.com/150',
    category: 'Calcutta in a Box',
  ),
  MenuItem(
<<<<<<< HEAD
    id: 24,
=======
    id: 29,
>>>>>>> ee47cadfc7141dbdf450a21f77a6f5469d4e36f9
    name: 'DAHI PURI-40',
    description: 'Dahi puri',
    price: 40,
    imageUrl: 'https://via.placeholder.com/150',
    category: 'Calcutta in a Box',
  ),
  MenuItem(
<<<<<<< HEAD
    id: 25,
=======
    id: 30,
>>>>>>> ee47cadfc7141dbdf450a21f77a6f5469d4e36f9
    name: 'VEG FRANKIE',
    description: 'Veg frankie',
    price: 35,
    imageUrl: 'https://via.placeholder.com/150',
    category: 'Calcutta in a Box',
  ),
  MenuItem(
<<<<<<< HEAD
    id: 26,
=======
    id: 31,
>>>>>>> ee47cadfc7141dbdf450a21f77a6f5469d4e36f9
    name: 'EGG FRANKIE',
    description: 'Egg frankie',
    price: 40,
    imageUrl: 'https://via.placeholder.com/150',
    category: 'Calcutta in a Box',
  ),
  MenuItem(
<<<<<<< HEAD
    id: 27,
=======
    id: 32,
>>>>>>> ee47cadfc7141dbdf450a21f77a6f5469d4e36f9
    name: 'PANEER FRANKIE',
    description: 'Paneer frankie',
    price: 50,
    imageUrl: 'https://via.placeholder.com/150',
    category: 'Calcutta in a Box',
  ),
  MenuItem(
<<<<<<< HEAD
    id: 28,
=======
    id: 33,
>>>>>>> ee47cadfc7141dbdf450a21f77a6f5469d4e36f9
    name: 'HALF BOIL / BOILED EGG',
    description: 'Half boil / boiled egg',
    price: 10,
    imageUrl: 'https://via.placeholder.com/150',
    category: 'Calcutta in a Box',
  ),
  MenuItem(
<<<<<<< HEAD
    id: 29,
=======
    id: 34,
>>>>>>> ee47cadfc7141dbdf450a21f77a6f5469d4e36f9
    name: 'OMLATE',
    description: 'Omlate',
    price: 15,
    imageUrl: 'https://via.placeholder.com/150',
    category: 'Calcutta in a Box',
  ),
  MenuItem(
<<<<<<< HEAD
    id: 30,
=======
    id: 35,
>>>>>>> ee47cadfc7141dbdf450a21f77a6f5469d4e36f9
    name: 'BREAD OMLATE',
    description: 'Bread omlate',
    price: 35,
    imageUrl: 'https://via.placeholder.com/150',
    category: 'Calcutta in a Box',
  ),
  MenuItem(
<<<<<<< HEAD
    id: 31,
=======
    id: 36,
>>>>>>> ee47cadfc7141dbdf450a21f77a6f5469d4e36f9
    name: 'VEG S.W',
    description: 'Veg sandwich',
    price: 25,
    imageUrl: 'https://via.placeholder.com/150',
    category: 'Calcutta in a Box',
  ),
  MenuItem(
<<<<<<< HEAD
    id: 32,
=======
    id: 37,
>>>>>>> ee47cadfc7141dbdf450a21f77a6f5469d4e36f9
    name: 'CHEESE SW',
    description: 'Cheese sandwich',
    price: 40,
    imageUrl: 'https://via.placeholder.com/150',
    category: 'Calcutta in a Box',
  ),
  MenuItem(
<<<<<<< HEAD
    id: 33,
=======
    id: 38,
>>>>>>> ee47cadfc7141dbdf450a21f77a6f5469d4e36f9
    name: 'CHOCO CHEESE -S/W',
    description: 'Choco cheese sandwich',
    price: 50,
    imageUrl: 'https://via.placeholder.com/150',
    category: 'Calcutta in a Box',
  ),
  MenuItem(
<<<<<<< HEAD
    id: 34,
=======
    id: 39,
>>>>>>> ee47cadfc7141dbdf450a21f77a6f5469d4e36f9
    name: 'EGG PODIMASS',
    description: 'Egg podimass',
    price: 30,
    imageUrl: 'https://via.placeholder.com/150',
    category: 'Calcutta in a Box',
  ),
  MenuItem(
<<<<<<< HEAD
    id: 35,
=======
    id: 40,
>>>>>>> ee47cadfc7141dbdf450a21f77a6f5469d4e36f9
    name: 'GOBI FRY',
    description: 'Gobi fry',
    price: 40,
    imageUrl: 'https://via.placeholder.com/150',
    category: 'Calcutta in a Box',
  ),
  MenuItem(
<<<<<<< HEAD
    id: 36,
=======
    id: 41,
>>>>>>> ee47cadfc7141dbdf450a21f77a6f5469d4e36f9
    name: 'VEG MAGGI',
    description: 'Veg maggi',
    price: 30,
    imageUrl: 'https://via.placeholder.com/150',
    category: 'Calcutta in a Box',
  ),
  MenuItem(
<<<<<<< HEAD
    id: 37,
=======
    id: 42,
>>>>>>> ee47cadfc7141dbdf450a21f77a6f5469d4e36f9
    name: 'EGG MAGGI',
    description: 'Egg maggi',
    price: 40,
    imageUrl: 'https://via.placeholder.com/150',
    category: 'Calcutta in a Box',
  ),
  MenuItem(
<<<<<<< HEAD
    id: 38,
=======
    id: 43,
>>>>>>> ee47cadfc7141dbdf450a21f77a6f5469d4e36f9
    name: 'VIG PIZZA',
    description: 'Veg pizza',
    price: 50,
    imageUrl: 'https://via.placeholder.com/150',
    category: 'Calcutta in a Box',
  ),
  MenuItem(
<<<<<<< HEAD
    id: 39,
=======
    id: 44,
>>>>>>> ee47cadfc7141dbdf450a21f77a6f5469d4e36f9
    name: 'CHEESE PIZZA',
    description: 'Cheese pizza',
    price: 70,
    imageUrl: 'https://via.placeholder.com/150',
    category: 'Calcutta in a Box',
  ),
  MenuItem(
<<<<<<< HEAD
    id: 40,
=======
    id: 45,
>>>>>>> ee47cadfc7141dbdf450a21f77a6f5469d4e36f9
    name: 'MOMOS -VEG',
    description: 'Veg momos',
    price: 60,
    imageUrl: 'https://via.placeholder.com/150',
    category: 'Calcutta in a Box',
  ),
  MenuItem(
<<<<<<< HEAD
    id: 41,
=======
    id: 46,
>>>>>>> ee47cadfc7141dbdf450a21f77a6f5469d4e36f9
    name: 'MOMOS -PANEER',
    description: 'Paneer momos',
    price: 70,
    imageUrl: 'https://via.placeholder.com/150',
    category: 'Calcutta in a Box',
  ),
  MenuItem(
<<<<<<< HEAD
    id: 42,
=======
    id: 47,
>>>>>>> ee47cadfc7141dbdf450a21f77a6f5469d4e36f9
    name: 'POTATO WEDGES',
    description: 'Potato wedges',
    price: 60,
    imageUrl: 'https://via.placeholder.com/150',
    category: 'Calcutta in a Box',
  ),
  MenuItem(
<<<<<<< HEAD
    id: 43,
=======
    id: 48,
>>>>>>> ee47cadfc7141dbdf450a21f77a6f5469d4e36f9
    name: 'SMILLY POTATO',
    description: 'Smilly potato',
    price: 50,
    imageUrl: 'https://via.placeholder.com/150',
    category: 'Calcutta in a Box',
  ),
  MenuItem(
<<<<<<< HEAD
    id: 44,
=======
    id: 49,
>>>>>>> ee47cadfc7141dbdf450a21f77a6f5469d4e36f9
    name: 'VEG NUGGETS',
    description: 'Veg nuggets',
    price: 50,
    imageUrl: 'https://via.placeholder.com/150',
    category: 'Calcutta in a Box',
  ),
  MenuItem(
<<<<<<< HEAD
    id: 45,
=======
    id: 50,
>>>>>>> ee47cadfc7141dbdf450a21f77a6f5469d4e36f9
    name: 'FRENCH FRIES',
    description: 'French fries',
    price: 50,
    imageUrl: 'https://via.placeholder.com/150',
    category: 'Calcutta in a Box',
  ),
  MenuItem(
<<<<<<< HEAD
    id: 46,
=======
    id: 51,
>>>>>>> ee47cadfc7141dbdf450a21f77a6f5469d4e36f9
    name: 'PERI PERI FRIES',
    description: 'Peri peri fries',
    price: 60,
    imageUrl: 'https://via.placeholder.com/150',
    category: 'Calcutta in a Box',
  ),
  MenuItem(
<<<<<<< HEAD
    id: 47,
=======
    id: 52,
>>>>>>> ee47cadfc7141dbdf450a21f77a6f5469d4e36f9
    name: 'LAYS',
    description: 'Lays chips',
    price: 20,
    imageUrl: 'https://via.placeholder.com/150',
    category: 'Calcutta in a Box',
  ),
  MenuItem(
<<<<<<< HEAD
    id: 48,
=======
    id: 53,
>>>>>>> ee47cadfc7141dbdf450a21f77a6f5469d4e36f9
    name: 'KURKURE',
    description: 'Kurkure',
    price: 20,
    imageUrl: 'https://via.placeholder.com/150',
    category: 'Calcutta in a Box',
  ),
  MenuItem(
<<<<<<< HEAD
    id: 49,
=======
    id: 54,
>>>>>>> ee47cadfc7141dbdf450a21f77a6f5469d4e36f9
    name: 'SUNDAL',
    description: 'Sundal',
    price: 15,
    imageUrl: 'https://via.placeholder.com/150',
    category: 'Calcutta in a Box',
  ),
  MenuItem(
<<<<<<< HEAD
    id: 50,
=======
    id: 55,
>>>>>>> ee47cadfc7141dbdf450a21f77a6f5469d4e36f9
    name: 'SWEET CORN',
    description: 'Sweet corn',
    price: 20,
    imageUrl: 'https://via.placeholder.com/150',
    category: 'Calcutta in a Box',
  ),
  MenuItem(
<<<<<<< HEAD
    id: 51,
=======
    id: 56,
>>>>>>> ee47cadfc7141dbdf450a21f77a6f5469d4e36f9
    name: 'BISCUIT',
    description: 'Biscuit',
    price: 10,
    imageUrl: 'https://via.placeholder.com/150',
    category: 'Calcutta in a Box',
  ),
  MenuItem(
<<<<<<< HEAD
    id: 52,
=======
    id: 57,
>>>>>>> ee47cadfc7141dbdf450a21f77a6f5469d4e36f9
    name: 'BAJJI',
    description: 'Bajji',
    price: 20,
    imageUrl: 'https://via.placeholder.com/150',
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
<<<<<<< HEAD
=======
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
>>>>>>> ee47cadfc7141dbdf450a21f77a6f5469d4e36f9
} 