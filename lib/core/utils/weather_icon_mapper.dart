import 'package:weatherapp/core/constants/app_images.dart';

class WeatherIconMapper {
  const WeatherIconMapper._();

  static String fromCondition(String condition, {int? weatherCode}) {
    final s = condition.toLowerCase();

    // Prefer code ranges when available (OpenWeather codes)
    if (weatherCode != null) {
      if (weatherCode >= 200 && weatherCode < 300) return AppImages.rain; // Thunderstorm -> use rain icon fallback
      if (weatherCode >= 300 && weatherCode < 400) return AppImages.rain; // Drizzle
      if (weatherCode >= 500 && weatherCode < 600) return AppImages.rain; // Rain
      if (weatherCode >= 600 && weatherCode < 700) return AppImages.cloudy; // Snow (no snow asset yet)
      if (weatherCode >= 700 && weatherCode < 800) return AppImages.partialyCloudy; // Atmosphere (mist etc.)
      if (weatherCode == 800) return AppImages.sunny; // Clear
      if (weatherCode > 800) {
        if (s.contains('part') || s.contains('few') || s.contains('scattered')) return AppImages.partialyCloudy;
        return AppImages.cloudy; // Overcast / broken
      }
    }

    if (s.contains('drizzle')) return AppImages.rain;
    if (s.contains('rain')) return AppImages.rain;
    if (s.contains('shower')) return AppImages.rain;
    if (s.contains('storm')) return AppImages.rain;
    if (s.contains('snow')) return AppImages.cloudy; // placeholder
    if (s.contains('few') || s.contains('scattered') || (s.contains('part') && s.contains('cloud'))) {
      return AppImages.partialyCloudy;
    }
    if (s.contains('cloud')) return AppImages.cloudy;
    if (s.contains('clear') || s.contains('sun')) return AppImages.sunny;
    return AppImages.sunny;
  }
}
