# Shopping List Feature - Task Checklist

## Phase 1: Setup & Dependencies
- [x] Add `shared_preferences` package to pubspec.yaml
- [x] Create shopping list feature folder structure

## Phase 2: Data Layer
- [x] Create `ShoppingItem` model class
- [x] Create `ShoppingListRepository` for data persistence
  - [x] Save/load current shopping list
  - [x] Track item frequency for suggestions
  - [x] Clear completed items
  - [x] Get suggested items based on frequency

## Phase 3: State Management
- [x] Create `ShoppingListState` with signals
  - [x] Current shopping list items
  - [x] Suggested items
  - [x] Loading state
  - [x] Text input state

## Phase 4: UI Components
- [x] Create `ShoppingListWidget` for mirror display
  - [x] Show active shopping list
  - [x] Compact view for mirror
- [x] Create `ShoppingListPage` for full management
  - [x] Add new items
  - [x] Mark items as completed
  - [x] Delete items
  - [x] Show suggestions
  - [x] Clear completed items

## Phase 5: Integration
- [x] Add shopping list widget to mirror page
- [x] Add navigation to shopping list page from settings
- [x] Initialize shopping list state in main.dart

## Phase 6: Testing & Polish
- [x] Test data persistence
- [x] Test suggestion algorithm
- [x] Verify UI responsiveness
- [x] Update README with shopping list feature

# Cooking Features - Task Checklist

## Phase 1: Setup & Dependencies
- [x] Create `timer` feature folder structure
- [x] Create `recipes` feature folder structure

## Phase 2: Countdown Timer
- [x] Create `TimerState` with signals (duration, remaining, isRunning)
- [x] Create `TimerWidget` for mirror display (circular progress?)
- [x] Create `TimerPage` for setting duration
- [x] Implement audio/visual alarm when done

## Phase 3: Recipes
- [x] Create `Recipe` model (id, title, content)
- [x] Create `RecipeRepository` (shared_preferences)
- [x] Create `RecipeState` with signals
- [x] Create `RecipeListPage` (list of recipes, add button)
- [x] Create `RecipeDetailPage` (large text view)
- [x] Create `AddRecipePage` (title input, content text area)

## Phase 4: Integration
- [x] Add Timer widget to Mirror Page
- [x] Add Recipes access from Settings or new Menu
- [x] Update `main.dart` initialization

## Phase 5: Calculator
# Shopping List Feature - Task Checklist

## Phase 1: Setup & Dependencies
- [x] Add `shared_preferences` package to pubspec.yaml
- [x] Create shopping list feature folder structure

## Phase 2: Data Layer
- [x] Create `ShoppingItem` model class
- [x] Create `ShoppingListRepository` for data persistence
  - [x] Save/load current shopping list
  - [x] Track item frequency for suggestions
  - [x] Clear completed items
  - [x] Get suggested items based on frequency

## Phase 3: State Management
- [x] Create `ShoppingListState` with signals
  - [x] Current shopping list items
  - [x] Suggested items
  - [x] Loading state
  - [x] Text input state

## Phase 4: UI Components
- [x] Create `ShoppingListWidget` for mirror display
  - [x] Show active shopping list
  - [x] Compact view for mirror
- [x] Create `ShoppingListPage` for full management
  - [x] Add new items
  - [x] Mark items as completed
  - [x] Delete items
  - [x] Show suggestions
  - [x] Clear completed items

## Phase 5: Integration
- [x] Add shopping list widget to mirror page
- [x] Add navigation to shopping list page from settings
- [x] Initialize shopping list state in main.dart

## Phase 6: Testing & Polish
- [x] Test data persistence
- [x] Test suggestion algorithm
- [x] Verify UI responsiveness
- [x] Update README with shopping list feature

# Cooking Features - Task Checklist

## Phase 1: Setup & Dependencies
- [x] Create `timer` feature folder structure
- [x] Create `recipes` feature folder structure

## Phase 2: Countdown Timer
- [x] Create `TimerState` with signals (duration, remaining, isRunning)
- [x] Create `TimerWidget` for mirror display (circular progress?)
- [x] Create `TimerPage` for setting duration
- [x] Implement audio/visual alarm when done

## Phase 3: Recipes
- [x] Create `Recipe` model (id, title, content)
- [x] Create `RecipeRepository` (shared_preferences)
- [x] Create `RecipeState` with signals
- [x] Create `RecipeListPage` (list of recipes, add button)
- [x] Create `RecipeDetailPage` (large text view)
- [x] Create `AddRecipePage` (title input, content text area)

## Phase 4: Integration
- [x] Add Timer widget to Mirror Page
- [x] Add Recipes access from Menu
- [x] Update `main.dart` initialization

## Phase 5: Calculator
- [x] Create `calculator` feature folder structure
- [x] Create `CalculatorState` with signals
- [x] Create `CalculatorPage` UI
- [x] Add Calculator access from Menu
- [x] Refine Calculator UI (Restore DEL button)

## Phase 6: Testing & Documentation
- [x] Unit tests for Timer logic
- [x] Unit tests for Recipe repository
- [x] Update README
- [x] Update Walkthrough
- [x] Refactor with Barrel Files
- [x] Implement Mirror Background Globally
- [x] Push to GitHub
- [x] Fix Timer Alarm (Sound & Vibration)
- [x] Fix Camera Initialization Error (Singleton Pattern)

