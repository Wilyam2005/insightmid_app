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
    
    // Cek mode gelap
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

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
            colors: isDarkMode
                ? [Colors.grey.shade900, Colors.teal.shade900.withOpacity(0.4)]
                : [Colors.white, Colors.teal.shade50],
          ),
        ),
        child: history.isEmpty
            ? _buildEmptyState(context, isDarkMode)
            : ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  Text(
                    'Tren Skor Anda',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Container Grafik
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: _buildChart(context, history, isDarkMode),
                  ),
                  
                  const SizedBox(height: 24),
                  Text(
                    'Detail Riwayat',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildHistoryList(history, isDarkMode, context), // Daftar Riwayat
                ],
              ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isDarkMode) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history_toggle_off, size: 80, color: Colors.grey),
          const SizedBox(height: 16),
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

  Widget _buildHistoryList(List<HistoryEntry> history, bool isDarkMode, BuildContext context) {
    // Urutkan dari yang terbaru (paling atas)
    final sortedHistory = List<HistoryEntry>.from(history);
    sortedHistory.sort((a, b) => b.date.compareTo(a.date));

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sortedHistory.length,
      itemBuilder: (context, index) {
        final entry = sortedHistory[index];
        
        // Format Tanggal: "Senin, 22 Jan"
        final datePart = DateFormat('EEEE, d MMM', 'id_ID').format(entry.date);
        // Format Waktu: "14:30"
        final timePart = DateFormat('HH:mm').format(entry.date);

        // Logika Warna & Icon
        Color statusColor = Colors.green;
        IconData statusIcon = Icons.check_circle_outline;
        
        if (entry.riskLevel.contains('Sedang')) {
          statusColor = Colors.orange;
          statusIcon = Icons.info_outline;
        }
        if (entry.riskLevel.contains('Berat') || entry.riskLevel.contains('Tinggi')) {
          statusColor = Colors.red;
          statusIcon = Icons.warning_amber_rounded;
        }

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(
              color: isDarkMode ? Colors.white10 : Colors.grey.shade100,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // 1. Lingkaran Skor
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: statusColor, width: 3),
                    color: statusColor.withOpacity(0.1),
                  ),
                  child: Center(
                    child: Text(
                      '${entry.score}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                
                // 2. Informasi Detail
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Risiko ${entry.riskLevel}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: statusColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.calendar_today, size: 12, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            '$datePart • $timePart',
                            style: TextStyle(
                              color: isDarkMode ? Colors.white60 : Colors.grey[600],
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // 3. Icon Status di ujung kanan
                Icon(statusIcon, color: statusColor.withOpacity(0.5)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildChart(BuildContext context, List<HistoryEntry> history, bool isDarkMode) {
    // Balik data agar yang terlama di kiri (untuk grafik)
    final reversedHistory = history.reversed.toList();

    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          // --- BAGIAN INI MEMBUAT GARIS GRID MUNCUL ---
          gridData: FlGridData(
            show: true, // Tampilkan Grid
            drawVerticalLine: false, // Hanya garis horizontal agar rapi
            horizontalInterval: 5, // Garis muncul setiap kelipatan skor 5
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: isDarkMode ? Colors.white10 : Colors.grey.shade300,
                strokeWidth: 1,
              );
            },
          ),
          // --------------------------------------------
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true, 
                reservedSize: 30,
                interval: 5,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: TextStyle(
                      color: isDarkMode ? Colors.white70 : Colors.black87,
                      fontSize: 10,
                    ),
                  );
                },
              ),
            ),
            bottomTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(
              color: isDarkMode ? Colors.white24 : Colors.grey.shade300,
            ),
          ),
          minY: 0,
          maxY: 28, 
          lineBarsData: [
            LineChartBarData(
              spots: [
                for (int i = 0; i < reversedHistory.length; i++)
                  FlSpot(i.toDouble(), reversedHistory[i].score.toDouble()),
              ],
              isCurved: true,
              color: Colors.teal,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: Colors.teal.withOpacity(isDarkMode ? 0.1 : 0.2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}