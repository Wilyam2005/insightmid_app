// lib/features/insightmind/presentation/pages/history_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/history_entry.dart';
import '../providers/history_provider.dart';

class HistoryPage extends ConsumerWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Ambil data riwayat dari provider
    final history = ref.watch(historyProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Screening'),
        centerTitle: true,
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
        child: history.isEmpty
            ? _buildEmptyState()
            : ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  Text(
                    'Tren Skor Anda',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  _buildChart(context, history), // Grafik
                  const SizedBox(height: 24),
                  Text(
                    'Detail Riwayat',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  _buildHistoryList(history), // Daftar
                ],
              ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history_toggle_off, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Belum Ada Riwayat',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          Text(
            'Hasil screening Anda akan muncul di sini.',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList(List<HistoryEntry> history) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: history.length,
      itemBuilder: (context, index) {
        final entry = history[index];
        final formattedDate = DateFormat('d MMMM y, HH:mm').format(entry.date);
        
        Color riskColor;
        if (entry.riskLevel == 'Tinggi') riskColor = Colors.red;
        else if (entry.riskLevel == 'Sedang') riskColor = Colors.orange;
        else riskColor = Colors.green;

        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: riskColor.withOpacity(0.1),
              child: Text(
                '${entry.score}',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: riskColor),
              ),
            ),
            title: Text(
              'Risiko: ${entry.riskLevel}',
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: riskColor),
            ),
            subtitle: Text(formattedDate),
          ),
        );
      },
    );
  }

  Widget _buildChart(BuildContext context, List<HistoryEntry> history) {
    // Balik data agar yang terlama di kiri
    final reversedHistory = history.reversed.toList();

    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 30)),
            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: Colors.grey.shade300),
          ),
          minY: 0,
          maxY: 27, // Skor maks 9 pertanyaan x 3
          lineBarsData: [
            LineChartBarData(
              spots: [
                for (int i = 0; i < reversedHistory.length; i++)
                  FlSpot(i.toDouble(), reversedHistory[i].score.toDouble()),
              ],
              isCurved: true,
              color: Colors.teal,
              barWidth: 4,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: Colors.teal.withOpacity(0.2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}