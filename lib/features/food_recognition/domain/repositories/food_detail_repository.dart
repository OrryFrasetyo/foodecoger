import '../entities/food_detail_entity.dart';

abstract class FoodDetailRepository {
  Future<FoodDetailEntity> getFoodDetail(String predictedFoodName);
}
