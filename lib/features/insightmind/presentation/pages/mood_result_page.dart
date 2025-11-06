// lib/features/insightmind/presentation/pages/mood_result_page.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/mood_history_entry.dart';
import '../providers/mood_history_provider.dart';

class MoodResultPage extends ConsumerStatefulWidget {
  final String imagePath;
  final double smileProbability;

  const MoodResultPage({
    super.key,
    required this.imagePath,
    required this.smileProbability,
  });

  @override
  ConsumerState<MoodResultPage> createState() => _MoodResultPageState();
}

class _MoodResultPageState extends ConsumerState<MoodResultPage> {
  final TextEditingController _journalController = TextEditingController();
  bool _isSaving = false;

  String getMoodString() {
    if (widget.smileProbability > 0.7) {
      return "Terlihat Senang 😊";
    } else if (widget.smileProbability > 0.3) {
      return "Terlihat Netral 😐";
    } else {
      return "Terlihat Sedih/Serius 😔";
    }
  }

  @override
  void dispose() {
    _journalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hasil Check-in'),
        // Otomatis ada tombol back
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              getMoodString(),
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.file(
                  File(widget.imagePath),
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Apa yang sedang Anda rasakan atau pikirkan?',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _journalController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Tulis jurnal singkat Anda di sini...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            _isSaving
                ? const Center(child: CircularProgressIndicator())
                : FilledButton.icon(
                    icon: const Icon(Icons.save),
                    label: const Text('Simpan Jurnal Mood'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: _saveJournal,
                  ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveJournal() async {
    setState(() {
      _isSaving = true;
    });

    try {
      final newEntry = MoodHistoryEntry(
        date: DateTime.now(),
        imagePath: widget.imagePath,
        smileProbability: widget.smileProbability,
        journalText: _journalController.text,
      );

      // Simpan ke Hive
      await ref.read(moodHistoryRepositoryProvider).addMoodEntry(newEntry);

      // Invalidate provider agar halaman riwayat (jika ada) update
      ref.invalidate(moodHistoryProvider);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Jurnal Mood berhasil disimpan!')),
        );
        // Kembali ke halaman utama (MainNavPage)
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }
}