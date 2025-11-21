import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/shopping_item.dart';

class ShoppingListRepository {
  static const String _itemsKey = 'shopping_list_items';
  static const String _frequencyKey = 'shopping_item_frequency';

  final SharedPreferences _prefs;

  ShoppingListRepository(this._prefs);

  /// Get all shopping list items
  Future<List<ShoppingItem>> getItems() async {
    final jsonString = _prefs.getString(_itemsKey);
    if (jsonString == null) return [];

    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((json) => ShoppingItem.fromJson(json)).toList();
  }

  /// Save shopping list items
  Future<void> saveItems(List<ShoppingItem> items) async {
    final jsonList = items.map((item) => item.toJson()).toList();
    final jsonString = jsonEncode(jsonList);
    await _prefs.setString(_itemsKey, jsonString);
  }

  /// Add a new item to the list
  Future<void> addItem(ShoppingItem item) async {
    final items = await getItems();
    items.add(item);
    await saveItems(items);

    // Update frequency for suggestions
    await _incrementItemFrequency(item.name);
  }

  /// Update an existing item
  Future<void> updateItem(ShoppingItem updatedItem) async {
    final items = await getItems();
    final index = items.indexWhere((item) => item.id == updatedItem.id);
    if (index != -1) {
      items[index] = updatedItem;
      await saveItems(items);
    }
  }

  /// Delete an item
  Future<void> deleteItem(String itemId) async {
    final items = await getItems();
    items.removeWhere((item) => item.id == itemId);
    await saveItems(items);
  }

  /// Clear all completed items
  Future<void> clearCompleted() async {
    final items = await getItems();
    items.removeWhere((item) => item.isCompleted);
    await saveItems(items);
  }

  /// Get item frequency map
  Future<Map<String, int>> getItemFrequency() async {
    final jsonString = _prefs.getString(_frequencyKey);
    if (jsonString == null) return {};

    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    return jsonMap.map((key, value) => MapEntry(key, value as int));
  }

  /// Save item frequency map
  Future<void> _saveItemFrequency(Map<String, int> frequency) async {
    final jsonString = jsonEncode(frequency);
    await _prefs.setString(_frequencyKey, jsonString);
  }

  /// Increment frequency count for an item
  Future<void> _incrementItemFrequency(String itemName) async {
    final frequency = await getItemFrequency();
    final normalizedName = itemName.trim().toLowerCase();
    frequency[normalizedName] = (frequency[normalizedName] ?? 0) + 1;
    await _saveItemFrequency(frequency);
  }

  /// Get suggested items based on frequency
  /// Excludes items already in the current list
  Future<List<String>> getSuggestions({int limit = 10}) async {
    final frequency = await getItemFrequency();
    final currentItems = await getItems();
    final currentItemNames = currentItems
        .map((item) => item.name.trim().toLowerCase())
        .toSet();

    // Sort by frequency (descending) and filter out current items
    final suggestions =
        frequency.entries
            .where((entry) => !currentItemNames.contains(entry.key))
            .toList()
          ..sort((a, b) => b.value.compareTo(a.value));

    // Return top N suggestions, capitalize first letter
    return suggestions
        .take(limit)
        .map((entry) => _capitalize(entry.key))
        .toList();
  }

  /// Capitalize first letter of each word
  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text
        .split(' ')
        .map((word) {
          if (word.isEmpty) return word;
          return word[0].toUpperCase() + word.substring(1);
        })
        .join(' ');
  }

  /// Clear all data (for testing/reset)
  Future<void> clearAll() async {
    await _prefs.remove(_itemsKey);
    await _prefs.remove(_frequencyKey);
  }
}
