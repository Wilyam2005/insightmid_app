// lib/features/insightmind/presentation/pages/summary_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/question.dart';
import '../providers/questionnaire_provider.dart';
import '../providers/score_provider.dart';
import 'result_page.dart';

// Import baru
import '../../domain/entities/history_entry.dart';
import '../providers/history_provider.dart';

class SummaryPage extends ConsumerWidget {
  const SummaryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questions = ref.watch(questionsProvider);
    final qState = ref.watch(questionnaireProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ringkasan Jawaban Anda'),
      ),
      body: Container(
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
        child: ListView.separated(
          // ... (kode ListView.separated tidak berubah) ...
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
              child: ListTile(
                title: Text(
                  q.text,
                  style: const TextStyle(fontSize: 14),
                ),
                subtitle: Text(
                  selectedLabel,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
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
            onPressed: () async { // Jadikan async
              // 1. Alirkan jawaban ke pipeline minggu 2 (score_provider)
              final answersOrdered = <int>[];
              for (final q in questions) {
                answersOrdered.add(qState.answers[q.id]!);
              }
              ref.read(answersProvider.notifier).state = answersOrdered;

              // --- PERUBAHAN DI SINI ---
              // 2. Ambil hasil akhir untuk disimpan
              final result = ref.read(resultProvider);

              // 3. Buat entri riwayat baru
              final newEntry = HistoryEntry(
                score: result.score,
                riskLevel: result.riskLevel,
                date: DateTime.now(),
              );

              // 4. Simpan ke database Hive
              await ref.read(historyRepositoryProvider).addHistory(newEntry);
              
              // 5. Reset provider riwayat agar UI update
              ref.invalidate(historyProvider);
              // --------------------------

              // 6. Reset form kuesioner
              ref.read(questionnaireProvider.notifier).reset();

              // 7. Navigasi ke ResultPage (pastikan context masih valid)
              if (context.mounted) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const ResultPage()),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}