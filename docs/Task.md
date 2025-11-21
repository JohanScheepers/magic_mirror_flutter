# Magic Mirror Task List

## Phase 1: Project Setup & Core Services

-   [x] 1.1: Initialize a new Flutter project.
-   [x] 1.2: Add `signals`, `geolocator`, `http`, and `camera` to `pubspec.yaml`.
-   [x] 1.3: Create a `.gitignore` file and add `lib/api_key.dart` to it.
-   [x] 1.4: Create `lib/api_key.dart` and add the `openWeatherMapApiKey` constant.
-   [x] 1.5: Implement a `LocationService` to get user's coordinates.
-   [x] 1.6: Implement a `WeatherService` to fetch current and forecast data from the OpenWeatherMap One Call API.
-   [x] 1.7: Add a periodic 3-hour timer to the `WeatherService` to re-fetch data.

## Phase 2: Camera Integration

-   [x] 2.1: Implement logic to request camera permissions.
-   [x] 2.2: Create a service or utility to initialize the front-facing camera.
-   [x] 2.3: Create a `CameraPreviewWidget` to display the live camera feed.

## Phase 3: UI & State Integration

-   [ ] 3.1: Create `WeatherData`, `HourlyForecast`, and `DailyForecast` model classes for JSON parsing.
-   [ ] 3.2: Create a `WeatherViewModel` to hold all state signals (`currentWeather`, `hourlyForecast`, `dailyForecast`, `isLoading`, `isForecastVisible`, etc.).
-   [x] 3.3: Design and build the main screen using a `Stack` to overlay widgets on the `CameraPreviewWidget`.
-   [x] 3.4: Build a `CurrentWeatherWidget`.
-   [ ] 3.5: Build an `HourlyForecastWidget` and a `DailyForecastWidget`.
-   [x] 3.6: Connect the UI widgets to their respective state signals.
-   [x] 3.7: Implement a button or gesture to toggle the `isForecastVisible` signal.
-   [x] 3.8: Implement the initial data fetching logic on app startup.

## Phase 4: Refinement & Future Preparation

-   [ ] 4.1: Add error handling for location and camera permission denials.
-   [ ] 4.2: Add error handling for network or API errors, displaying user-friendly messages.
-   [ ] 4.3: Display appropriate UI for loading and error states.
-   [ ] 4.4: Refine the UI with a high-contrast, minimalist "magic mirror" theme.
-   [ ] 4.5: Organize files into a feature-first directory structure (e.g., `lib/features/weather/`, `lib/features/camera/`).
-   [x] 4.6: Fix UI overlap between Clock and Weather widgets.
-   [x] 4.7: Fix overflow in WeatherWidget for long location names.