import 'package:flutter/material.dart';
import 'package:insightmid_app/features/insightmind/presentation/pages/home_page.dart';

// --- IMPORT HALAMAN PEDOMETER ---
import 'pedometer_page.dart'; 
// --------------------------------

class ResultPage extends StatelessWidget {
  final int totalScore;
  final String riskLevel;

  const ResultPage({
    super.key,
    required this.totalScore,
    required this.riskLevel,
  });

  // Logika sederhana: Jika risiko BUKAN Normal/Minimal, berarti butuh aktivitas
  bool get _needsActivity {
    final level = riskLevel.toLowerCase();
    return level.contains('sedang') || 
           level.contains('berat') || 
           level.contains('tinggi') ||
           level.contains('ringan'); // Bahkan stres ringan pun butuh jalan kaki
  }

  @override
  Widget build(BuildContext context) {
    // Tentukan warna berdasarkan tingkat risiko
    Color statusColor = Colors.green;
    if (riskLevel.contains('Sedang')) statusColor = Colors.orange;
    if (riskLevel.contains('Berat') || riskLevel.contains('Tinggi')) statusColor = Colors.red;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Hasil Analisis"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            // Kembali ke Home dan hapus semua stack navigasi sebelumnya
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
              (route) => false,
            );
          },
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

              // --- FITUR BARU: REKOMENDASI JALAN KAKI ---
              if (_needsActivity) _buildWalkingRecommendation(context),
              // ------------------------------------------

              const SizedBox(height: 24),

              // Tombol Kembali ke Beranda
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                      (route) => false,
                    );
                  },
                  child: const Text("Kembali ke Beranda"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWalkingRecommendation(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
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
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Rekomendasi Aktivitas",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blue),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Berjalan kaki 15 menit dapat membantu meredakan kecemasan dan stres Anda saat ini.",
                      style: TextStyle(fontSize: 13, color: Colors.black87),
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
                // Navigasi langsung ke Pedometer
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