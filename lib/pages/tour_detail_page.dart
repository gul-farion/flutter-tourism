import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/tour.dart';

class TourDetailPage extends StatefulWidget {
  final Tour tour;

  const TourDetailPage({super.key, required this.tour});

  @override
  _TourDetailPageState createState() => _TourDetailPageState();
}

class _TourDetailPageState extends State<TourDetailPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nationalityController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _numPeopleController = TextEditingController();
  DateTime? _selectedDate;
  int _touristsCount = 1;
  bool _isFormValid = false;

  void _validateForm() {
    setState(() {
      _isFormValid = _formKey.currentState?.validate() ?? false;
    });
  }

 Future<void> _submitRequest() async {
  if (!_formKey.currentState!.validate()) return;

  final requestData = {
    "name": _nameController.text,
    "surname": _surnameController.text,
    "email": _emailController.text,
    "nationality": _nationalityController.text,
    "numPeople": int.parse(_numPeopleController.text), // Добавлено количество людей
    "message": _messageController.text,
    "status": "Активный",
    "userId": FirebaseAuth.instance.currentUser!.uid,
  };

  await FirebaseFirestore.instance.collection('user_orders').add(requestData);

  // Очистка полей после отправки
  _nameController.clear();
  _surnameController.clear();
  _emailController.clear();
  _nationalityController.clear();
  _numPeopleController.clear();
  _messageController.clear();

  setState(() {
    _isFormValid = false;
  });

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text("Сұраныс сәтті жіберілді!")),
  );
}

  @override
void dispose() {
  _nameController.dispose();
  _surnameController.dispose();
  _emailController.dispose();
  _nationalityController.dispose();
  _messageController.dispose();
  _numPeopleController.dispose(); // Очистка контроллера
  super.dispose();
}


  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Сұраныс жіберілді"),
        content: const Text(
            "Сіздің сұранысыңыз сәтті жіберілді! Біз сізбен жақын арада байланысамыз.\n\nСервис нөмірі: +7 (777) 123-45-67"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("ОК"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.tour.name),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    widget.tour.imageUrl,
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: 300,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.tour.name,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.location_on, color: Colors.redAccent),
                          Text(
                            widget.tour.location,
                            style: TextStyle(fontSize: 16, color: Colors.grey[850]),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.yellow),
                          Text("${widget.tour.rating} / 5.0"),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Тур туралы ақпарат",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.tour.description,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Бағасы: ${widget.tour.price.toStringAsFixed(2)} ₸",
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Блок статичных отзывов
            const Center(
              child: Text("Пікірлер",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Center(
                child: SizedBox(
                  height: 100,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: const [
                      _ReviewCard(
                          author: "Айжан",
                          text:
                              "Керемет тур, бәрі жоғары деңгейде ұйымдастырылған!"),
                      _ReviewCard(
                          author: "Ермек",
                          text:
                              "Ғажайып орындар! Осындай мүмкіндіктерді жиі ұсынып тұрсаңыздар!"),
                      _ReviewCard(
                          author: "Дана",
                          text: "Бәрі керемет! Қызмет көрсету де өте жақсы!"),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blueAccent),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Form(
  key: _formKey,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        "Сұраныс формасын толтырыңыз",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 16),
      Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Аты"),
              validator: (value) =>
                  value!.isEmpty ? "Атыңызды енгізіңіз" : null,
              onChanged: (_) => _validateForm(),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: TextFormField(
              controller: _surnameController,
              decoration: const InputDecoration(labelText: "Тегі"),
              validator: (value) =>
                  value!.isEmpty ? "Тегіңізді енгізіңіз" : null,
              onChanged: (_) => _validateForm(),
            ),
          ),
        ],
      ),
      const SizedBox(height: 8),
      Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Электронды пошта"),
              validator: (value) =>
                  value!.isEmpty ? "Поштаңызды енгізіңіз" : null,
              onChanged: (_) => _validateForm(),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: TextFormField(
              controller: _nationalityController,
              decoration: const InputDecoration(labelText: "Азаматтығы"),
              validator: (value) =>
                  value!.isEmpty ? "Еліңізді енгізіңіз" : null,
              onChanged: (_) => _validateForm(),
            ),
          ),
        ],
      ),
      const SizedBox(height: 8),
      TextFormField(
        controller: _numPeopleController,
        decoration: const InputDecoration(labelText: "Адам саны"),
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value!.isEmpty) {
            return "Адам санын енгізіңіз";
          }
          if (int.tryParse(value) == null || int.parse(value) <= 0) {
            return "Дұрыс сан енгізіңіз";
          }
          return null;
        },
        onChanged: (_) => _validateForm(),
      ),
      const SizedBox(height: 8),
      TextFormField(
        controller: _messageController,
        decoration: const InputDecoration(labelText: "Хабарлама (міндетті емес)"),
      ),
      const SizedBox(height: 16),
      ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
        onPressed: _isFormValid ? _submitRequest : null,
        child: const Text(
          "Сұраныс жіберу",
          style: TextStyle(color: Colors.white),
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
  }
}

class _ReviewCard extends StatelessWidget {
  final String author;
  final String text;

  const _ReviewCard({required this.author, required this.text});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(right: 100),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(author,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: "Raleway",
                    fontSize: 16)),
            Text(text,
                style: const TextStyle(
                    fontSize: 12,
                    fontFamily: "Raleway",
                    fontWeight: FontWeight.w400)),
          ],
        ),
      ),
    );
  }
}
