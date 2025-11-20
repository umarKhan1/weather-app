import '../entities/daily_weather.dart';
import '../repositories/weather_detail_repository.dart';

class GetDailyWeatherBreakdown {
  final WeatherDetailRepository repository;
  GetDailyWeatherBreakdown(this.repository);

  Future<List<DailyWeather>> call() => repository.getDailyBreakdown();
}
