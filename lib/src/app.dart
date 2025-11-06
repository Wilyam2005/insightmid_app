// lib/src/app.dart

import 'package:flutter/material.dart';
import '../features/insightmind/presentation/pages/main_nav_page.dart';

class InsightMindApp extends StatelessWidget {
  const InsightMindApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'InsightMind',
      debugShowCheckedModeBanner: false,
      
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF121212), 
        
        // --- PERBAIKAN DI SINI ---
        cardTheme: const CardThemeData( // Diubah dari CardTheme
          color: Color(0xFF1E1E1E), 
          elevation: 2,
        ),
        // -------------------------

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
      
      home: const MainNavPage(),
    );
  }
}