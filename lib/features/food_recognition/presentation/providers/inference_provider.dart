import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/ml_data_source.dart';
import '../../data/repositories/food_repository_impl.dart';
import '../../domain/entities/food_classification_entity.dart';
import '../../domain/repositories/food_repository.dart';

final mlDataSourceProvider = Provider<MlDataSource>((ref) => MlDataSource());

final foodRepositoryProvider = Provider<FoodRepository>((ref) {
  final dataSource = ref.watch(mlDataSourceProvider);
  return FoodRepositoryImpl(mlDataSource: dataSource);
});

final foodClassificationProvider =
    FutureProvider.family<FoodClassificationEntity, String>((
      ref,
      imagePath,
    ) async {
      final repository = ref.watch(foodRepositoryProvider);
      return await repository.classifyImage(imagePath);
    });
