// lib/features/insightmind/domain/entities/mood_history_entry.dart

import 'package:hive/hive.dart';

part 'mood_history_entry.g.dart'; // File ini akan digenerate

@HiveType(typeId: 1) // ID 0 sudah dipakai HistoryEntry
class MoodHistoryEntry extends HiveObject {
  @HiveField(0)
  final DateTime date;

  @HiveField(1)
  final String imagePath; // Path ke foto yang disimpan

  @HiveField(2)
  final double smileProbability; // Hasil ML Kit

  @HiveField(3)
  final String journalText; // Teks jurnal

  MoodHistoryEntry({
    required this.date,
    required this.imagePath,
    required this.smileProbability,
    required this.journalText,
  });
}