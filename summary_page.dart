// lib/features/insightmind/presentation/pages/summary_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/question.dart';
import '../providers/questionnaire_provider.dart';
import '../providers/score_provider.dart';
import 'result_page.dart';

// Import untuk fitur History
import '../../domain/entities/history_entry.dart';
import '../providers/history_provider.dart';

class SummaryPage extends ConsumerWidget {
  const SummaryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questions = ref.watch(questionsProvider);
    final qState = ref.watch(questionnaireProvider);
    
    // Deteksi Mode Gelap
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ringkasan Jawaban'),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDarkMode
                ? [
                    Colors.grey.shade900,
                    Colors.teal.shade900.withOpacity(0.4),
                  ]
                : [
                    Colors.white,
                    Colors.teal.shade50,
                  ],
          ),
        ),
        child: ListView.separated(
          padding: const EdgeInsets.all(16.0),
          itemCount: questions.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final q = questions[index];
            final selectedScore = qState.answers[q.id];

            final selectedLabel = q.options
                .firstWhere(
                  (opt) => opt.score == selectedScore,
                  orElse: () =>
                      const AnswerOption(label: 'Belum dijawab', score: -1),
                )
                .label;

            return Card(
              elevation: 2.0,
              // Card otomatis menyesuaikan warna surface di dark mode
              child: ListTile(
                title: Text(
                  q.text,
                  style: const TextStyle(fontSize: 14),
                ),
                subtitle: Text(
                  selectedLabel,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    // Sesuaikan warna teks agar terlihat jelas di kedua mode
                    color: isDarkMode ? Colors.tealAccent : Theme.of(context).primaryColor,
                  ),
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: FilledButton.icon(
            icon: const Icon(Icons.check_circle_outline),
            label: const Text('Konfirmasi & Lihat Hasil'),
            onPressed: () async {
              // 1. Kirim jawaban ke provider skor
              final answersOrdered = <int>[];
              for (final q in questions) {
                // Pastikan tidak ada nilai null (default ke 0 jika error)
                answersOrdered.add(qState.answers[q.id] ?? 0);
              }
              ref.read(answersProvider.notifier).state = answersOrdered;

              // 2. Ambil hasil perhitungan (Skor & Risiko)
              final result = ref.read(resultProvider);

              // 3. Simpan ke Riwayat (History)
              final newEntry = HistoryEntry(
                score: result.score,
                riskLevel: result.riskLevel,
                date: DateTime.now(),
              );

              await ref.read(historyRepositoryProvider).addHistory(newEntry);
              
              // Refresh provider agar halaman History otomatis update
              ref.invalidate(historyProvider);

              // 4. Reset Kuesioner untuk pemakaian berikutnya
              ref.read(questionnaireProvider.notifier).reset();

              // 5. Navigasi ke Halaman Hasil
              if (context.mounted) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => ResultPage(
                      totalScore: result.score,
                      riskLevel: result.riskLevel,
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}