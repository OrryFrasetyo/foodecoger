import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/gemini_data_source.dart';
import '../../data/datasources/meal_db_data_source.dart';
import '../../data/repositories/food_detail_repository_impl.dart';
import '../../domain/entities/food_detail_entity.dart';
import '../../domain/repositories/food_detail_repository.dart';

final mealDbDataSourceProvider = Provider((ref) => MealDbDataSource());
final geminiDataSourceProvider = Provider((ref) => GeminiDataSource());

final foodDetailRepositoryProvider = Provider<FoodDetailRepository>((ref) {
  return FoodDetailRepositoryImpl(
    mealDbDataSource: ref.watch(mealDbDataSourceProvider),
    geminiDataSource: ref.watch(geminiDataSourceProvider),
  );
});

final foodDetailProvider = FutureProvider.family<FoodDetailEntity, String>((
  ref,
  foodname,
) async {
  final repository = ref.watch(foodDetailRepositoryProvider);
  return repository.getFoodDetail(foodname);
});
