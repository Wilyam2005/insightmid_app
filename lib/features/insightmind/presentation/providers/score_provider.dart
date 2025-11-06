import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/calculate_risk_level.dart';
import '../../../insightmind/data/repositories/score_repository.dart';
import '../../domain/entities/mental_result.dart'; // Pastikan import MentalResult

/// Simpan jawaban kuisioner di memori (sementara).
final answersProvider = StateProvider<List<int>>((ref) => []); // 

/// Repository sederhana untuk hitung skor total.
final scoreRepositoryProvider = Provider<ScoreRepository>((ref) { // 
  return ScoreRepository();
});

/// Use case untuk konversi skor -> level risiko.
final calculateRiskProvider = Provider<CalculateRiskLevel>((ref) { // 
  return CalculateRiskLevel();
});

/// Hasil skoring mentah.
final scoreProvider = Provider<int>((ref) { // 
  final repo = ref.watch(scoreRepositoryProvider); // 
  final answers = ref.watch(answersProvider); // 
  return repo.calculateScore(answers); // 
});

/// Hasil akhir (skor + level risiko).
final resultProvider = Provider<MentalResult>((ref) { // 
  final score = ref.watch(scoreProvider); // 
  final usecase = ref.watch(calculateRiskProvider); // 
  return usecase.execute(score); // 
});