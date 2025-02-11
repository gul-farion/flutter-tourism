import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final User? user = FirebaseAuth.instance.currentUser;
  List<Map<String, dynamic>> activeRequests = [];

  @override
  void initState() {
    super.initState();
    fetchActiveRequests();
  }

  Future<void> fetchActiveRequests() async {
    if (user == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection('user_orders')
        .where('userId', isEqualTo: user!.uid)
        .where('status', isEqualTo: 'Активный')
        .get();

    setState(() {
      activeRequests = snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
    });
  }

  Future<void> deleteRequest(String requestId) async {
    await FirebaseFirestore.instance.collection('user_orders').doc(requestId).delete();
    fetchActiveRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Менің аккаунтым"), backgroundColor: const Color(0xff0A78D6), foregroundColor: Colors.white,),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Активті сұраныстар", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            activeRequests.isEmpty
                ? const Center(child: Text("Сізде әзірге сұраныстар жоқ."))
                : Expanded(
                    child: ListView.builder(
                      itemCount: activeRequests.length,
                      itemBuilder: (context, index) {
                        final request = activeRequests[index];
                        return Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: request['tourImage'] != null
                                ? Image.network(request['tourImage'], width: 60, height: 60, fit: BoxFit.cover)
                                : const Icon(Icons.image, size: 60),
                            title: Text(request['tourName'] ?? "Белгісіз тур"),
                            subtitle: Text("Турист саны: ${request['touristsCount']}\nҚұны: ${request['tourPrice']} ₸"),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => deleteRequest(request['id']),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
