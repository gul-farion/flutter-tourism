import 'package:flutter/material.dart';
import '../models/food_item.dart';
import '../models/tour.dart';

class CartProvider extends ChangeNotifier {
  final Map<dynamic, int> _items = {}; // Может хранить и FoodItem, и Tour

  // Получение списка всех предметов в корзине
  List<dynamic> get items => _items.keys.toList();

  // Получение количества конкретного предмета
  int getQuantity(dynamic item) => _items[item] ?? 0;

  // Расчет общей стоимости корзины
  double get totalPrice {
    return _items.entries
        .map((entry) {
          if (entry.key is FoodItem) {
            return (entry.key as FoodItem).price * entry.value;
          } else if (entry.key is Tour) {
            return (entry.key as Tour).price * entry.value;
          }
          return 0.0;
        })
        .fold(0.0, (sum, item) => sum + item);
  }

  // Добавление предмета в корзину (работает и для FoodItem, и для Tour)
  void addItem(dynamic item) {
    if (item is! FoodItem && item is! Tour) return;

    if (_items.containsKey(item)) {
      _items[item] = _items[item]! + 1;
    } else {
      _items[item] = 1;
    }
    notifyListeners();
  }

  // Удаление одного экземпляра предмета
  void removeSingleItem(dynamic item) {
    if (_items.containsKey(item)) {
      if (_items[item]! > 1) {
        _items[item] = _items[item]! - 1;
      } else {
        _items.remove(item);
      }
    }
    notifyListeners();
  }

  // Удаление предмета полностью
  void removeItem(dynamic item) {
    if (_items.containsKey(item)) {
      _items.remove(item);
      notifyListeners();
    }
  }

  // Обновление количества конкретного предмета
  void updateItemQuantity(dynamic item, int quantity) {
    if (quantity <= 0) {
      removeItem(item); // Удаление предмета, если количество меньше или равно 0
    } else {
      _items[item] = quantity;
    }
    notifyListeners();
  }

  // Проверка, находится ли предмет в корзине
  bool hasItem(dynamic item) => _items.containsKey(item);

  // Подсчет общего количества предметов в корзине
  int get itemCount {
    return _items.values.fold(0, (sum, quantity) => sum + quantity);
  }

  // Очистка всей корзины
  void clear() {
    _items.clear();
    notifyListeners();
  }
}
