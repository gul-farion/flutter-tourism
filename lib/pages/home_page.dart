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
    final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
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
      
      body: Row(
        children: [
          // Sidebar (Filters) - 30% width
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.grey[200],
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Фильтр туров",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Open Sans'
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Dropdown for selecting a category
                  categoryProvider.isLoading
                      ? const CircularProgressIndicator()
                      : DropdownButtonFormField<String>(
                          value: categoryProvider.selectedCategory,
                          items: categoryProvider.categories
                              .map((category) => DropdownMenuItem<String>(
                                    value: category['title'],
                                    child: Text(category['title']),
                                  )).toList(),
                          onChanged: (value) {
                            categoryProvider.setCategory(value!);
                            tourProvider.fetchTours(value);
                          },
                          decoration: const InputDecoration(
                            labelText: "Выберите категорию",
                            border: OutlineInputBorder(),
                          ),
                        ),

                  const SizedBox(height: 16),

                  // Filter by rating
                  const Text("Минимальный рейтинг"),
                  Slider(
                    value: 3, // Placeholder value
                    min: 1,
                    max: 5,
                    divisions: 4,
                    label: "3+",
                    onChanged: (value) {},
                  ),

                  const SizedBox(height: 16),

                  // Filter by price range
                  const Text("Диапазон цен"),
                  RangeSlider(
                    values: const RangeValues(10000, 50000), // Placeholder values
                    min: 5000,
                    max: 100000,
                    divisions: 10,
                    labels: const RangeLabels("10,000 ₸", "50,000 ₸"),
                    onChanged: (values) {},
                  ),

                  const SizedBox(height: 16),

                  // Apply filters button
                  ElevatedButton(
                    onPressed: () {
                      // Apply filtering logic
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Применить фильтр"),
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
                  ? const Center(child: CircularProgressIndicator())
                  : TourGrid(tours: tourProvider.tours),
            ),
          ),
        ],
      ),
    );
  }
}
