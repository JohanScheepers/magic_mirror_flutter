import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/recipe.dart';

class RecipeRepository {
  static const String _recipesKey = 'recipes_list';

  final SharedPreferences _prefs;

  RecipeRepository(this._prefs);

  /// Get all recipes
  Future<List<Recipe>> getRecipes() async {
    final jsonString = _prefs.getString(_recipesKey);
    if (jsonString == null) return [];

    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((json) => Recipe.fromJson(json)).toList();
  }

  /// Save recipes
  Future<void> saveRecipes(List<Recipe> recipes) async {
    final jsonList = recipes.map((item) => item.toJson()).toList();
    final jsonString = jsonEncode(jsonList);
    await _prefs.setString(_recipesKey, jsonString);
  }

  /// Add a new recipe
  Future<void> addRecipe(Recipe recipe) async {
    final recipes = await getRecipes();
    recipes.add(recipe);
    await saveRecipes(recipes);
  }

  /// Update an existing recipe
  Future<void> updateRecipe(Recipe updatedRecipe) async {
    final recipes = await getRecipes();
    final index = recipes.indexWhere((item) => item.id == updatedRecipe.id);
    if (index != -1) {
      recipes[index] = updatedRecipe;
      await saveRecipes(recipes);
    }
  }

  /// Delete a recipe
  Future<void> deleteRecipe(String recipeId) async {
    final recipes = await getRecipes();
    recipes.removeWhere((item) => item.id == recipeId);
    await saveRecipes(recipes);
  }

  /// Clear all recipes (for testing)
  Future<void> clearAll() async {
    await _prefs.remove(_recipesKey);
  }
}
