# WeatherApp (Flutter)

A clean-architecture Flutter weather application featuring a dashboard and a full-bleed gradient Weather Detail page. The app uses Bloc for state management, DI-ready layers, and OpenWeather APIs for current conditions and 5-day/3-hour forecasts.

## Highlights
- Clean Architecture: data, domain, presentation per feature
- Bloc/Cubit state management
- GoRouter navigation
- Dashboard: overview card, hourly forecast card, news list
- Weather Detail: gradient header (no AppBar), segmented tabs (Yesterday, Today, Tomorrow), hourly strip, and metric cards
- Consistent icon mapping via WeatherIconMapper
- Shimmer-like placeholders while loading
- No Google Fonts; uses Theme text styles

## Project Structure
```
lib/
  core/
    constants/         # assets paths
    routing/           # GoRouter setup
    theme/             # colors, typography
    utils/             # WeatherIconMapper, helpers
  features/
    dashboard/
      data/
      domain/
      presentation/
        pages/
        widgets/
    locations/
      data/ domain/ presentation/
    weather_detail/
      data/
        datasources/   # local bridge to dashboard forecast
        repositories/  # grouping + transform
      domain/
        entities/      # DailyWeather, HourlyWeather
        repositories/  # WeatherDetailRepository
        usecases/      # GetDailyWeatherBreakdown
      presentation/
        cubit/
        pages/
        widgets/
```

## Run
1. Prereqs
   - Flutter SDK installed
   - iOS/Android toolchains set up
2. Configure environment
   - Create `.env` in project root and add:
     ```env
     OPENWEATHER_API_KEY=YOUR_KEY
     UNITS=imperial   # or metric
     ```
3. Get packages and run
   - `flutter pub get`
   - `flutter run` (choose a device)

## Features Details
### Dashboard
- Loads location (via prefs or device), then fetches:
  - Current weather: `/data/2.5/weather`
  - Forecast: `/data/2.5/forecast` (timezone offset respected)
- Overview card is tappable and navigates to Weather Detail.

### Weather Detail
- Header: full-width gradient container, rounded bottom radius; shows mapped condition icon, condition text, and date.
- Segmented tabs: Yesterday, Today, Tomorrow. Tabs are evenly spaced and rebuild the hourly list on selection.
- Hourly strip: 5 items with time, icon, and temperature; icons mapped using WeatherIconMapper.
- Metric cards: Fahrenheit, Pressure, UV Index, Humidity. Values are provided from the selected day (first hour) and overview when available.
- Loading: shimmer-like placeholders (no circular loader).

## State Management
- DashboardCubit orchestrates fetching overview, forecast, and news.
- WeatherDetailCubit consumes dashboard forecast through a local datasource and groups entries into days for the tabs.

## API Notes
- Forecast parsing maps temperature, pressure, humidity, and condition codes from OpenWeather `list[].main` and `list[].weather[0]`.
- Timezone: `city.timezone` is applied to forecast timestamps.
- Historical “Yesterday” requires storage or paid historical API; the app can synthesize if absent.

## Assets
- Located under `assets/images` and declared in `pubspec.yaml`.
- Common icons: sunny.png, cloudy_w.png, partlycloudy.png, rain.png, frhenhit.png, pressure.png, uvindex.png, hum.png.

## Navigation
- GoRouter routes (see `lib/core/routing/app_router.dart`):
  - `/` splash
  - `/dashboard`
  - `/add-location`
  - `/weather-detail`

## Development Tips
- To tweak icon mapping, update `WeatherIconMapper` in `core/utils`.
- For exact spacing and typography, use Theme and ScreenUtil if enabled.
- If tabs overflow, the layout uses Expanded and ellipsis; adjust padding in `_SegmentLabel`.

## Testing
- Basic widget tests under `test/` (extend as needed).

## License
This project is for learning/demo purposes. Replace API keys and assets with your own for production use.
