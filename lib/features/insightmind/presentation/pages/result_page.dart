// lib/features/insightmind/presentation/pages/result_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/score_provider.dart';

class ResultPage extends ConsumerWidget {
  const ResultPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final result = ref.watch(resultProvider);
    String recommendation;
    Color riskColor;

    switch (result.riskLevel) {
      case 'Tinggi':
        recommendation =
            'Pertimbangkan berbicara dengan konselor/psikolog.';
        riskColor = Colors.red.shade700;
        break;
      case 'Sedang':
        recommendation =
            'Lakukan aktivitas relaksasi (napas dalam, olahraga ringan), atur waktu, dan evaluasi beban kuliah/kerja.';
        riskColor = Colors.orange.shade700;
        break;
      default:
        recommendation =
            'Pertahankan kebiasaan baik. Jaga tidur, makan, dan olahraga.';
        riskColor = Colors.green.shade700;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hasil Screening'),
        // Hapus warna, biarkan tema yang atur
      ),
      // --- TAMBAHKAN LATAR BELAKANG GRADASI ---
      body: Container(
        width: double.infinity,
        height: double.infinity,
         decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Colors.teal.shade50,
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Skor Anda:',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(
                  '${result.score}',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: riskColor,
                      ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Tingkat Risiko: ${result.riskLevel}',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: riskColor,
                      ),
                ),
                const SizedBox(height: 32),
                Text(
                  recommendation,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Disclaimer: InsightMind bersifat edukatif, bukan alat diagnosis medis.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}