import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:submission/features/food_recognition/presentation/pages/result_page.dart';
import 'package:submission/features/food_recognition/presentation/providers/home_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Food Recognizer App'),
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
                // todo-01: tap this icon to open image picker feature
                // Nanti kita panggil fungsi dari image_picker di sini
                // dan update state: ref.read(selectedImageProvider.notifier).state = pathBaru;
              },
              child: imagePath != null
                  ? Text("Gambar terpilih: $imagePath")
                  : const Icon(Icons.image, size: 100),
            ),
          ),
        ),
        FilledButton.tonal(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ResultPage()),
            );
          },
          child: const Text("Analyze"),
        ),
      ],
    );
  }
}
