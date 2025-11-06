// lib/features/insightmind/presentation/pages/breathing_exercise_page.dart

import 'package:flutter/material.dart';
import 'dart:async'; // Untuk Timer

class BreathingExercisePage extends StatefulWidget {
  const BreathingExercisePage({super.key});

  @override
  State<BreathingExercisePage> createState() => _BreathingExercisePageState();
}

// Enum untuk melacak fase pernapasan
enum BreathingPhase { inhale, hold, exhale }

class _BreathingExercisePageState extends State<BreathingExercisePage>
    with SingleTickerProviderStateMixin { // Dibutuhkan untuk AnimationController
  late AnimationController _controller;
  late Animation<double> _animation;
  String _instruction = "Tarik Napas...";
  Timer? _timer;
  BreathingPhase _cycle = BreathingPhase.inhale; // Menggunakan enum untuk fase pernapasan

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4), // Durasi tarik/hembus napas
    );

    _animation = Tween<double>(begin: 100.0, end: 200.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.addListener(() {
      setState(() {}); // Update UI saat animasi berjalan
    });

    _startBreathingCycle();
  }

  void _startBreathingCycle() {
    _timer?.cancel(); // Hentikan timer sebelumnya jika ada
    setState(() {
      _cycle = BreathingPhase.inhale; // Reset cycle ke fase inhale
    });
    _inhale(); // Mulai siklus
  }
  
  void _inhale() {
    if (!mounted) return; // Cek jika widget masih ada
    setState(() {
      _cycle = BreathingPhase.inhale;
      _instruction = "Tarik Napas...";
    });
    _controller.forward(); // Animasi membesar
    _timer = Timer(const Duration(seconds: 4), _hold); // Tahan setelah 4 detik
  }

  void _hold() {
    if (!mounted) return;
    setState(() {
      _cycle = BreathingPhase.hold;
      _instruction = "Tahan...";
    });
    // Tidak ada perubahan animasi
    _timer = Timer(const Duration(seconds: 2), _exhale); // Hembuskan setelah 2 detik
  }
  
  void _exhale() {
    if (!mounted) return;
    setState(() {
      _cycle = BreathingPhase.exhale;
      _instruction = "Hembuskan...";
    });
    _controller.reverse(); // Animasi mengecil
    _timer = Timer(const Duration(seconds: 4), _inhale); // Mulai lagi setelah 4 detik
  }


  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
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
              Colors.purple.shade900.withOpacity(0.4), // Warna gradasi ungu
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _instruction,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 60),
            // Lingkaran animasi
            Container(
              width: _animation.value,
              height: _animation.value,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient( // Gradasi radial ungu
                   colors: [
                     // Warna berbeda untuk setiap fase
                     _cycle == BreathingPhase.inhale ? Colors.purple.shade300 : 
                     _cycle == BreathingPhase.hold ? Colors.blue.shade300 : 
                     Colors.purple.shade300,
                     _cycle == BreathingPhase.inhale ? Colors.purple.shade700 :
                     _cycle == BreathingPhase.hold ? Colors.blue.shade700 :
                     Colors.purple.shade700,
                   ]
                )
              ),
            ),
             const SizedBox(height: 60),
             // Tombol Reset/Stop (opsional)
             TextButton.icon(
               icon: const Icon(Icons.refresh, color: Colors.white70),
               label: const Text('Mulai Ulang', style: TextStyle(color: Colors.white70)),
               onPressed: _startBreathingCycle,
             )
          ],
        ),
      ),
    );
  }
}