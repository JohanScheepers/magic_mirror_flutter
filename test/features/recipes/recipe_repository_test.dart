import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:magic_mirror/features/recipes/data/models/recipe.dart';
import 'package:magic_mirror/features/recipes/data/recipe_repository.dart';

void main() {
  group('RecipeRepository', () {
    late RecipeRepository repository;
    late SharedPreferences prefs;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      repository = RecipeRepository(prefs);
    });

    test('starts empty', () async {
      final recipes = await repository.getRecipes();
      expect(recipes, isEmpty);
    });

    test('can add and retrieve a recipe', () async {
      final recipe = Recipe(title: 'Test Recipe', content: 'Test Content');
      await repository.addRecipe(recipe);

      final recipes = await repository.getRecipes();
      expect(recipes.length, 1);
      expect(recipes.first.title, 'Test Recipe');
      expect(recipes.first.content, 'Test Content');
    });

    test('can delete a recipe', () async {
      final recipe = Recipe(title: 'Test Recipe', content: 'Test Content');
      await repository.addRecipe(recipe);

      var recipes = await repository.getRecipes();
      expect(recipes.length, 1);

      await repository.deleteRecipe(recipes.first.id);

      recipes = await repository.getRecipes();
      expect(recipes, isEmpty);
    });

    test('can update a recipe', () async {
      final recipe = Recipe(title: 'Original', content: 'Content');
      await repository.addRecipe(recipe);

      final savedRecipe = (await repository.getRecipes()).first;
      final updatedRecipe = savedRecipe.copyWith(title: 'Updated');

      await repository.updateRecipe(updatedRecipe);

      final recipes = await repository.getRecipes();
      expect(recipes.first.title, 'Updated');
    });
  });
}
