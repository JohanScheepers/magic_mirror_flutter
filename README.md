# Magic Mirror Flutter

A modern smart mirror application built with Flutter that displays real-time information including weather forecasts and a live camera feed, creating an interactive mirror experience.

> **Built with Antigravity** - This project was developed with assistance from [Antigravity](https://deepmind.google/technologies/gemini/antigravity/), Google DeepMind's AI coding assistant.

## Features

- 🎥 **Live Camera Feed** - Displays your reflection using the device's front-facing camera (Global Background)
- 🌤️ **Real-Time Weather** - Current weather conditions with detailed metrics
- 📅 **5-Day Forecast** - Comprehensive weather forecast with all available parameters
- 🕐 **Live Clock** - Always-accurate time and date display
- 🛒 **Shopping List** - Smart shopping list with frequency-based suggestions
- ⏲️ **Cooking Timer** - Countdown timer with visual and audio alerts
- 📖 **Recipes** - Store and view recipes with large text for easy reading while cooking
- 🧮 **Calculator** - Standard calculator for quick conversions
- 🔄 **Automatic Updates** - Weather data refreshes every 3 hours automatically
- ⚙️ **Menu & Settings** - Central hub to access features and toggle visibility

## Project Structure

```
lib/
├── core/               # Core utilities and shared widgets
├── features/           # Feature-based modules (with barrel files)
│   ├── calculator/     # Calculator feature
│   ├── camera/         # Camera preview widget
│   ├── clock/          # Clock widget
│   ├── dashboard/      # Main mirror interface
│   ├── recipes/        # Recipe management
│   ├── settings/       # Menu and settings
│   ├── shopping/       # Shopping list feature
│   ├── timer/          # Countdown timer
│   └── weather/        # Weather display
└── main.dart           # App entry point
```

## Setup

### Prerequisites
- Flutter SDK (^3.8.1)
- An OpenWeatherMap API key ([Get one here](https://openweathermap.org/api))

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd magic_mirror_flutter
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure API Key**
   
   Create `lib/core/config/env.dart`:
   ```dart
   class Env {
     static const String openWeatherApiKey = 'YOUR_API_KEY_HERE';
   }
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

## Usage

### Main Screen
- **Tap weather widget** - Toggle between current weather and 5-day forecast
- **Menu button** - Access app features and settings (grid icon, bottom right)

### Menu & Settings
- **Toggle Widgets**: Show/hide Clock, Weather, Shopping List
- **Manage Shopping List**: Add and organize items
- **Timer**: Set a countdown timer for cooking or tasks
- **Recipes**: View and manage your recipe collection
- **Calculator**: Access the built-in calculator
- **Weather API Key**: Configure API settings (coming soon)

### Shopping List
- **Add items** - Type and press Add or Enter
- **Quick-add** - Tap suggestion chips for frequently used items
- **Mark complete** - Tap checkbox to mark items as done
- **Delete items** - Swipe left or tap delete button
- **Clear completed** - Remove all checked items at once
- **Smart suggestions** - System learns from your usage patterns

### Cooking Features
- **Timer**: Large, easy-to-read countdown timer. Flashes red when done.
- **Recipes**: Store your favorite recipes. Large text mode makes it easy to read from a distance while cooking.

### Calculator
- Standard calculator functionality
- Large buttons for easy touch interaction
- Handles large numbers with auto-scaling text

## Weather Data

The app displays comprehensive weather information including:

**Current Weather:**
- Temperature (current, min, max)
- Weather conditions with icon
- Humidity
- Wind speed
- Location name

**5-Day Forecast:**
- Temperature range
- Feels-like temperature
- Humidity & pressure
- Sea level & ground level pressure
- Wind speed, direction & gusts
- Cloud coverage
- Visibility
- Precipitation probability
- Rain & snow volume (when applicable)

## Permissions

The app requires the following permissions:
- **Camera** - For live mirror feed
- **Location** - For weather data based on your location

## Development

### Running Tests
```bash
flutter test
```

### Code Analysis
```bash
flutter analyze
```

### Building for Production
```bash
# Android
flutter build apk

# iOS
flutter build ios
```

## Technical Highlights

### Automatic Weather Updates
Weather data is fetched automatically every 3 hours using a `Timer.periodic` managed by the `WeatherState` class. This ensures fresh data without manual refreshing.

### Reactive UI
The entire UI is built using signals, which means:
- No manual `setState()` calls
- Automatic UI updates when data changes
- Better performance through optimized rebuilds

### Clean Architecture
- Separation of concerns (data, state, presentation)
- Feature-based folder structure
- Centralized state management
- Easy to test and maintain

## Credits

**Built with Antigravity** - This project was created with the assistance of Antigravity, Google DeepMind's advanced AI coding assistant. Antigravity helped with:
- Project architecture and planning
- Implementation of features
- State management with signals
- Code refactoring and optimization
- Testing and verification

## Documentation

For more detailed information about the development process and features, please refer to:

- [Implementation Plan](IMPLEMENTATION_PLAN.md) - Detailed technical plan and architecture
- [Task Checklist](TASK.md) - Tracking of completed and pending tasks
- [Walkthrough](WALKTHROUGH.md) - Comprehensive guide to features and implementation details

## License

This project is available for personal and educational use.

