import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';

class PedometerPage extends StatefulWidget {
  const PedometerPage({super.key});

  @override
  State<PedometerPage> createState() => _PedometerPageState();
}

class _PedometerPageState extends State<PedometerPage> {
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  
  String _status = 'Diam';
  String _steps = '0';
  double _distanceKm = 0.0;
  
  int _initialSteps = -1;
  int _sessionSteps = 0;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    // Minta Izin Activity Recognition
    if (await Permission.activityRecognition.request().isGranted) {
      
      try {
        // Init Stream Penghitung Langkah
        _stepCountStream = Pedometer.stepCountStream;
        _stepCountStream.listen(onStepCount).onError(onStepCountError);

        // Init Stream Status
        _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
        _pedestrianStatusStream.listen(onPedestrianStatusChanged).onError(onPedestrianStatusError);
      } catch (e) {
        setState(() {
          _steps = "Sensor Error";
        });
      }
      
    } else {
      setState(() {
        _steps = "Izin Ditolak";
      });
    }
  }

  void onStepCount(StepCount event) {
    setState(() {
      if (_initialSteps == -1) {
        _initialSteps = event.steps;
      }
      _sessionSteps = event.steps - _initialSteps;
      
      // Jika hasil negatif (misal HP restart), reset
      if (_sessionSteps < 0) _sessionSteps = 0;

      _steps = _sessionSteps.toString();
      _distanceKm = (_sessionSteps * 0.762) / 1000; 
    });
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    setState(() {
      _status = (event.status == 'walking') ? 'Sedang Berjalan' : 'Diam';
    });
  }

  void onStepCountError(error) {
    setState(() {
      _steps = 'Sensor Error';
    });
  }

  void onPedestrianStatusError(error) {
    setState(() {
      _status = 'Status Error';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Penghitung Langkah"), centerTitle: true),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _status == 'Sedang Berjalan' ? Icons.directions_walk : Icons.accessibility_new,
                size: 80,
                color: _status == 'Sedang Berjalan' ? Colors.green : Colors.grey,
              ),
              const SizedBox(height: 16),
              Text(
                _status,
                style: TextStyle(
                  fontSize: 18, 
                  fontWeight: FontWeight.bold,
                  color: _status == 'Sedang Berjalan' ? Colors.green : Colors.grey
                ),
              ),
              const SizedBox(height: 48),

              // --- PERBAIKAN DI SINI (Ganti Icon) ---
              _buildInfoCard(Icons.directions_walk, "Langkah (Sesi Ini)", "$_steps Langkah", Colors.orange),
              // --------------------------------------
              
              const SizedBox(height: 16),

              _buildInfoCard(Icons.map, "Jarak Tempuh", "${_distanceKm.toStringAsFixed(3)} km", Colors.blue),
              
              const SizedBox(height: 24),
              const Text(
                "*Catatan: Penghitungan dimulai dari 0 saat Anda membuka halaman ini.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 12),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String title, String value, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3), width: 1),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 30),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
                const SizedBox(height: 4),
                Text(
                  value, 
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}