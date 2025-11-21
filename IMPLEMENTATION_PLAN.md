# Cooking Features - Implementation Plan

## Overview

Add cooking-related features to the Magic Mirror: a Countdown Timer and a Recipe Manager.

## Features

### Countdown Timer
- **Set Duration**: Simple interface to set hours/minutes/seconds
- **Visual Display**: Circular progress or large digital countdown on mirror
- **Controls**: Start, Pause, Reset, Stop
- **Alarm**: Visual flashing and/or sound when time is up

### Recipe Manager
- **Storage**: Save recipes locally (Title + Content)
- **View Mode**: Large, readable text for viewing while cooking
- **Edit Mode**: Simple text area to paste recipes
- **List View**: Browse saved recipes

---

## Technical Architecture

### Data Models

#### Recipe
```dart
class Recipe {
  final String id;
  final String title;
  final String content;
  final DateTime createdAt;
}
```

### State Management (Signals)

#### TimerState
- `duration` - Signal<Duration>
- `remaining` - Signal<Duration>
- `isRunning` - Signal<bool>
- `isDone` - Signal<bool>

#### RecipeState
- `recipes` - Signal<List<Recipe>>
- `selectedRecipe` - Signal<Recipe?>

### UI Design

#### Timer Widget
- Circular progress indicator with time in center
- Tap to open controls/settings

#### Recipe UI
- **List**: Simple list tiles
- **Detail**: Full screen, large font, keep screen on?
- **Add/Edit**: TextField for title, Multiline TextField for content

---

## Proposed Changes

### New Files

#### Timer Feature
- `lib/features/timer/presentation/state/timer_state.dart`
- `lib/features/timer/presentation/widgets/timer_widget.dart`
- `lib/features/timer/presentation/pages/timer_page.dart`

#### Recipe Feature
- `lib/features/recipes/data/models/recipe.dart`
- `lib/features/recipes/data/recipe_repository.dart`
- `lib/features/recipes/presentation/state/recipe_state.dart`
- `lib/features/recipes/presentation/pages/recipe_list_page.dart`
- `lib/features/recipes/presentation/pages/recipe_detail_page.dart`
- `lib/features/recipes/presentation/pages/add_recipe_page.dart`

### Modified Files
- `lib/main.dart` - Initialize new states
- `lib/features/dashboard/presentation/pages/mirror_page.dart` - Add Timer widget
- `lib/features/settings/presentation/pages/settings_page.dart` - Add links to Timer/Recipes

---

## Calculator Feature

### Goal Description
Implement a standard calculator for quick calculations on the mirror.

### Proposed Changes
#### [NEW] [calculator_state.dart](file:///d:/FlutterProjects/magic_mirror_flutter/lib/features/calculator/presentation/state/calculator_state.dart)
- Signals for `displayValue`, `history`.
- Logic for arithmetic operations (+, -, *, /).

#### [NEW] [calculator_page.dart](file:///d:/FlutterProjects/magic_mirror_flutter/lib/features/calculator/presentation/pages/calculator_page.dart)
- Grid layout for buttons (0-9, operations).
- Large display area.

### Integration
- Add access from `SettingsPage`.

## Verification Plan
- Manual testing of calculations.
- Code analysis.
- Run timer, verify visual update and completion
- Add recipe, restart app, verify persistence
- Check UI readability on mirror
