import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class SelectedImageNotifier extends Notifier<String?> {
  @override
  String? build() {
    return null;
  }

  Future<void> pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      await _cropImage(pickedFile.path);
    }
  }

  Future<void> _cropImage(String sourcePath) async {
    final CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: sourcePath,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Your Food',
          toolbarColor: Colors.deepPurple,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: false,
        ),
        IOSUiSettings(title: 'Crop Your Food'),
      ],
    );

    if (croppedFile != null) {
      state = croppedFile.path;
    }
  }
}

final selectedImageProvider = NotifierProvider<SelectedImageNotifier, String?>(
  () => SelectedImageNotifier(),
);
