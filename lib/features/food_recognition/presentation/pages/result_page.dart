import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/inference_provider.dart';
import '../widgets/classification_item.dart';

class ResultPage extends ConsumerWidget {
  final String imagePath;

  const ResultPage({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final classificationState = ref.watch(
      foodClassificationProvider(imagePath),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Result Page'),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Center(
                child: Image.file(File(imagePath), fit: BoxFit.cover),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: classificationState.when(
                data: (entity) {
                  return ClassificatioinItem(
                    item: entity.foodName,
                    value: entity.confidence,
                  );
                },
                loading: () => const ClassificatioinItemShimmer(),
                error: (error, stackTrace) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Error analyzing image: $error",
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
