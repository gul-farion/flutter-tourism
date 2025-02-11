import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _tourNameController = TextEditingController();
  final TextEditingController _tourDescriptionController =
      TextEditingController();
  final TextEditingController _tourPriceController = TextEditingController();
  final TextEditingController _tourImageController = TextEditingController();
  String? _selectedCategory;

  final TextEditingController _editNameController = TextEditingController();
  final TextEditingController _editDescriptionController =
      TextEditingController();
  final TextEditingController _editPriceController = TextEditingController();
  final TextEditingController _editImageController = TextEditingController();
  final TextEditingController _tourDurationController = TextEditingController();
  final TextEditingController _tourRatingController = TextEditingController();

// Temporary controllers for editing
  final TextEditingController _editDurationController = TextEditingController();
  final TextEditingController _editRatingController = TextEditingController();

  String? _editCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xff0A78D6),
        title: const Text(
          "Турларды және категорияларды басқару",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCategoryManagement(),
            const SizedBox(height: 32),
            _buildTourManagement(),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryManagement() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Категорияларды басқару",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _categoryController,
                decoration: const InputDecoration(
                  labelText: "Жаңа категория қосу",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: _addCategory,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff0A78D6),
                foregroundColor: Colors.white,
              ),
              child: const Text("Қосу"),
            ),
          ],
        ),
        const SizedBox(height: 16),
        StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance.collection('categories').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Text("Категориялар жоқ.");
            }
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final doc = snapshot.data!.docs[index];
                return ListTile(
                  title: Text(doc['title']),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteCategory(doc.id),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildTourManagement() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Турларды басқару",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        FutureBuilder<List<DropdownMenuItem<String>>>(
          future: _getCategoryDropdownItems(),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text("Категорияларды жазуда қателік кетті");
            }
            return DropdownButtonFormField<String>(
              value: _selectedCategory,
              hint: const Text("Категорияны таңдаңыз"),
              items: snapshot.data,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                });
              },
            );
          },
        ),
        const SizedBox(height: 16),
        _buildTextField(_tourNameController, "Тур аты"),
        _buildTextField(_tourDescriptionController, "Тур сипаттамасы"),
        _buildTextField(_tourPriceController, "Тур бағасы",
            inputType: TextInputType.number),
        _buildTextField(_tourImageController, "Тур суретінің URL сілтемесі"),
        _buildTextField(_tourDurationController, "Тур ұзақтылығы"),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _addTour,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xff0A78D6),
            foregroundColor: Colors.white,
          ),
          child: const Text("Тур қосу"),
        ),
        const SizedBox(height: 16),
        const Text("Барлық турлар", style: TextStyle(fontSize: 24)),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('tours').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Text("Турлар жоқ.");
            }
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final doc = snapshot.data!.docs[index];
                return ListTile(
                  leading: Image.network(
                    doc['imageUrl'],
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(doc['name']),
                  subtitle: Text("${doc['price']} ₸"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _editTour(doc),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteTour(doc.id),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {TextInputType inputType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: controller,
        keyboardType: inputType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Future<List<DropdownMenuItem<String>>> _getCategoryDropdownItems() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('categories').get();
    return snapshot.docs
        .map((doc) => DropdownMenuItem<String>(
              value: doc['title'],
              child: Text(doc['title']),
            ))
        .toList();
  }

  Future<void> _addCategory() async {
    final title = _categoryController.text.trim();
    if (title.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('categories')
          .add({'title': title});
      _categoryController.clear();
    }
  }

  Future<void> _deleteCategory(String id) async {
    await FirebaseFirestore.instance.collection('categories').doc(id).delete();
  }

  Future<void> _addTour() async {
    final name = _tourNameController.text.trim();
    final description = _tourDescriptionController.text.trim();
    final price = double.tryParse(_tourPriceController.text.trim());
    final imageUrl = _tourImageController.text.trim();
    final category = _selectedCategory;
    final duration = _tourDurationController.text.trim();
    final rating = double.tryParse(_tourRatingController.text.trim()) ?? 0.0;

    if (name.isNotEmpty &&
        description.isNotEmpty &&
        price != null &&
        imageUrl.isNotEmpty &&
        category != null &&
        duration.isNotEmpty) {
      await FirebaseFirestore.instance.collection('tours').add({
        'name': name,
        'description': description,
        'price': price,
        'imageUrl': imageUrl,
        'category': category,
        'duration': duration,
        'rating': rating,
      });
      _clearTourFields();
    }
  }

  void _clearTourFields() {
    _tourNameController.clear();
    _tourDescriptionController.clear();
    _tourPriceController.clear();
    _tourImageController.clear();
    _tourDurationController.clear();
    _tourRatingController.clear();
    _selectedCategory = null;
  }

  Future<void> _deleteTour(String id) async {
    await FirebaseFirestore.instance.collection('tours').doc(id).delete();
  }

  void _editTour(DocumentSnapshot tour) {
    _editNameController.text = tour['name'];
    _editDescriptionController.text = tour['description'];
    _editPriceController.text = tour['price'].toString();
    _editImageController.text = tour['imageUrl'];
    _editCategory = tour['category'];
    _editDurationController.text = tour['duration'];
    _editRatingController.text = tour['rating'].toString();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Турды өңдеу"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _editNameController,
                  decoration: const InputDecoration(
                      labelText: "Тур атауы", border: OutlineInputBorder()),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _editDescriptionController,
                  decoration: const InputDecoration(
                      labelText: "Тур сипаттамасы",
                      border: OutlineInputBorder()),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _editPriceController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                      labelText: "Бағасы (₸)", border: OutlineInputBorder()),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _editImageController,
                  decoration: const InputDecoration(
                      labelText: "Сурет URL", border: OutlineInputBorder()),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _editDurationController,
                  decoration: const InputDecoration(
                      labelText: "Тур ұзақтығы", border: OutlineInputBorder()),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _editRatingController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      labelText: "Рейтинг (0.0 - 5.0)",
                      border: OutlineInputBorder()),
                ),
                const SizedBox(height: 8),
                FutureBuilder<List<DropdownMenuItem<String>>>(
                  future: _getCategoryDropdownItems(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Text("Категориялар жоқ");
                    }
                    return DropdownButtonFormField<String>(
                      value: _editCategory,
                      hint: const Text("Категорияны таңдаңыз"),
                      items: snapshot.data,
                      onChanged: (value) {
                        setState(() {
                          _editCategory = value;
                        });
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Болдырмау"),
            ),
            ElevatedButton(
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('tours')
                    .doc(tour.id)
                    .update({
                  'name': _editNameController.text,
                  'description': _editDescriptionController.text,
                  'price': double.parse(_editPriceController.text),
                  'image': _editImageController.text,
                  'category': _editCategory,
                  'duration': _editDurationController.text,
                  'rating': double.parse(_editRatingController.text),
                });
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff0A78D6),
                foregroundColor: Colors.white,
              ),
              child: const Text("Сақтау"),
            ),
          ],
        );
      },
    );
  }
}
