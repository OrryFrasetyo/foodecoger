import '../datasources/gemini_data_source.dart';
import '../datasources/meal_db_data_source.dart';
import '../models/meal_db_model.dart';
import '../../domain/entities/food_detail_entity.dart';
import '../../domain/repositories/food_detail_repository.dart';

class FoodDetailRepositoryImpl implements FoodDetailRepository {
  final MealDbDataSource mealDbDataSource;
  final GeminiDataSource geminiDataSource;

  FoodDetailRepositoryImpl({
    required this.mealDbDataSource,
    required this.geminiDataSource,
  });

  @override
  Future<FoodDetailEntity> getFoodDetail(String predictedFoodName) async {
    final results = await Future.wait([
      mealDbDataSource.searchMeal(predictedFoodName),
      geminiDataSource.getNutritionFacts(predictedFoodName),
    ]);

    final mealData = results[0] as MealDbModel?;
    final nutritionData = results[1] as Map<String, String>;

    return FoodDetailEntity(
      mealName: mealData?.mealName ?? predictedFoodName,
      mealThumb:
          mealData?.mealThumb ?? "", 
      instructions:
          mealData?.instructions ??
          "Recipe instructions are not available for this item.",
      ingredients: mealData?.ingredients ?? [],
      calories: nutritionData['calories'] ?? "-",
      carbs: nutritionData['carbs'] ?? "-",
      fat: nutritionData['fat'] ?? "-",
      fiber: nutritionData['fiber'] ?? "-",
      protein: nutritionData['protein'] ?? "-",
    );
  }
}
