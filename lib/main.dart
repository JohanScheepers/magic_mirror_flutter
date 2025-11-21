import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'features/dashboard/dashboard.dart';
import 'features/weather/weather.dart';
import 'features/shopping/shopping.dart';
import 'features/recipes/recipes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize weather state and start periodic updates
  WeatherState.initialize();

  // Initialize shopping list state
  await ShoppingListState.initialize();

  // Initialize recipe state
  await RecipeState.initialize();

  runApp(const MagicMirrorApp());
}

class MagicMirrorApp extends StatelessWidget {
  const MagicMirrorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Magic Mirror',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        textTheme: GoogleFonts.robotoTextTheme(
          Theme.of(context).textTheme.apply(
            bodyColor: Colors.white,
            displayColor: Colors.white,
          ),
        ),
        useMaterial3: true,
      ),
      home: const MirrorPage(),
    );
  }
}
