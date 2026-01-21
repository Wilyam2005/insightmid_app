// lib/features/insightmind/presentation/pages/result_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; 
import 'main_nav_page.dart'; // Akses ke provider navigasi

// --- IMPORT HALAMAN PEDOMETER ---
import 'pedometer_page.dart'; 
// --------------------------------

class ResultPage extends ConsumerWidget {
  final int totalScore;
  final String riskLevel;

  const ResultPage({
    super.key,
    required this.totalScore,
    required this.riskLevel,
  });

  // Logika: Jika risiko BUKAN Normal, butuh aktivitas
  bool get _needsActivity {
    final level = riskLevel.toLowerCase();
    return level.contains('sedang') || 
           level.contains('berat') || 
           level.contains('tinggi') ||
           level.contains('ringan');
  }

  // Helper function: Kembali ke Menu Utama (Beranda)
  void _finishAndGoToHome(BuildContext context, WidgetRef ref) {
    // 1. Set tab aktif ke 'Beranda' (index 0)
    ref.read(bottomNavIndexProvider.notifier).state = 0;
    
    // 2. Buang halaman Result ini dan kembali ke MainNavPage
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Warna status
    Color statusColor = Colors.green;
    if (riskLevel.contains('Sedang')) statusColor = Colors.orange;
    if (riskLevel.contains('Berat') || riskLevel.contains('Tinggi')) statusColor = Colors.red;

    // Deteksi Dark Mode
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Hasil Analisis"),
        centerTitle: true,
        automaticallyImplyLeading: false, // Hilangkan tombol back default
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => _finishAndGoToHome(context, ref), // Kembali ke Beranda
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              
              // Lingkaran Skor
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: statusColor, width: 8),
                  color: statusColor.withOpacity(0.1),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "$totalScore",
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                    const Text("Skor Total", style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Teks Tingkat Risiko
              Text(
                "Tingkat Risiko:",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 8),
              Text(
                riskLevel,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: statusColor,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 16),
              
              const Text(
                "Hasil ini merupakan indikasi awal. Jika Anda merasa terganggu secara emosional, segera hubungi profesional.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 32),

              // --- FITUR REKOMENDASI AKTIVITAS ---
              if (_needsActivity) _buildWalkingRecommendation(context, isDarkMode),
              // -----------------------------------

              const SizedBox(height: 24),

              // Tombol Selesai (Ke Beranda)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => _finishAndGoToHome(context, ref),
                  child: const Text("Selesai & Kembali ke Beranda"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWalkingRecommendation(BuildContext context, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.blue.withOpacity(0.1) : Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.directions_walk, color: Colors.blue, size: 30),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Rekomendasi Aktivitas",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blue),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Berjalan kaki 15 menit dapat membantu meredakan kecemasan dan stres Anda saat ini.",
                      style: TextStyle(
                        fontSize: 13, 
                        color: isDarkMode ? Colors.white70 : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                // Navigasi ke Pedometer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PedometerPage()),
                );
              },
              child: const Text("Mulai Jalan Kaki Sekarang"),
            ),
          ),
        ],
      ),
    );
  }
}
