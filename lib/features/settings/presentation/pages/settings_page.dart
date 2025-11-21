import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';
import '../../../../core/state/app_state.dart';
import '../../../shopping/shopping.dart';
import '../../../timer/timer.dart';
import '../../../recipes/recipes.dart';
import '../../../calculator/calculator.dart';

import '../../../../core/presentation/widgets/mirror_scaffold.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MirrorScaffold(
      appBar: AppBar(
        title: const Text('Menu'),
        backgroundColor: Colors.transparent, // Transparent AppBar
        elevation: 0,
      ),
      body: ListView(
        children: [
          Watch(
            (context) => SwitchListTile(
              title: const Text(
                'Show Clock',
                style: TextStyle(color: Colors.white),
              ),
              value: AppState.showClock.value,
              onChanged: (value) => AppState.showClock.value = value,
            ),
          ),
          Watch(
            (context) => SwitchListTile(
              title: const Text(
                'Show Weather',
                style: TextStyle(color: Colors.white),
              ),
              value: AppState.showWeather.value,
              onChanged: (value) => AppState.showWeather.value = value,
            ),
          ),
          Watch(
            (context) => SwitchListTile(
              title: const Text(
                'Show Shopping List',
                style: TextStyle(color: Colors.white),
              ),
              value: AppState.showShoppingList.value,
              onChanged: (value) => AppState.showShoppingList.value = value,
            ),
          ),
          const Divider(color: Colors.white24),
          ListTile(
            leading: const Icon(Icons.shopping_cart, color: Colors.white),
            title: const Text(
              'Manage Shopping List',
              style: TextStyle(color: Colors.white),
            ),
            subtitle: const Text(
              'Add and organize items',
              style: TextStyle(color: Colors.white70),
            ),
            trailing: const Icon(Icons.chevron_right, color: Colors.white54),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ShoppingListPage(),
                ),
              );
            },
          ),
          const Divider(color: Colors.white24),
          ListTile(
            leading: const Icon(Icons.timer, color: Colors.white),
            title: const Text('Timer', style: TextStyle(color: Colors.white)),
            subtitle: const Text(
              'Set countdown timer',
              style: TextStyle(color: Colors.white70),
            ),
            trailing: const Icon(Icons.chevron_right, color: Colors.white54),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const TimerPage()),
              );
            },
          ),
          const Divider(color: Colors.white24),
          ListTile(
            leading: const Icon(Icons.restaurant_menu, color: Colors.white),
            title: const Text('Recipes', style: TextStyle(color: Colors.white)),
            subtitle: const Text(
              'Manage cooking recipes',
              style: TextStyle(color: Colors.white70),
            ),
            trailing: const Icon(Icons.chevron_right, color: Colors.white54),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const RecipeListPage()),
              );
            },
          ),
          const Divider(color: Colors.white24),
          ListTile(
            leading: const Icon(Icons.calculate, color: Colors.white),
            title: const Text(
              'Calculator',
              style: TextStyle(color: Colors.white),
            ),
            subtitle: const Text(
              'Standard calculator',
              style: TextStyle(color: Colors.white70),
            ),
            trailing: const Icon(Icons.chevron_right, color: Colors.white54),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const CalculatorPage()),
              );
            },
          ),
          const Divider(color: Colors.white24),
          ListTile(
            title: const Text(
              'Weather API Key',
              style: TextStyle(color: Colors.white),
            ),
            subtitle: const Text(
              'Not configured',
              style: TextStyle(color: Colors.white70),
            ),
            trailing: const Icon(Icons.chevron_right, color: Colors.white54),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
