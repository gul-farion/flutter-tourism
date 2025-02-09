import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _categories = [];
  String? _selectedCategory;
  bool _isLoading = false;

  List<Map<String, dynamic>> get categories => _categories;
  String? get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;

  Future<void> fetchCategories() async {
    _isLoading = true;
    notifyListeners();

    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('categories').get();
      _categories = snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'title': doc['title'],
        };
      }).toList();

      if (_categories.isNotEmpty) {
        _selectedCategory = _categories[0]['title']; // Выбираем первую категорию
      }

      print("Fetched ${_categories.length} categories from Firestore");
    } catch (e) {
      print("Error fetching categories: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }
}
