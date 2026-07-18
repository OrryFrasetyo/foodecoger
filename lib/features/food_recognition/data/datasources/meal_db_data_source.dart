import 'dart:convert';

import 'package:http/http.dart' as http;
import '../models/meal_db_model.dart';

class MealDbDataSource {
  Future<MealDbModel?> searchMeal(String foodName) async {
    final url = Uri.parse(
      'https://www.themealdb.com/api/json/v1/1/search.php?s=$foodName',
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['meals'] != null) {
        return MealDbModel.fromJson(data['meals'][0]);
      }
      return null;
    } else {
      throw Exception('Failed to load data from MealDB');
    }
  }
}
