class FoodItem {
  final String name;
  final String body;
  final double price;
  final String imageUrl;
  final double rating;
  final List<String> sizes;
  String? selectedSize;

  FoodItem({
    required this.name,
    required this.body,
    required this.price,
    required this.imageUrl,
    required this.rating,
    this.sizes = const [],
    this.selectedSize
  });
}
