import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoritesProvider extends ChangeNotifier {
  List<String> _favoriteTours = [];

  List<String> get favoriteTours => _favoriteTours;

  int get favoritesCount => _favoriteTours.length;

  Future<void> fetchFavorites() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('favorites')
          .get();
      _favoriteTours = snapshot.docs.map((doc) => doc.id).toList();
      notifyListeners();
    } catch (e) {
      print('Error fetching favorites: $e');
    }
  }

  Future<void> toggleFavorite(String tourId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .doc(tourId);

    if (_favoriteTours.contains(tourId)) {
      await docRef.delete();
      _favoriteTours.remove(tourId);
    } else {
      await docRef.set({});
      _favoriteTours.add(tourId);
    }
    notifyListeners();
  }
  bool isFavorite(String tourId) {
    return _favoriteTours.contains(tourId);
  }
}
