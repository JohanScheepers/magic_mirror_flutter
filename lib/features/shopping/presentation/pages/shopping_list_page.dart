import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';
import '../state/shopping_list_state.dart';

import '../../../../core/presentation/widgets/mirror_scaffold.dart';

class ShoppingListPage extends StatefulWidget {
  const ShoppingListPage({super.key});

  @override
  State<ShoppingListPage> createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addItem() {
    if (_controller.text.trim().isNotEmpty) {
      ShoppingListState.addItem(_controller.text);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MirrorScaffold(
      appBar: AppBar(
        title: const Text('Shopping List'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Watch((context) {
            final hasCompleted = ShoppingListState.completedItemCount > 0;
            return hasCompleted
                ? IconButton(
                    icon: const Icon(Icons.delete_sweep),
                    tooltip: 'Clear completed',
                    onPressed: () {
                      ShoppingListState.clearCompleted();
                    },
                  )
                : const SizedBox.shrink();
          }),
        ],
      ),
      body: Column(
        children: [
          // Add item section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Add item...',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onSubmitted: (_) => _addItem(),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton.icon(
                  onPressed: _addItem,
                  icon: const Icon(Icons.add),
                  label: const Text('Add'),
                ),
              ],
            ),
          ),

          // Suggestions section
          Watch((context) {
            final suggestions = ShoppingListState.suggestions.value;
            if (suggestions.isEmpty) return const SizedBox.shrink();

            return Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Suggestions',
                    style: Theme.of(
                      context,
                    ).textTheme.labelLarge?.copyWith(color: Colors.white70),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: suggestions.map((suggestion) {
                      return ActionChip(
                        label: Text(suggestion),
                        avatar: const Icon(Icons.add, size: 16),
                        onPressed: () {
                          ShoppingListState.addItem(suggestion);
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            );
          }),

          const Divider(color: Colors.white24),

          // Items list
          Expanded(
            child: Watch((context) {
              final items = ShoppingListState.items.value;

              if (items.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_cart_outlined,
                        size: 64,
                        color: Colors.white38,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Your shopping list is empty',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(color: Colors.white54),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Add items to get started',
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(color: Colors.white38),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Dismissible(
                    key: Key(item.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 16),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (_) {
                      ShoppingListState.deleteItem(item.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${item.name} deleted'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    child: CheckboxListTile(
                      value: item.isCompleted,
                      onChanged: (_) {
                        ShoppingListState.toggleItem(item.id);
                      },
                      title: Text(
                        item.name,
                        style: TextStyle(
                          decoration: item.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                          color: item.isCompleted
                              ? Colors.white54
                              : Colors.white,
                        ),
                      ),
                      secondary: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () {
                          ShoppingListState.deleteItem(item.id);
                        },
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
