import 'package:camera/camera.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final availableCamerasProvider = FutureProvider<List<CameraDescription>>((
  ref,
) async {
  return await availableCameras();
});

final cameraControllerProvider = FutureProvider.autoDispose<CameraController>((
  ref,
) async {
  final cameras = await ref.watch(availableCamerasProvider.future);

  if (cameras.isEmpty) {
    throw Exception('No camera found on this device.');
  }

  final controller = CameraController(
    cameras.first,
    ResolutionPreset.medium,
    enableAudio: false,
  );

  await controller.initialize();

  ref.onDispose(() => controller.dispose());

  return controller;
});
