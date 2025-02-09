import 'package:flutter/material.dart';
import '../models/tour.dart';
import '../pages/tour_detail_page.dart';

class TourGrid extends StatelessWidget {
  final List<Tour> tours;

  const TourGrid({super.key, required this.tours});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tours.length,
      itemBuilder: (context, index) {
        final tour = tours[index];

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
                    width: 150,
                    height: 120,
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
                        Text(
                          tour.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          tour.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "${tour.price} ₸",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
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
