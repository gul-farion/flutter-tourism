import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:pizzeria_app/widgets/topbar.dart';
import 'package:provider/provider.dart';
import '../providers/category_provider.dart';
import '../providers/tour_provider.dart';
import '../widgets/tour_grid.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final categoryProvider =
          Provider.of<CategoryProvider>(context, listen: false);
      final tourProvider = Provider.of<TourProvider>(context, listen: false);

      categoryProvider.fetchCategories().then((_) {
        if (categoryProvider.selectedCategory != null) {
          tourProvider.fetchTours(categoryProvider.selectedCategory!);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final tourProvider = Provider.of<TourProvider>(context);

    return Scaffold(
      appBar: const Topbar(),
      drawer: const AppDrawer(),
      backgroundColor: Colors.white,
      body: Row(
        children: [
          // Sidebar (Filters) - 30% width
          Expanded(
            flex: 2,
            child: Container(
              // color: Colors.grey[200],
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Тур фильтрлары",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Open Sans'),
                  ),
                  const SizedBox(height: 16),

                  categoryProvider.isLoading
                      ? const CircularProgressIndicator()
                      : DropdownButtonFormField<String>(
                          value: categoryProvider.selectedCategory,
                          items: categoryProvider.categories
                              .map((category) => DropdownMenuItem<String>(
                                    value: category['title'],
                                    child: Text(
                                      category['title'],
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ))
                              .toList(),
                          onChanged: (value) async {
                            categoryProvider.setCategory(value!);
                            await tourProvider.fetchTours(value);
                          },
                          decoration: const InputDecoration(
                            labelText: "Категорияны таңдаңыз",
                            border: OutlineInputBorder(),
                          ),
                        ),

                  const SizedBox(height: 16),

                  // Filter by rating
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Фильтр по рейтингу
                      const Text("Рейтинг", style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Raleway"),),
                      Slider(
                        thumbColor: Colors.blueAccent,
                        activeColor: Colors.blueAccent,
                        value: tourProvider.minRating,
                        min: 1,
                        
                        max: 5,
                        divisions: 4,
                        label: "${tourProvider.minRating.toInt()}+",
                        onChanged: (value) {
                          tourProvider.updateMinRating(value);
                        },
                      ),

                      const SizedBox(height: 16),

                      // Фильтр по цене
                      const Text("Баға диапазоны", style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Raleway"),),
                      RangeSlider(
                        activeColor: Colors.blueAccent,

                        values: tourProvider.priceRange,
                        min: 30000,
                        max: 1000000,
                        divisions: 18,
                        labels: RangeLabels(
                          "${tourProvider.priceRange.start.toInt()} ₸",
                          "${tourProvider.priceRange.end.toInt()} ₸",
                        ),
                        onChanged: (values) {
                          tourProvider.updatePriceRange(values);
                        },
                      ),

                      const SizedBox(height: 16),

                      // Кнопка применения фильтра
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            tourProvider.applyFilters();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text("Фильтрды қолдану"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            flex: 7,
            child: Container(
              padding: const EdgeInsets.all(16),
              child: tourProvider.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : tourProvider.tours.isEmpty
                      ? const Center(
                          child: Text(
                            "Сіз іздеген турлар әзірге жоқ :(",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : TourGrid(tours: tourProvider.tours),
            ),
          ),
        ],
      ),
    );
  }
}
