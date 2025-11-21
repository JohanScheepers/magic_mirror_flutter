import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';
import '../state/shopping_list_state.dart';
import '../pages/shopping_list_page.dart';

class ShoppingListWidget extends StatelessWidget {
  const ShoppingListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Watch((context) {
      if (ShoppingListState.isLoading.value) {
        return const SizedBox.shrink();
      }

      final activeItems = ShoppingListState.items.value
          .where((item) => !item.isCompleted)
          .toList();

      if (activeItems.isEmpty) {
        return const SizedBox.shrink();
      }

      // Show max 4 items in compact view
      final displayItems = activeItems.take(4).toList();
      final remainingCount = activeItems.length - displayItems.length;

      return GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const ShoppingListPage()),
          );
        },
        child: Container(
          constraints: const BoxConstraints(maxWidth: 250),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Shopping List',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...displayItems.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        item.isCompleted
                            ? Icons.check_box
                            : Icons.check_box_outline_blank,
                        color: Colors.white70,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          item.name,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            decoration: item.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (remainingCount > 0)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    '+ $remainingCount more item${remainingCount > 1 ? 's' : ''}',
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }
}
