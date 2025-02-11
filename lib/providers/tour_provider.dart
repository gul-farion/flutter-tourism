import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/tour.dart';

class TourProvider extends ChangeNotifier {
  List<Tour> _allTours = []; // Все туры
  List<Tour> _filteredTours = []; // Отфильтрованные туры
  bool _isLoading = false;

  double _minRating = 3; // Минимальный рейтинг
  RangeValues _priceRange = const RangeValues(30000, 1000000); // Диапазон цен

  List<Tour> get tours => _filteredTours;
  bool get isLoading => _isLoading;
  double get minRating => _minRating;
  RangeValues get priceRange => _priceRange;

  Future<void> fetchTours(String category) async {
    _isLoading = true;
    notifyListeners();

    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('tours')
          .where('category', isEqualTo: category)
          .get();

      _allTours = snapshot.docs.map((doc) {
        return Tour(
          name: doc['name'],
          description: doc['description'],
          price: doc['price'],
          imageUrl: doc['imageUrl'],
          rating: doc['rating'] ?? 0,
          category: doc['category'],
          location: doc['location'],
        );
      }).toList();

      applyFilters();
    } catch (e) {
      print("Error fetching tours: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  void updateMinRating(double value) {
    _minRating = value;
    notifyListeners();
  }

  void updatePriceRange(RangeValues values) {
    _priceRange = values;
    notifyListeners();
  }

  void applyFilters() {
    _filteredTours = _allTours.where((tour) {
      return tour.rating >= _minRating &&
          tour.price >= _priceRange.start &&
          tour.price <= _priceRange.end;
    }).toList();
    notifyListeners();
  }
}
