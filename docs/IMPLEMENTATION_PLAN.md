# Magic Mirror Flutter Application: Implementation Plan

## 1. Project Vision

To create a "Magic Mirror" interface as a Flutter application. The primary display will show essential, glanceable information, including current weather and multi-day forecasts, while also displaying the user's reflection via the device's selfie camera. The design will be clean, modern, and easily readable from a distance.

## 2. Core Features

-   **Live Camera Feed:** Display a live feed from the device's front-facing (selfie) camera as the background.
-   **Current Weather Display:** Show the current temperature, weather condition, and a corresponding icon.
-   **Weather Forecasts:**
    -   Display an hourly forecast for the current day.
    -   Display a 5-day weather forecast.
    -   Provide a control to toggle the visibility of the forecast widgets.
-   **Location-Based Data:** Automatically detect the user's current location to provide relevant weather information.
-   **Automatic Refresh:** Fetch fresh weather data upon application startup and automatically every 3 hours thereafter.
-   **Secure Configuration:** Store sensitive data like API keys securely, keeping them out of version control.
-   **Modular Design:** Build the application with a clear separation of concerns to facilitate future feature additions.

## 3. Technical Architecture

### State Management: Signals

We will use the `signals` package for state management. This choice promotes a reactive programming model, making it simple to update the UI in response to data changes with minimal boilerplate.

-   **`Signal<T>`:** For individual reactive values (e.g., current weather data, loading state, forecast visibility).
-   **`computed<T>`:** For values that are derived from other signals.
-   **`effect`:** To trigger side effects like fetching data when a signal (e.g., user location) changes.

### Data Layer

-   **Location Service:**
    -   Utilize the `geolocator` package to get the user's current GPS coordinates.
-   **Weather Service:**
    -   Use the `http` package to make requests to the **OpenWeatherMap One Call API 3.0**, which provides current, hourly, and daily forecast data in a single request.
    -   Implement logic to refresh data on a 3-hour periodic timer.
    -   Parse the complex JSON response into a set of Dart model classes (`WeatherData`, `HourlyForecast`, `DailyForecast`).
-   **API Key Management:**
    -   The OpenWeatherMap API key will be stored as a constant in a dedicated Dart file (`lib/api_key.dart`), which will be added to `.gitignore`.

### UI Layer (Presentation)

-   The UI will be built as a `Stack`, with the `CameraPreview` widget at the bottom and informational widgets overlaid on top.
-   **Main Widgets:**
    -   `CurrentWeatherWidget`: Displays real-time weather.
    -   `ForecastWidget`: A container for hourly and daily forecasts, whose visibility can be toggled.
-   A button or gesture will be used to toggle the `isForecastVisible` signal, which controls the visibility of the `ForecastWidget`.

## 4. Implementation Phases

### Phase 1: Project Setup & Core Services

1.  **Initialize Project:** Set up the basic Flutter project.
2.  **Add Dependencies:** Include `signals`, `geolocator`, `http`, and `camera` in `pubspec.yaml`.
3.  **API Key Setup:** Create a `lib/api_key.dart` file for the API key and add it to `.gitignore`.
4.  **Location Service:** Implement a service to fetch the current coordinates.
5.  **Weather Service:** Implement a service to fetch current and forecast data from the One Call API. Include the 3-hour refresh logic.

### Phase 2: Camera Integration

1.  **Request Camera Permissions:** Implement logic to request and handle camera permissions.
2.  **Initialize Camera:** Set up the front-facing camera.
3.  **Display Camera Feed:** Create a widget to display the live camera feed as the application background.

### Phase 3: UI & State Integration

1.  **Create Data Models:** Define `WeatherData`, `HourlyForecast`, and `DailyForecast` classes for JSON parsing.
2.  **Develop State Signals:** Create signals for `currentWeather`, `hourlyForecast`, `dailyForecast`, `isLoading`, and `isForecastVisible`.
3.  **Build UI Widgets:** Develop the `CurrentWeatherWidget`, `HourlyForecastWidget`, and `DailyForecastWidget`.
4.  **Compose Main Screen:** Assemble the main screen using a `Stack` with the camera feed and weather overlays.
5.  **Connect UI to State:** Use `Watch` widgets to bind the UI to the signals.
6.  **Implement Toggling:** Add a control to change the `isForecastVisible` signal's value.
7.  **Initial Data Fetch:** Trigger the data fetching logic when the application starts.

### Phase 4: Refinement & Future Preparation

1.  **Error Handling:** Implement robust error handling for API failures or permission denials.
2.  **UI Polish:** Refine the UI for a clean, high-contrast "magic mirror" aesthetic.
3.  **Code Organization:** Refactor and organize the code into a clear feature-based directory structure.