import '../entities/food_classification_entity.dart';

abstract class FoodRepository {
  Future<FoodClassificationEntity> classifyImage(String imagePath);
}
