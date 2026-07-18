class MealDbModel {
  final String mealName;
  final String mealThumb;
  final String instructions;
  final List<Map<String, String>> ingredients;

  MealDbModel({
    required this.mealName,
    required this.mealThumb,
    required this.instructions,
    required this.ingredients,
  });

  factory MealDbModel.fromJson(Map<String, dynamic> json) {
    List<Map<String, String>> extractedIngredients = [];
    for (int i = 1; i <= 20; i++) {
      final ingredient = json['strIngredient$i'];
      final measure = json['strMeasure$i'];

      if (ingredient != null && ingredient.toString().trim().isNotEmpty) {
        extractedIngredients.add({
          "ingredient": ingredient.toString().trim(),
          "measure": (measure ?? "").toString().trim(),
        });
      }
    }

    return MealDbModel(
      mealName: json['strMeal'] ?? "Unknown Meal",
      mealThumb: json['strMealThumb'] ?? "",
      instructions: json['strInstructions'] ?? "No instructions available.",
      ingredients: extractedIngredients,
    );
  }
}
