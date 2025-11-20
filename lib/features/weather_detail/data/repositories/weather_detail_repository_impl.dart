import 'package:weatherapp/features/weather_detail/domain/entities/daily_weather.dart';
import 'package:weatherapp/features/weather_detail/domain/entities/hourly_weather.dart';
import 'package:weatherapp/features/weather_detail/domain/repositories/weather_detail_repository.dart';
import '../datasources/weather_detail_local_datasource.dart';

class WeatherDetailRepositoryImpl implements WeatherDetailRepository {
  final WeatherDetailLocalDataSource local;
  WeatherDetailRepositoryImpl({required this.local});

  @override
  Future<List<DailyWeather>> getDailyBreakdown() async {
    final list = await local.getCachedForecast();
    final map = <DateTime, List<HourlyWeather>>{};
    for (final f in list) {
      final dateKey = DateTime(f.time.year, f.time.month, f.time.day);
      map.putIfAbsent(dateKey, () => []);
      // Attempt to read extra fields using dynamic since ForecastEntry may be a model with more props
      double? pressure;
      double? humidity;
      double? wind;
      double? feelsLike;
      try {
        // ignore: unnecessary_cast
        final dyn = f as dynamic;
        pressure = (dyn.pressure as num?)?.toDouble();
        humidity = (dyn.humidity as num?)?.toDouble();
        wind = (dyn.windSpeed as num?)?.toDouble();
        feelsLike = (dyn.feelsLike as num?)?.toDouble();
      } catch (_) {}
      map[dateKey]!.add(HourlyWeather(
        time: f.time,
        condition: f.condition,
        temperatureF: f.temperatureF,
        code: null,
        pressure: pressure,
        humidity: humidity,
        windSpeed: wind,
        feelsLikeF: feelsLike,
      ));
    }
    // Sort hours within each day chronologically
    for (final hours in map.values) {
      hours.sort((a, b) => a.time.compareTo(b.time));
    }
    // After grouping existing future forecast hours, optionally synthesize yesterday if missing
    final todayKey = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    final yesterdayKey = todayKey.subtract(const Duration(days: 1));
    if (!map.containsKey(yesterdayKey)) {
      final todayHours = map[todayKey];
      if (todayHours != null && todayHours.isNotEmpty) {
        final cloned = todayHours.take(5).map((h) => HourlyWeather(
              time: h.time.subtract(const Duration(days: 1)),
              condition: h.condition,
              temperatureF: h.temperatureF,
              code: h.code,
              pressure: h.pressure,
              humidity: h.humidity,
              windSpeed: h.windSpeed,
              feelsLikeF: h.feelsLikeF,
            )).toList();
        map[yesterdayKey] = cloned;
      }
    }
    // Remove synthetic tomorrow creation; rely on actual forecast list entries
    return map.entries.map((e) => DailyWeather(date: e.key, hours: e.value)).toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }
}
