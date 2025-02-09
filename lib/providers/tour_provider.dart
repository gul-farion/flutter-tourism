import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/tour.dart';

class TourProvider extends ChangeNotifier {
  List<Tour> _tours = [];
  bool _isLoading = false;

  List<Tour> get tours => _tours;
  bool get isLoading => _isLoading;

  Future<void> fetchTours(String category) async {
    _isLoading = true;
    notifyListeners();

    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('tours')
          .where('category', isEqualTo: category) // Фильтр по категории
          .get();

      _tours = snapshot.docs.map((doc) {
        return Tour(
          // id: doc.id,
          name: doc['name'],
          description: doc['description'],
          price: doc['price'],
          imageUrl: doc['imageUrl'],
          rating: doc['rating'] ?? 0,
          category: doc['category'],
          location: doc['location'],
        );
      }).toList();

      print("Fetched ${_tours.length} tours from Firestore"); // Debug log
    } catch (e) {
      print("Error fetching tours: $e");
    }

    _isLoading = false;
    notifyListeners();
  }
}
