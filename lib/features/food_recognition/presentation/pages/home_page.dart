import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'camera_page.dart';
import 'result_page.dart';
import '../providers/home_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(
          'Food Recognizer App',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CameraPage()),
              );
            },
            icon: const Icon(Icons.camera_alt),
            tooltip: 'Live Camera',
          ),
        ],
      ),
      body: const SafeArea(
        child: Padding(padding: EdgeInsets.all(8.0), child: _HomeBody()),
      ),
    );
  }
}

class _HomeBody extends ConsumerWidget {
  const _HomeBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imagePath = ref.watch(selectedImageProvider);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Center(
            child: GestureDetector(
              onTap: () {
                ref.read(selectedImageProvider.notifier).pickImageFromGallery();
              },
              child: imagePath != null
                  ? Image.file(File(imagePath), fit: BoxFit.cover)
                  : const Icon(Icons.image, size: 100, color: Colors.grey),
            ),
          ),
        ),
        FilledButton.tonal(
          onPressed: () {
            if (imagePath != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ResultPage(imagePath: imagePath),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Please select an image first!")),
              );
            }
          },
          child: const Text(
            "Analyze",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
