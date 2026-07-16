import '../datasources/ml_data_source.dart';
import '../../domain/entities/food_classification_entity.dart';
import '../../domain/repositories/food_repository.dart';

class FoodRepositoryImpl implements FoodRepository {
  final MlDataSource mlDataSource;

  FoodRepositoryImpl({required this.mlDataSource});

  @override
  Future<FoodClassificationEntity> classifyImage(String imagePath) async {
    final modelPath = await mlDataSource.downloadModel();
    final rawResult = await mlDataSource.analyzeFoodImage(imagePath, modelPath);

    return FoodClassificationEntity(
      foodName: rawResult['food_name'],
      confidence: rawResult['confidence'],
    );
  }
}
