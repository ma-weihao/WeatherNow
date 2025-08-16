# WeatherNow - Apple TV Weather App

A beautiful and comprehensive weather application designed specifically for Apple TV, providing real-time weather information and forecasts using the free Open-Meteo API.

## Features

### 🌤️ Current Weather
- Real-time temperature and weather conditions
- Feels like temperature
- Detailed weather metrics:
  - Humidity percentage
  - Wind speed and direction
  - Visibility
  - Atmospheric pressure
  - UV index
  - Cloud coverage
- Sunrise and sunset times
- Location-based weather data

### ⏰ 24-Hour Forecast
- Hourly weather predictions for the next 24 hours
- Temperature and feels like temperature
- Weather conditions with appropriate icons
- Precipitation probability
- Wind and humidity information
- Visual indicators for current hour

### 📅 7-Day Forecast
- Daily weather predictions for the next week
- High and low temperatures
- Weather conditions and descriptions
- Sunrise and sunset times
- UV index information
- Precipitation probability

## Technical Details

### API
- **Open-Meteo API**: Free weather API with no authentication required
- **Location Services**: Uses device location for accurate weather data
- **Real-time Updates**: Fetches current weather and forecast data

### Design
- **Apple TV Optimized**: Designed specifically for tvOS interface
- **Dark Theme**: Beautiful dark gradient backgrounds
- **Responsive Layout**: Adapts to different screen sizes
- **Smooth Animations**: Engaging user experience with animations
- **Accessibility**: Supports Apple TV remote navigation

### Architecture
- **SwiftUI**: Modern declarative UI framework
- **MVVM Pattern**: Clean separation of concerns
- **ObservableObject**: Reactive data binding
- **Core Location**: Location services integration

## Installation

1. Open the project in Xcode
2. Select your Apple TV as the target device
3. Build and run the application
4. Grant location permissions when prompted

## Usage

1. **Launch the App**: The app will automatically request location access
2. **Grant Permissions**: Allow location access for accurate weather data
3. **Navigate**: Use the Apple TV remote to navigate between tabs:
   - **Current**: View current weather conditions
   - **Hourly**: Browse 24-hour forecast
   - **Daily**: View 7-day forecast
4. **Enjoy**: The app will automatically update weather data

## Requirements

- **Platform**: Apple TV (tvOS 15.0+)
- **Device**: Apple TV 4K or Apple TV HD
- **Permissions**: Location access required
- **Internet**: Active internet connection for weather data

## Privacy

- **Location Data**: Only used to fetch weather information for your area
- **No Tracking**: No personal data is collected or stored
- **Local Processing**: All data processing happens on-device

## API Information

This app uses the [Open-Meteo API](https://open-meteo.com/), which provides:
- Free weather data with no API key required
- High accuracy weather forecasts
- Global coverage
- Multiple weather parameters
- No rate limiting for reasonable usage

## Development

### Project Structure
```
WeatherNow/
├── WeatherNowApp.swift          # App entry point
├── ContentView.swift            # Main app interface
├── WeatherModels.swift          # Data models
├── WeatherService.swift         # API and location services
├── CurrentWeatherView.swift     # Current weather UI
├── HourlyForecastView.swift     # Hourly forecast UI
├── DailyForecastView.swift      # Daily forecast UI
├── Info.plist                   # App permissions
└── Assets.xcassets/             # App assets
```

### Key Components

1. **WeatherService**: Handles API calls and location services
2. **WeatherModels**: Data structures for weather information
3. **View Components**: Modular UI components for different weather displays
4. **ContentView**: Main app coordinator with tab navigation

## Future Enhancements

- Weather alerts and notifications
- Multiple location support
- Weather widgets
- Customizable units (Celsius/Fahrenheit)
- Weather maps integration
- Historical weather data

## Support

For issues or questions, please check the project documentation or create an issue in the repository.

---

**WeatherNow** - Bringing beautiful weather information to your Apple TV experience.
