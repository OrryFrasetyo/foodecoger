import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:submission/features/food_recognition/presentation/pages/result_page.dart';
import '../providers/camera_provider.dart';

class CameraPage extends ConsumerWidget {
  const CameraPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cameraState = ref.watch(cameraControllerProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(
          'Camera Feed',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Colors.black,
      body: cameraState.when(
        data: (CameraController controller) {
          return Stack(
            fit: StackFit.expand,
            children: [
              CameraPreview(controller),
              Positioned(
                bottom: 40,
                left: 0,
                right: 0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Arahkan ke makanan",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        backgroundColor: Colors.black54,
                      ),
                    ),
                    SizedBox(height: 20),

                    FloatingActionButton(
                      backgroundColor: Colors.deepOrange,
                      shape: CircleBorder(),
                      onPressed: () async {
                        if (!controller.value.isInitialized) return;

                        try {
                          final XFile rawImage = await controller.takePicture();

                          CroppedFile? croppedFile = await ImageCropper()
                              .cropImage(
                                sourcePath: rawImage.path,
                                aspectRatio: const CropAspectRatio(
                                  ratioX: 1,
                                  ratioY: 1,
                                ),
                                uiSettings: [
                                  AndroidUiSettings(
                                    toolbarTitle: 'Crop Food Image',
                                    toolbarColor: Colors.deepOrange,
                                    toolbarWidgetColor: Colors.white,
                                    initAspectRatio:
                                        CropAspectRatioPreset.square,
                                    lockAspectRatio: true,
                                  ),
                                  IOSUiSettings(title: 'Crop Food Image'),
                                ],
                              );

                          if (croppedFile != null) {
                            if (context.mounted) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ResultPage(imagePath: croppedFile.path),
                                ),
                              );
                            }
                          }
                        } catch (e) {
                          debugPrint("Error taking picture: $e");
                        }
                      },
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
        loading: () =>
            const Center(child: CircularProgressIndicator(color: Colors.white)),
        error: (error, stackTrace) => Center(
          child: Text(
            'Error: ${error.toString()}',
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ),
    );
  }
}
