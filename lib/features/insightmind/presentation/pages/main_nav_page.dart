// lib/features/insightmind/presentation/pages/main_nav_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'home_page.dart';
import 'history_page.dart';

// 1. Provider global untuk mengontrol tab mana yang aktif
final bottomNavIndexProvider = StateProvider<int>((ref) => 0);

class MainNavPage extends ConsumerWidget {
  const MainNavPage({super.key});

  static const List<Widget> _pages = <Widget>[
    HomePage(),
    HistoryPage(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 2. Pantau perubahan index dari provider
    final selectedIndex = ref.watch(bottomNavIndexProvider);

    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_outlined),
            activeIcon: Icon(Icons.history),
            label: 'Riwayat',
          ),
        ],
        currentIndex: selectedIndex,
        // 3. Update provider saat user menekan tab
        onTap: (index) => ref.read(bottomNavIndexProvider.notifier).state = index,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}