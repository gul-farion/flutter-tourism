import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../providers/favorites_provider.dart';

class Topbar extends StatelessWidget implements PreferredSizeWidget {
  const Topbar({super.key});

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);

    return AppBar(
      foregroundColor: Colors.white,
      automaticallyImplyLeading: true,
      backgroundColor: Colors.blueAccent,
      title: Image.asset(
        'assets/logo-ht-short.png',
        width: 140,
        height: 140,
        fit: BoxFit.contain,
      ),
      actions: [
        // _buildNavItem(context, "Біздің қонақ үйлер", '/hotels'),
        _buildNavItem(context, "Біз туралы", '/about'),
        // _buildNavItem(context, "Тур агенттеріне", '/agents'),
        const SizedBox(width: 16),
        Stack(
          children: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/cart');
              },
              icon: const Icon(Icons.favorite, color: Colors.white),
            ),
            if (favoritesProvider.favoritesCount > 0)
              Positioned(
                right: 6,
                top: 6,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "${favoritesProvider.favoritesCount}",
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildNavItem(BuildContext context, String title, String route) {
    return TextButton(
      onPressed: () {
        Navigator.pushNamed(context, route);
      },
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // DrawerHeader(
          //   decoration: const BoxDecoration(color: Color(0xff0A78D6)),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       const CircleAvatar(
          //         radius: 40,
          //         backgroundColor: Colors.white,
          //         child: Icon(Icons.person, size: 40, color: Colors.black),
          //       ),
          //       const SizedBox(height: 16),
          //       StreamBuilder<User?>(
          //         stream: FirebaseAuth.instance.authStateChanges(),
          //         builder: (context, snapshot) {
          //           final user = snapshot.data;
          //           return Text(
          //             user?.email ?? "Қонақ",
          //             style: const TextStyle(
          //               color: Colors.white,
          //               fontSize: 18,
          //               fontWeight: FontWeight.bold,
          //             ),
          //           );
          //         },
          //       ),
          //     ],
          //   ),
          // ),
          ListTile(
            leading: const Icon(Icons.person, color: Colors.black),
            title: const Text("Менің сұраныстарым", style: TextStyle(fontFamily: "Inter", fontWeight: FontWeight.bold),),
            onTap: () {
              Navigator.pushNamed(context, '/account');
            },
          ),
          ListTile(
            leading: const Icon(Icons.info, color: Colors.black),
            title: const Text("Біз туралы", style: TextStyle(fontFamily: "Inter", fontWeight: FontWeight.bold),),
            onTap: () {
              Navigator.pushNamed(context, '/about');
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_home_work_rounded, color: Colors.black),
            title: const Text("Турларды өзгерту", style: TextStyle(fontFamily: "Inter", fontWeight: FontWeight.bold),),
            onTap: () {
              Navigator.pushNamed(context, '/admin');
            },
          ),
          const Divider(),
          // StreamBuilder<User?>(
          //   stream: FirebaseAuth.instance.authStateChanges(),
          //   builder: (context, snapshot) {
          //     final user = snapshot.data;
          //     if (user == null) {
          //       return ListTile(
          //         leading: const Icon(Icons.login, color: Colors.black),
          //         title: const Text("Кіру"),
          //         onTap: () {
          //           Navigator.pushNamed(context, '/login');
          //         },
          //       );
          //     }
          //     return ListTile(
          //       leading: const Icon(Icons.logout, color: Colors.black),
          //       title: const Text("Шығу"),
          //       onTap: () async {
          //         await FirebaseAuth.instance.signOut();
          //         Navigator.pop(context);
          //       },
          //     );
          //   },
          // ),
        ],
      ),
    );
  }
}
