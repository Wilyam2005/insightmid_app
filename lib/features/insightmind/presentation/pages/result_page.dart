// lib/features/insightmind/presentation/pages/result_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; 
import 'package:intl/intl.dart'; // Untuk format tanggal

// --- IMPORT PDF & PRINTING ---
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
// -----------------------------

import 'main_nav_page.dart'; // Akses ke provider navigasi
import 'pedometer_page.dart'; // Import halaman pedometer

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

  // ===================================================
  // FUNGSI MEMBUAT PDF (BARU)
  // ===================================================
  Future<void> _generateAndDownloadPdf(BuildContext context) async {
    final pdf = pw.Document();
    final date = DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(DateTime.now());
    final time = DateFormat('HH:mm').format(DateTime.now());

    // Tentukan warna teks PDF (PDF menggunakan PdfColors, bukan Colors biasa)
    PdfColor statusColorPdf = PdfColors.green;
    if (riskLevel.contains('Sedang')) statusColorPdf = PdfColors.orange;
    if (riskLevel.contains('Berat') || riskLevel.contains('Tinggi')) statusColorPdf = PdfColors.red;

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header Laporan
              pw.Header(
                level: 0,
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text("Laporan InsightMind", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
                    pw.Text("Kesehatan Mental", style: const pw.TextStyle(fontSize: 18, color: PdfColors.grey)),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),

              // Informasi Tanggal
              pw.Text("Tanggal Pemeriksaan: $date"),
              pw.Text("Waktu: $time"),
              pw.Divider(),
              pw.SizedBox(height: 30),

              // Konten Utama (Skor & Risiko)
              pw.Center(
                child: pw.Column(
                  children: [
                    pw.Text("HASIL SCREENING ANDA", style: pw.TextStyle(fontSize: 16, color: PdfColors.grey700)),
                    pw.SizedBox(height: 10),
                    
                    // Lingkaran Skor di PDF
                    pw.Container(
                      padding: const pw.EdgeInsets.all(20),
                      decoration: pw.BoxDecoration(
                        shape: pw.BoxShape.circle,
                        border: pw.Border.all(color: statusColorPdf, width: 4),
                      ),
                      child: pw.Column(
                        children: [
                          pw.Text("$totalScore", style: pw.TextStyle(fontSize: 40, fontWeight: pw.FontWeight.bold, color: statusColorPdf)),
                          pw.Text("Skor Total", style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey)),
                        ],
                      ),
                    ),
                    pw.SizedBox(height: 20),
                    
                    pw.Text("Tingkat Risiko:", style: const pw.TextStyle(fontSize: 14)),
                    pw.Text(riskLevel, style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, color: statusColorPdf)),
                  ],
                ),
              ),
              
              pw.SizedBox(height: 50),
              
              // Kotak Disclaimer
              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey100,
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Text(
                  "DISCLAIMER: Hasil ini hanyalah indikasi awal berdasarkan jawaban kuesioner Anda dan BUKAN merupakan diagnosis medis profesional. Jika Anda merasa membutuhkan bantuan, harap segera hubungi psikolog atau psikiater terdekat.",
                  style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey800),
                  textAlign: pw.TextAlign.justify,
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Center(child: pw.Text("© InsightMind App", style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey))),
            ],
          );
        },
      ),
    );

    // Membuka UI Print/Save bawaan HP
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Hasil-Screening-InsightMind-$date',
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Warna status UI (Material Colors)
    Color statusColor = Colors.green;
    if (riskLevel.contains('Sedang')) statusColor = Colors.orange;
    if (riskLevel.contains('Berat') || riskLevel.contains('Tinggi')) statusColor = Colors.red;

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Hasil Analisis"),
        centerTitle: true,
        automaticallyImplyLeading: false, 
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => _finishAndGoToHome(context, ref), 
        ),
        // --- TOMBOL DOWNLOAD PDF (BARU) ---
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            tooltip: "Download PDF",
            onPressed: () => _generateAndDownloadPdf(context),
          ),
        ],
        // ----------------------------------
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              
              // Lingkaran Skor UI
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

              if (_needsActivity) _buildWalkingRecommendation(context, isDarkMode),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.home),
                  label: const Text("Selesai & Kembali ke Beranda"),
                  onPressed: () => _finishAndGoToHome(context, ref),
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
