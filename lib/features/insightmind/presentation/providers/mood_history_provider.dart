// lib/features/insightmind/presentation/providers/mood_history_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/entities/mood_history_entry.dart';

// Provider untuk Box Hive
final moodHistoryBoxProvider = Provider<Box<MoodHistoryEntry>>((ref) {
  return Hive.box<MoodHistoryEntry>('moodHistoryBox');
});

// Provider untuk mengambil semua riwayat mood
final moodHistoryProvider = StateProvider<List<MoodHistoryEntry>>((ref) {
  final box = ref.watch(moodHistoryBoxProvider);
  final list = box.values.toList().cast<MoodHistoryEntry>();
  list.sort((a, b) => b.date.compareTo(a.date)); 
  return list;
});

// Provider untuk menambah riwayat mood
final moodHistoryRepositoryProvider = Provider((ref) {
  final box = ref.watch(moodHistoryBoxProvider);
  return MoodHistoryRepository(box: box);
});

class MoodHistoryRepository {
  final Box<MoodHistoryEntry> box;
  MoodHistoryRepository({required this.box});

  Future<void> addMoodEntry(MoodHistoryEntry entry) async {
    await box.add(entry);
  }
}