// lib/features/insightmind/presentation/pages/breathing_exercise_page.dart

import 'package:flutter/material.dart';
import 'dart:async'; // Tetap dibutuhkan untuk Timer

class BreathingExercisePage extends StatefulWidget {
  const BreathingExercisePage({super.key});

  @override
  State<BreathingExercisePage> createState() => _BreathingExercisePageState();
}

class _BreathingExercisePageState extends State<BreathingExercisePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  String _instruction = "Pilih durasi latihan";
  Timer? _cycleTimer; // Timer untuk siklus inhale/hold/exhale

  // --- Variabel State Baru ---
  final Stopwatch _stopwatch = Stopwatch(); // Timer untuk total durasi
  bool _isRunning = false; // Status apakah latihan sedang berjalan
  
  // Pilihan durasi
  final List<Duration> _durationOptions = const [
    Duration(minutes: 1),
    Duration(minutes: 3),
    Duration(minutes: 5),
  ];
  // Status tombol durasi yang dipilih
  List<bool> _selections = [true, false, false];
  // Durasi yang sedang dipilih
  Duration _selectedDuration = const Duration(minutes: 1);
  // -------------------------

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4), // Durasi 4 detik (tetap)
    );

    _animation = Tween<double>(begin: 100.0, end: 200.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.addListener(() {
      setState(() {});
    });
    // Jangan mulai siklus di initState lagi
  }

  // --- Logika Siklus Pernapasan (Hampir Sama) ---

  void _startBreathingCycle() {
    _cycleTimer?.cancel();
    _inhale(); // Mulai siklus
  }

  void _inhale() {
    if (!mounted || !_isRunning) return; // Hentikan jika sudah tidak berjalan
    setState(() => _instruction = "Tarik Napas...");
    _controller.forward();
    _cycleTimer = Timer(const Duration(seconds: 4), _hold);
  }

  void _hold() {
    if (!mounted || !_isRunning) return;
    setState(() => _instruction = "Tahan...");
    _cycleTimer = Timer(const Duration(seconds: 2), _exhale);
  }

  void _exhale() {
    if (!mounted || !_isRunning) return;
    setState(() => _instruction = "Hembuskan...");
    _controller.reverse();
    
    // --- INI BAGIAN PENTING YANG BERUBAH ---
    // Timer 4 detik sebelum cek durasi dan loop
    _cycleTimer = Timer(const Duration(seconds: 4), _checkDurationAndLoop);
  }
  
  // --- Fungsi Baru ---

  // Fungsi untuk mengecek total durasi
  void _checkDurationAndLoop() {
    if (!mounted || !_isRunning) return;

    // Cek apakah waktu stopwatch sudah melebihi durasi yang dipilih
    if (_stopwatch.elapsed >= _selectedDuration) {
      _stopExercise(); // Hentikan latihan
    } else {
      _inhale(); // Ulangi siklus
    }
  }

  // Fungsi untuk MULAI latihan
  void _startExercise() {
    if (_isRunning) return;
    setState(() {
      _isRunning = true;
    });
    _stopwatch.start();
    _startBreathingCycle(); // Mulai siklus pernapasan
  }

  // Fungsi untuk STOP latihan (otomatis atau manual)
  void _stopExercise() {
    if (!mounted) return;
    _cycleTimer?.cancel();
    _stopwatch.stop();
    _stopwatch.reset();
    _controller.reset(); // Kembalikan animasi ke awal (lingkaran kecil)
    setState(() {
      _isRunning = false;
      _instruction = "Latihan Selesai. Baik sekali!";
    });
  }
  // --------------------


  @override
  void dispose() {
    _cycleTimer?.cancel();
    _stopwatch.stop();
    _controller.dispose();
    super.dispose();
  }

  // Fungsi untuk menampilkan sisa waktu
  String _getRemainingTime() {
    if (!_isRunning) return "";
    
    final remaining = _selectedDuration - _stopwatch.elapsed;
    if (remaining.isNegative) return "00:00";
    
    // Format menjadi MM:SS
    final minutes = remaining.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = remaining.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Latihan Pernapasan'),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).scaffoldBackgroundColor,
              Colors.purple.shade900.withOpacity(0.4),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Tampilkan sisa waktu jika sedang berjalan
            if (_isRunning)
              Text(
                _getRemainingTime(),
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: Colors.white70,
                      fontWeight: FontWeight.w200, // Tipis
                    ),
              ),
              
            // Teks Instruksi
            Text(
              _instruction,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    height: _isRunning ? 2.0 : 1.2, // Beri jarak jika timer ada
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 60),
            
            // Lingkaran animasi
            Container(
              width: _animation.value, // Ukuran tetap dikontrol animasi
              height: _animation.value,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                   colors: [Colors.purple.shade300, Colors.purple.shade700]
                )
              ),
            ),
            const SizedBox(height: 60),

            // --- UI KONTROL BARU (Tombol Mulai/Stop & Pilihan Waktu) ---
            if (_isRunning)
              // Tampilkan tombol STOP jika sedang berjalan
              ElevatedButton.icon(
                icon: const Icon(Icons.stop),
                label: const Text('Hentikan Latihan'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                onPressed: _stopExercise,
              )
            else
              // Tampilkan pilihan waktu & tombol MULAI jika sedang berhenti
              Column(
                children: [
                  Text("Pilih Durasi:", style: TextStyle(color: Colors.white70)),
                  const SizedBox(height: 12),
                  ToggleButtons(
                    isSelected: _selections,
                    onPressed: (int index) {
                      setState(() {
                        // Update pilihan tombol
                        for (int i = 0; i < _selections.length; i++) {
                          _selections[i] = i == index;
                        }
                        // Update durasi yang dipilih
                        _selectedDuration = _durationOptions[index];
                      });
                    },
                    borderRadius: BorderRadius.circular(30.0),
                    selectedBorderColor: Colors.purple[300],
                    selectedColor: Colors.black,
                    fillColor: Colors.purple[200],
                    color: Colors.purple[100],
                    children: [
                      _buildDurationChip("1 Menit"),
                      _buildDurationChip("3 Menit"),
                      _buildDurationChip("5 Menit"),
                    ],
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Mulai'),
                    style: FilledButton.styleFrom(
                       padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                       textStyle: const TextStyle(fontSize: 16),
                    ),
                    onPressed: _startExercise,
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }

  // Widget helper untuk chip durasi
  Widget _buildDurationChip(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(text),
    );
  }
}
