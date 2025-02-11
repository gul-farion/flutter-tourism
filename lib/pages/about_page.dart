import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("О нас"), backgroundColor: Colors.blueAccent, foregroundColor: Colors.white, titleTextStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Секция 1: Статистика
            _buildSection(
              context,
              image: "https://images.unsplash.com/photo-1454496522488-7a8e488e8606?q=80&w=1776&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
              title: "Біздің статистика",
              content: "✅ 10+ жыл жұмыс\n✅ 5000+ қолданушылар\n✅ 200+ бірегей турлар",
              buttonText: "Турларға шолу",
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/home');
              },
            ),

            // Секция 2: Опыт работы
            _buildSection(
              context,
              image: "https://images.unsplash.com/photo-1516132006923-6cf348e5dee2?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
              title: "Біздің тәжірибеміз",
              content: "Біз тек кәсіби гидтермен жұмыс істейміз және жыл сайын жаңа бағыттарды ашамыз!",
              buttonText: "Турлар",
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/home');
              },
            ),

            // Секция 3: Успешные кейсы
            _buildSection(
              context,
              image: "https://images.unsplash.com/photo-1549615558-a2e10948ad3b?q=80&w=1770&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
              title: "Сәтті кейстер",
              content: "🔹 Клиенттердің 80% қайта оралады\n🔹 95% жағымды пікірлер",
              buttonText: "Пікірлерді оқыңыз",
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/home');
              },
            ),
            _buildSection(
              context,
              image: "https://images.unsplash.com/photo-1565964135469-fbd674159289?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
              title: "Қандай тур алуды білмейсіз ба?",
              content: "🔹 Біз сізге көмектесеміз! Операторларымыз сізге жақымды ең жақсы турларды таңдап бере алады!",
              buttonText: "Бізбен байланысу",
              onPressed: () {
                _showTourSelectionModal(context);
              },
            ),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context,
      {required String image, required String title, required String content, required String buttonText, required VoidCallback onPressed}) {
    return Stack(
      children: [
        // Фоновое изображение
        Container(
          height: 800,
          decoration: BoxDecoration(
            image: DecorationImage(image: NetworkImage(image), fit: BoxFit.cover),
          ),
        ),
        // Затемнение
        Container(height: 800, color: Colors.black.withOpacity(0.5)),
        // Контент
        Center(
          child: Container(
            height: 800,
            padding: const EdgeInsets.all(16),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title, style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 8),
                Text(content, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, color: Colors.white)),
                const SizedBox(height: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                  onPressed: onPressed,
                  child: Text(buttonText, style: const TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showTourSelectionModal(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom, left: 16, right: 16, top: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Форманы толтырыңыз", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Атыңыз"),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: "Телефон нөмірі"),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                onPressed: () {
                  // Действие при отправке формы
                  Navigator.pop(context);
                },
                child: const Text("Сұранысты жіберу", style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFooter() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        color: Colors.blueGrey[900],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Бізбен байланыс", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text("📍 Адрес: ул. Турагентская, 45, г. Алматы", style: TextStyle(color: Colors.white70)),
            const Text("📞 Телефон: +7 (777) 123-45-67", style: TextStyle(color: Colors.white70)),
            const Text("✉ Email: contact@tours.kz", style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 16),
            Row(
              children: [
                IconButton(icon: const Icon(Icons.facebook, color: Colors.white), onPressed: () {}),
                IconButton(icon: const Icon(Icons.telegram, color: Colors.white), onPressed: () {}),
                IconButton(icon: const Icon(Icons.airplane_ticket, color: Colors.white), onPressed: () {}),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(color: Colors.white38),
            const SizedBox(height: 10),
            const Center(child: Text("© 2025 ht.kz. Барлық құқық қорғалған.", style: TextStyle(color: Colors.white70))),
          ],
        ),
      ),
    );
  }
}
