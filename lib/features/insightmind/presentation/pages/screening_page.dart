// lib/features/insightmind/presentation/pages/screening_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/question.dart';
import '../providers/questionnaire_provider.dart';
import 'summary_page.dart';

class ScreeningPage extends ConsumerStatefulWidget {
  const ScreeningPage({super.key});

  @override
  ConsumerState<ScreeningPage> createState() => _ScreeningPageState();
}

class _ScreeningPageState extends ConsumerState<ScreeningPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final questions = ref.watch(questionsProvider);
    final qState = ref.watch(questionnaireProvider);
    final totalQuestions = questions.length;
    final double progress =
        totalQuestions == 0 ? 0 : (_currentPage + 1) / totalQuestions;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Screening InsightMind'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(30.0),
          child: Column(
            children: [
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.teal.shade700, 
                valueColor: AlwaysStoppedAnimation<Color>(Colors.teal.shade100), 
              ),
              Container(
                color: Theme.of(context).appBarTheme.backgroundColor, 
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                  '${_currentPage + 1} / $totalQuestions pertanyaan',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[400]), 
                ),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).scaffoldBackgroundColor, 
              Colors.teal.shade900.withOpacity(0.3), 
            ],
          ),
        ),
        child: PageView.builder(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: totalQuestions,
          onPageChanged: (page) {
            setState(() {
              _currentPage = page;
            });
          },
          itemBuilder: (context, index) {
            final q = questions[index];
            final scoreTerpilih = qState.answers[q.id];
            return _QuestionView(
              question: q,
              selectedScore: scoreTerpilih,
              onSelected: (score) {
                ref
                    .read(questionnaireProvider.notifier)
                    .selectAnswer(questionId: q.id, score: score);
                
                Future.delayed(const Duration(milliseconds: 300), () {
                  if (_currentPage < totalQuestions - 1 && mounted) { // Cek mounted
                     _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                    );
                  }
                });
              },
            );
          },
        ),
      ),
       bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: _currentPage == totalQuestions - 1
              ? _buildSummaryButton(context, ref, qState.isComplete)
              : const SizedBox(height: 48), // Beri ruang kosong
        ),
      ),
    );
  }

  Widget _buildSummaryButton(
      BuildContext context, WidgetRef ref, bool isComplete) {
    // ... (kode _buildSummaryButton sama seperti sebelumnya) ...
     return SizedBox(
      width: double.infinity,
      height: 48,
      child: FilledButton(
        style: FilledButton.styleFrom(backgroundColor: Colors.green),
        onPressed: !isComplete ? null : () { 
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const SummaryPage()),
          );
        },
        child: const Text('Lihat Ringkasan'),
      ),
    );
  }
}

// Widget _QuestionView (sama seperti sebelumnya)
class _QuestionView extends StatelessWidget {
  final Question question;
  final int? selectedScore;
  final ValueChanged<int> onSelected;

  const _QuestionView({
    required this.question,
    required this.selectedScore,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question.text,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
          ),
          const SizedBox(height: 40), 
          Column(
            children: [
              for (final opt in question.options)
                RadioListTile<int>(
                  contentPadding: const EdgeInsets.symmetric(vertical: 8.0), 
                  title: Text(
                    opt.label,
                    style: const TextStyle(fontSize: 18, color: Colors.white), 
                  ),
                  value: opt.score,
                  groupValue: selectedScore,
                  activeColor: Colors.tealAccent, 
                  onChanged: (value) {
                    if (value != null) {
                      onSelected(value);
                    }
                  },
                   controlAffinity: ListTileControlAffinity.trailing, 
                ),
            ],
          ),
        ],
      ),
    );
  }
}