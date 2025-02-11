import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/tour.dart';
import '../pages/tour_detail_page.dart';
import '../providers/cart_provider.dart';

class TourGrid extends StatelessWidget {
  final List<Tour> tours;

  const TourGrid({super.key, required this.tours});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tours.length,
      itemBuilder: (context, index) {
        final tour = tours[index];
        final isFavorite = cartProvider.items.contains(tour); // Проверяем, есть ли тур в корзине

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TourDetailPage(tour: tour),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.black87),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tour Image (Left Side)
                ClipRRect(
                  borderRadius: const BorderRadius.horizontal(left: Radius.circular(12)),
                  child: Image.network(
                    tour.imageUrl,
                    width: 250,
                    height: 190,
                    fit: BoxFit.cover,
                  ),
                ),

                // Tour Info (Right Side)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                tour.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                isFavorite ? Icons.favorite : Icons.favorite_border,
                                color: isFavorite ? Colors.red : Colors.grey,
                              ),
                              onPressed: () {
                                if (isFavorite) {
                                  cartProvider.removeItem(tour);
                                } else {
                                  cartProvider.addItem(tour);
                                }
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          tour.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 14, color: Colors.grey, fontFamily: 'Inter'),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Тур бағасы: ${tour.price} ₸",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),

                        // Rating Indicator
                        const SizedBox(height: 8),
                        Row(
                          children: List.generate(
                            5,
                            (starIndex) => Icon(
                              starIndex < tour.rating.round() ? Icons.star : Icons.star_border,
                              color: Colors.yellow,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
