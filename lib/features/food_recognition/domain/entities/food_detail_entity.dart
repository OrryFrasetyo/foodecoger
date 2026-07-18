class FoodDetailEntity {
  final String mealName;
  final String mealThumb;
  final String instructions;
  final List<Map<String, String>> ingredients;

  final String calories;
  final String carbs;
  final String fat;
  final String fiber;
  final String protein;

  FoodDetailEntity({
    required this.mealName,
    required this.mealThumb,
    required this.instructions,
    required this.ingredients,
    required this.calories,
    required this.carbs,
    required this.fat,
    required this.fiber,
    required this.protein,
  });
}
