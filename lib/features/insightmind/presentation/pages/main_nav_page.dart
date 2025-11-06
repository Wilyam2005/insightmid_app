// lib/features/insightmind/presentation/pages/main_nav_page.dart

import 'package:flutter/material.dart';
import 'home_page.dart';
import 'history_page.dart';
// Hapus import mood_checkin_page.dart

class MainNavPage extends StatefulWidget {
  const MainNavPage({super.key});

  @override
  State<MainNavPage> createState() => _MainNavPageState();
}

class _MainNavPageState extends State<MainNavPage> {
  int _selectedIndex = 0;

  // --- HAPUS JURNAL MOOD DARI SINI ---
  static const List<Widget> _pages = <Widget>[
    HomePage(),
    HistoryPage(),
  ];
  // ----------------------------------

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Beranda', // Ubah dari Home
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_outlined),
            activeIcon: Icon(Icons.history),
            label: 'Riwayat',
          ),
          // --- HAPUS TAB JURNAL MOOD DARI SINI ---
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}