// lib/features/insightmind/presentation/providers/questionnaire_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart'; // <-- PERBAIKAN
import '../../domain/entities/question.dart';

// State: map id pertanyaan -> skor (0..3)
class QuestionnaireState {
  final Map<String, int> answers;
  const QuestionnaireState({this.answers = const {}});

  QuestionnaireState copyWith({Map<String, int>? answers}) {
    return QuestionnaireState(answers: answers ?? this.answers);
  }

  bool get isComplete => answers.length >= defaultQuestions.length;
  int get totalScore => answers.values.fold(0, (a, b) => a + b);
}

class QuestionnaireNotifier extends StateNotifier<QuestionnaireState> {
  // Sekarang 'StateNotifier' ditemukan, 'super' ini akan valid
  QuestionnaireNotifier() : super(const QuestionnaireState()); 

  void selectAnswer({required String questionId, required int score}) {
    final newMap = Map<String, int>.from(state.answers); // 'state' ditemukan
    newMap[questionId] = score;
    state = state.copyWith(answers: newMap); // 'state' ditemukan
  }

  void reset() {
    state = const QuestionnaireState(); // 'state' ditemukan
  }
}

// Provider daftar pertanyaan (konstan)
final questionsProvider = Provider<List<Question>>((ref) { // 'Provider' ditemukan
  return defaultQuestions;
});

// Provider state form
final questionnaireProvider =
    StateNotifierProvider<QuestionnaireNotifier, QuestionnaireState>((ref) { // 'StateNotifierProvider' ditemukan
  return QuestionnaireNotifier();
});
