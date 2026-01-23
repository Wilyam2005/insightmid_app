// lib/features/insightmind/presentation/pages/mood_checkin_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'mood_result_page.dart';

final cameraControllerProvider = FutureProvider<CameraController>((ref) async {
  final cameras = await availableCameras();
  final frontCamera = cameras.firstWhere(
    (cam) => cam.lensDirection == CameraLensDirection.front,
    orElse: () => cameras.first,
  );

  final controller = CameraController(
    frontCamera,
    ResolutionPreset.medium,
    enableAudio: false,
  );

  ref.onDispose(() {
    controller.dispose();
  });

  await controller.initialize();

  // optional: cegah auto zoom jika device mendukung
  try {
    final minZoom = await controller.getMinZoomLevel();
    await controller.setZoomLevel(minZoom);

    if (minZoom <= 1.0) {
      await controller.setZoomLevel(1.0);
    }
  } catch (_) {}

  return controller;
});

class MoodCheckinPage extends ConsumerWidget {
  const MoodCheckinPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cameraControllerAsync = ref.watch(cameraControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Jurnal Mood Anda'),
        centerTitle: true,
      ),
      body: cameraControllerAsync.when(
        data: (controller) {
          if (!controller.value.isInitialized) {
            return const Center(child: CircularProgressIndicator());
          }

          return Stack(
            fit: StackFit.expand,
            children: [
              // ⭐ FIX: Ganti Transform.scale -> FittedBox (anti zoom)
              FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: controller.value.previewSize!.height,
                  height: controller.value.previewSize!.width,
                  child: CameraPreview(controller),
                ),
              ),

              _buildInstructions(),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Text('Error inisialisasi kamera: $err'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.camera_alt),
        onPressed: () async {
          if (cameraControllerAsync.hasValue) {
            await _onTakePicture(context, ref, cameraControllerAsync.value!);
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildInstructions() {
    return Container(
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: const Text(
          'Posisikan wajah Anda di kamera dan tekan tombol untuk check-in mood.',
          style: TextStyle(color: Colors.white, fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Future<void> _onTakePicture(
      BuildContext context, WidgetRef ref, CameraController controller) async {
    try {
      final XFile imageFile = await controller.takePicture();
      final inputImage = InputImage.fromFilePath(imageFile.path);

      final options = FaceDetectorOptions(
        enableClassification: true,
      );
      final faceDetector = FaceDetector(options: options);

      final List<Face> faces = await faceDetector.processImage(inputImage);
      await faceDetector.close();

      double smileProbability = 0.0;
      if (faces.isNotEmpty) {
        smileProbability = faces.first.smilingProbability ?? 0.0;
      }

      if (context.mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MoodResultPage(
              imagePath: imageFile.path,
              smileProbability: smileProbability,
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error mengambil gambar: $e')),
      );
    }
  }
}
