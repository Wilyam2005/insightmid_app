// lib/features/insightmind/domain/entities/history_entry.dart

import 'package:hive/hive.dart';

part 'history_entry.g.dart'; // File ini akan digenerate

@HiveType(typeId: 0)
class HistoryEntry extends HiveObject {
  @HiveField(0)
  final int score;

  @HiveField(1)
  final String riskLevel;

  @HiveField(2)
  final DateTime date;

  HistoryEntry({
    required this.score,
    required this.riskLevel,
    required this.date,
  });
}