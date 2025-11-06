// lib/src/app.dart

import 'package:flutter/material.dart';
import '../features/insightmind/presentation/pages/main_nav_page.dart';
import '../theme_manager.dart';

class InsightMindApp extends StatelessWidget {
  const InsightMindApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Listen to global themeModeNotifier so Settings can toggle theme app-wide
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeModeNotifier,
      builder: (context, mode, child) {
        return MaterialApp(
          title: 'InsightMind',
          debugShowCheckedModeBanner: false,

          // Light theme (can be customized further)
          theme: ThemeData.from(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.light),
          ).copyWith(
            scaffoldBackgroundColor: Colors.grey.shade50,
            appBarTheme: const AppBarTheme(backgroundColor: Colors.blue),
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              backgroundColor: Colors.white,
              selectedItemColor: Colors.blue,
              unselectedItemColor: Colors.grey,
            ),
          ),

          // Dark theme (existing customizations preserved)
          darkTheme: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue,
              brightness: Brightness.dark,
            ),
            scaffoldBackgroundColor: const Color(0xFF121212),
            // cardTheme type can vary between SDK versions; set cardColor for
            // broader compatibility instead of a CardTheme object.
            cardColor: const Color(0xFF1E1E1E),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF1F1F1F),
              elevation: 0,
            ),
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              backgroundColor: Color(0xFF1F1F1F),
              selectedItemColor: Colors.blue,
              unselectedItemColor: Colors.grey,
            ),
          ),

          themeMode: mode,
          home: const MainNavPage(),
        );
      },
    );
  }
}
