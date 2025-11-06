// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'src/app.dart';
import 'features/insightmind/domain/entities/history_entry.dart';
import 'features/insightmind/domain/entities/mood_history_entry.dart';
import 'package:intl/date_symbol_data_local.dart'; // <-- IMPORT BARU

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // --- TAMBAHKAN BARIS INI ---
  await initializeDateFormatting('id_ID', null); 
  // --------------------------
  
  await Hive.initFlutter();
  Hive.registerAdapter(HistoryEntryAdapter());
  Hive.registerAdapter(MoodHistoryEntryAdapter()); 
  await Hive.openBox<HistoryEntry>('historyBox');
  await Hive.openBox<MoodHistoryEntry>('moodHistoryBox');

  runApp(const ProviderScope(child: InsightMindApp()));
}