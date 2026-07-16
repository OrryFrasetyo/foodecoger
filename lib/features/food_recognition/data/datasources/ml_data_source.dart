import 'dart:io';
import 'dart:isolate';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class MlDataSource {
  final String _modelUrl =
      "https://food-recognizer-app-4f1bd.web.app/model.tflite";

  Future<String> downloadModel() async {
    final directory = await getApplicationDocumentsDirectory();
    final modelFile = File('${directory.path}/model.tflite');

    if (!await modelFile.exists()) {
      debugPrint("Downloading model from Cloud...");
      final response = await http.get(Uri.parse(_modelUrl));

      if (response.statusCode == 200) {
        await modelFile.writeAsBytes(response.bodyBytes);
        debugPrint("Model downloaded successfully!");
      } else {
        throw Exception("Failed to download model from cloud");
      }
    }
    return modelFile.path;
  }

  Future<Map<String, dynamic>> analyzeFoodImage(
    String imagePath,
    String modelPath,
  ) async {
    final labelData = await rootBundle.loadString(
      'assets/labels/probability-labels-en.txt',
    );
    final labels = labelData.split('\n').where((e) => e.isNotEmpty).toList();

    return await Isolate.run(() async {
      final interpreter = Interpreter.fromFile(File(modelPath));

      final rawImage = await File(imagePath).readAsBytes();
      final decodedImage = img.decodeImage(rawImage);
      if (decodedImage == null) throw Exception("Failed to decode image.");

      final resizedImage = img.copyResize(
        decodedImage,
        width: 224,
        height: 224,
      );

      var inputTensor = List.generate(
        1,
        (batch) => List.generate(
          224,
          (y) => List.generate(224, (x) {
            final pixel = resizedImage.getPixelSafe(x, y);

            return [pixel.r.toInt(), pixel.g.toInt(), pixel.b.toInt()];
          }),
        ),
      );

      var outputTensor = List.generate(1, (i) => List.filled(2024, 0));

      interpreter.run(inputTensor, outputTensor);
      interpreter.close();

      final List<int> probabilities = outputTensor[0];
      int maxConfidence = 0;
      int maxIndex = 0;

      for (int i = 0; i < probabilities.length; i++) {
        if (probabilities[i] > maxConfidence) {
          maxConfidence = probabilities[i];
          maxIndex = i;
        }
      }

      final foodName = labels.length > maxIndex ? labels[maxIndex] : "Unknown";

      final percentage = (maxConfidence / 255.0) * 100.0;

      return {
        "food_name": foodName.trim(),
        "confidence": "${percentage.toStringAsFixed(2)}%",
      };
    });
  }
}
