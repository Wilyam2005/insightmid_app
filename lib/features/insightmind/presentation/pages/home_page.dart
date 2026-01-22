// lib/features/insightmind/presentation/pages/home_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:intl/intl.dart'; 

// Import semua halaman yang akan dinavigasi
import 'mood_checkin_page.dart';
import 'screening_page.dart';
import 'education_page.dart';
import 'breathing_exercise_page.dart';
import 'emergency_contacts_page.dart';
import 'settings_page.dart';

// --- TAMBAHAN IMPORT HALAMAN PEDOMETER ---
import 'pedometer_page.dart'; 
// ----------------------------------------

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const String nama = "Selamat Datang";
    const String quote = "Semoga harimu tenang.";
    final String tanggalHariIni = DateFormat('EEEE, d MMMM', 'id_ID').format(DateTime.now());

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 48.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildUserInfo(nama, quote),
              const SizedBox(height: 24),
              _buildBannerCarousel(),
              const SizedBox(height: 24),
              _buildStatusInfo(),
              const SizedBox(height: 24),
              _buildGridMenu(context), 
              const SizedBox(height: 32),
              _buildScheduleSection(tanggalHariIni),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET HELPER ---

  Widget _buildUserInfo(String title, String subtitle) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[400],
                  ),
            ),
          ],
        ),
        const Spacer(),
        const Icon(
          Icons.account_circle,
          size: 60,
          color: Colors.blue,
        ),
      ],
    );
  }

  Widget _buildBannerCarousel() {
    final banners = [
      _buildBannerCard('Artikel Baru', '5 Cara Mengelola Stres Harian', Colors.teal, 'Edukasi'),
      _buildBannerCard('Fitur Baru', 'Coba Analisis Mood dengan AI', Colors.purple, 'Jurnal AI'),
      _buildBannerCard('Check-in', 'Jangan Lupa Screening Mingguan Anda', Colors.blue, 'Reminder'),
    ];

    return Column(
      children: [
        SizedBox(
          height: 180,
          child: PageView.builder(
            controller: _pageController,
            itemCount: banners.length,
            itemBuilder: (context, index) {
              return banners[index];
            },
          ),
        ),
        const SizedBox(height: 16),
        SmoothPageIndicator(
          controller: _pageController,
          count: banners.length,
          effect: WormEffect(
            dotHeight: 10,
            dotWidth: 10,
            activeDotColor: Theme.of(context).colorScheme.primary,
            dotColor: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }

  Widget _buildBannerCard(String title, String subtitle, Color color, String tag) {
     return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.7), color],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(tag, style: const TextStyle(color: Colors.white)),
            ),
            const Spacer(),
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: Colors.white),
            ),
            Text(
              subtitle,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusInfo() {
    return Column(
      children: [
        _buildInfoChip(Icons.check_circle_outline, 'Check-in Terakhir: 2 Hari Lalu'),
        const SizedBox(height: 8),
        _buildInfoChip(Icons.bar_chart, 'Skor Rata-rata: 12 (Sedang)'),
        const SizedBox(height: 8),
        _buildInfoChip(Icons.edit_note, 'Total Entri Jurnal: 5'),
      ],
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
     return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.grey[400], size: 20),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              text,
              style: TextStyle(color: Colors.grey[300], fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridMenu(BuildContext context) {
    // --- UPDATE: MENAMBAHKAN MENU CEK LANGKAH ---
    final menuItems = [
      { 'label': 'Mulai Screening', 'icon': Icons.checklist, 'color': Colors.blue },
      { 'label': 'Jurnal Mood', 'icon': Icons.sentiment_satisfied, 'color': Colors.teal },
      { 'label': 'Artikel Edukasi', 'icon': Icons.lightbulb_outline, 'color': Colors.orange },
      { 'label': 'Latihan Napas', 'icon': Icons.self_improvement, 'color': Colors.purple },
      
      // Tambahan Menu Pedometer
      { 'label': 'Cek Langkah', 'icon': Icons.directions_walk, 'color': Colors.green }, 
      
      { 'label': 'Kontak Darurat', 'icon': Icons.local_hospital, 'color': Colors.red },
      { 'label': 'Pengaturan', 'icon': Icons.settings, 'color': Colors.grey },
    ];
    // ---------------------------------------------

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.9,
      ),
      itemCount: menuItems.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final item = menuItems[index];
        return _buildGridItem(
          item['label'] as String,
          item['icon'] as IconData,
          item['color'] as Color,
          () {
            String label = item['label'] as String;
            Widget? targetPage; 

            // --- LOGIKA SWITCH NAVIGASI DIPERBARUI ---
            switch (label) {
              case 'Mulai Screening':
                targetPage = const ScreeningPage();
                break;
              case 'Jurnal Mood':
                targetPage = const MoodCheckinPage();
                break;
              case 'Artikel Edukasi':
                targetPage = const EducationPage();
                break;
              case 'Latihan Napas':
                targetPage = const BreathingExercisePage();
                break;
              // Tambahkan case untuk Pedometer
              case 'Cek Langkah':
                targetPage = const PedometerPage();
                break;
              case 'Kontak Darurat':
                targetPage = const EmergencyContactsPage(); 
                break;
              case 'Pengaturan':
                targetPage = const SettingsPage(); 
                break;
            }
            // ----------------------------------------

            if (targetPage != null) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => targetPage!),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Aksi untuk $label belum didefinisikan')),
              );
            }
          },
        );
      },
    );
  }

  Widget _buildGridItem( String label, IconData icon, Color color, VoidCallback onTap) {
     return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color.withOpacity(0.8), color],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: Colors.white, size: 30),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

   Widget _buildScheduleSection(String tanggal) {
     return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tanggal,
                  style: TextStyle(color: Colors.grey[400]),
                ),
                const SizedBox(height: 4),
                Text(
                  'Pengingat: Jurnal Malam Anda',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Spacer(),
            IconButton.filled(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Menuju Halaman Pengingat...')),
                );
              },
            ),
          ],
        ),
      ),
    );
   }
}
