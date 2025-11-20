import '../entities/daily_weather.dart';

abstract class WeatherDetailRepository {
  Future<List<DailyWeather>> getDailyBreakdown();
}
