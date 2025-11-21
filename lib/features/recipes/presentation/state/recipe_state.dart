import 'package:shared_preferences/shared_preferences.dart';
import 'package:signals_flutter/signals_flutter.dart';
import '../../data/models/recipe.dart';
import '../../data/recipe_repository.dart';

class RecipeState {
  static RecipeRepository? _repository;

  // State signals
  static final recipes = signal<List<Recipe>>([]);
  static final isLoading = signal(false);
  static final error = signal<String?>(null);

  /// Initialize the recipe state
  static Future<void> initialize() async {
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      _repository = RecipeRepository(prefs);

      // Load existing recipes
      await loadRecipes();

      isLoading.value = false;
    } catch (e) {
      error.value = 'Failed to initialize recipes: $e';
      isLoading.value = false;
    }
  }

  /// Load recipes from storage
  static Future<void> loadRecipes() async {
    if (_repository == null) return;
    try {
      final loadedRecipes = await _repository!.getRecipes();
      // Sort by newest first
      loadedRecipes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      recipes.value = loadedRecipes;
    } catch (e) {
      error.value = 'Failed to load recipes: $e';
    }
  }

  /// Add a new recipe
  static Future<void> addRecipe(String title, String content) async {
    if (_repository == null) return;
    if (title.trim().isEmpty || content.trim().isEmpty) return;

    try {
      final newRecipe = Recipe(title: title.trim(), content: content.trim());
      await _repository!.addRecipe(newRecipe);
      await loadRecipes();
    } catch (e) {
      error.value = 'Failed to add recipe: $e';
    }
  }

  /// Delete a recipe
  static Future<void> deleteRecipe(String recipeId) async {
    if (_repository == null) return;

    try {
      await _repository!.deleteRecipe(recipeId);
      await loadRecipes();
    } catch (e) {
      error.value = 'Failed to delete recipe: $e';
    }
  }
}
