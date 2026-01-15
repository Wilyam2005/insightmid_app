// lib/features/insightmind/presentation/providers/history_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/entities/history_entry.dart';

// Provider untuk Box Hive
final historyBoxProvider = Provider<Box<HistoryEntry>>((ref) {
  return Hive.box<HistoryEntry>('historyBox');
});

// Provider untuk mengambil semua riwayat
final historyProvider = StateProvider<List<HistoryEntry>>((ref) {
  final box = ref.watch(historyBoxProvider);
  // Ambil data dan urutkan dari yang terbaru
  final list = box.values.toList().cast<HistoryEntry>();
  list.sort((a, b) => b.date.compareTo(a.date)); 
  return list;
});

// Provider untuk menambah riwayat
final historyRepositoryProvider = Provider((ref) {
  final box = ref.watch(historyBoxProvider);

  return HistoryRepository(box: box);
});

class HistoryRepository {
  final Box<HistoryEntry> box;
  HistoryRepository({required this.box});

  Future<void> addHistory(HistoryEntry entry) async {
    await box.add(entry);
  }
}
