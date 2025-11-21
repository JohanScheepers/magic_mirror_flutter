import 'package:shared_preferences/shared_preferences.dart';
import 'package:signals_flutter/signals_flutter.dart';
import '../../data/models/shopping_item.dart';
import '../../data/shopping_list_repository.dart';

class ShoppingListState {
  static ShoppingListRepository? _repository;

  // State signals
  static final items = signal<List<ShoppingItem>>([]);
  static final suggestions = signal<List<String>>([]);
  static final isLoading = signal(false);
  static final error = signal<String?>(null);

  /// Initialize the shopping list state
  static Future<void> initialize() async {
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      _repository = ShoppingListRepository(prefs);

      // Load existing items
      await loadItems();

      // Load suggestions
      await loadSuggestions();

      isLoading.value = false;
    } catch (e) {
      error.value = 'Failed to initialize shopping list: $e';
      isLoading.value = false;
    }
  }

  /// Load items from storage
  static Future<void> loadItems() async {
    if (_repository == null) return;
    try {
      final loadedItems = await _repository!.getItems();
      items.value = loadedItems;
    } catch (e) {
      error.value = 'Failed to load items: $e';
    }
  }

  /// Load suggestions based on frequency
  static Future<void> loadSuggestions() async {
    if (_repository == null) return;
    try {
      final loadedSuggestions = await _repository!.getSuggestions(limit: 10);
      suggestions.value = loadedSuggestions;
    } catch (e) {
      error.value = 'Failed to load suggestions: $e';
    }
  }

  /// Add a new item
  static Future<void> addItem(String itemName) async {
    if (_repository == null) return;
    if (itemName.trim().isEmpty) return;

    try {
      final newItem = ShoppingItem(name: itemName.trim());
      await _repository!.addItem(newItem);
      await loadItems();
      await loadSuggestions(); // Update suggestions after adding
    } catch (e) {
      error.value = 'Failed to add item: $e';
    }
  }

  /// Toggle item completion status
  static Future<void> toggleItem(String itemId) async {
    if (_repository == null) return;

    try {
      final item = items.value.firstWhere((item) => item.id == itemId);
      final updatedItem = item.copyWith(isCompleted: !item.isCompleted);
      await _repository!.updateItem(updatedItem);
      await loadItems();
    } catch (e) {
      error.value = 'Failed to toggle item: $e';
    }
  }

  /// Delete an item
  static Future<void> deleteItem(String itemId) async {
    if (_repository == null) return;

    try {
      await _repository!.deleteItem(itemId);
      await loadItems();
      await loadSuggestions(); // Update suggestions after deletion
    } catch (e) {
      error.value = 'Failed to delete item: $e';
    }
  }

  /// Clear all completed items
  static Future<void> clearCompleted() async {
    if (_repository == null) return;

    try {
      await _repository!.clearCompleted();
      await loadItems();
    } catch (e) {
      error.value = 'Failed to clear completed items: $e';
    }
  }

  /// Get count of active (not completed) items
  static int get activeItemCount {
    return items.value.where((item) => !item.isCompleted).length;
  }

  /// Get count of completed items
  static int get completedItemCount {
    return items.value.where((item) => item.isCompleted).length;
  }

  /// Clear all data (for testing/reset)
  static Future<void> clearAll() async {
    if (_repository == null) return;
    await _repository!.clearAll();
    items.value = [];
    suggestions.value = [];
  }
}
