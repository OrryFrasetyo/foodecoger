import 'dart:convert';

import 'package:firebase_ai/firebase_ai.dart';

class GeminiDataSource {
  Future<Map<String, String>> getNutritionFacts(String foodName) async {
    final model = FirebaseAI.googleAI().generativeModel(
      model: 'gemini-3.5-flash',
    );

    final prompt =
        '''
    Provide the estimated standard nutrition facts for one serving of: $foodName.
    Return ONLY a valid JSON object matching exactly this structure without any markdown blocks or additional text:
    {
      "calories": "xxx kcal",
      "carbs": "xxx g",
      "fat": "xxx g",
      "fiber": "xxx g",
      "protein": "xxx g"
    }
    ''';

    final response = await model.generateContent([Content.text(prompt)]);
    final responseText = response.text;

    if (responseText != null) {
      try {
        final cleanedText = responseText
            .replaceAll('```json', '')
            .replaceAll('```', '')
            .trim();
        final Map<String, dynamic> jsonData = json.decode(cleanedText);

        return {
          "calories": jsonData['calories']?.toString() ?? "-",
          "carbs": jsonData['carbs']?.toString() ?? "-",
          "fat": jsonData['fat']?.toString() ?? "-",
          "fiber": jsonData['fiber']?.toString() ?? "-",
          "protein": jsonData['protein']?.toString() ?? "-",
        };
      } catch (e) {
        throw Exception('Gagal mem-parsing respons Gemini: $e');
      }
    } else {
      throw Exception('Gemini mengembalikan respons kosong.');
    }
  }
}
