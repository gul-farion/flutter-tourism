class Tour {
  final String name;
  final String location;
  final String description;
  final int price;
  final String imageUrl;
  final double rating;
  final String category;

  Tour({
    required this.name,
    required this.location,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.rating,
    required this.category
  });

  factory Tour.fromMap(Map<String, dynamic> data) {
    return Tour(
      name: data['name'],
      category: data['category'],
      location: data['location'],
      description: data['description'],
      price: (data['price'] as num).toInt(),
      imageUrl: data['imageUrl'],
      rating: (data['rating'] as num).toDouble(),
    );
  }
}
