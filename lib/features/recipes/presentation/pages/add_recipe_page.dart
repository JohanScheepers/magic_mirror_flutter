import 'package:flutter/material.dart';
import '../state/recipe_state.dart';

import '../../../../core/presentation/widgets/mirror_scaffold.dart';

class AddRecipePage extends StatefulWidget {
  const AddRecipePage({super.key});

  @override
  State<AddRecipePage> createState() => _AddRecipePageState();
}

class _AddRecipePageState extends State<AddRecipePage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  bool _isValid = false;

  @override
  void initState() {
    super.initState();
    _titleController.addListener(_validate);
    _contentController.addListener(_validate);
  }

  void _validate() {
    setState(() {
      _isValid =
          _titleController.text.trim().isNotEmpty &&
          _contentController.text.trim().isNotEmpty;
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _save() {
    if (_isValid) {
      RecipeState.addRecipe(_titleController.text, _contentController.text);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MirrorScaffold(
      appBar: AppBar(
        title: const Text('Add Recipe'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _isValid ? _save : null,
            child: const Text(
              'Save',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Recipe Title',
                border: OutlineInputBorder(),
                hintText: 'e.g., Pancakes',
              ),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TextField(
                controller: _contentController,
                decoration: const InputDecoration(
                  labelText: 'Ingredients & Instructions',
                  border: OutlineInputBorder(),
                  hintText: 'Paste your recipe here...',
                  alignLabelWithHint: true,
                ),
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
