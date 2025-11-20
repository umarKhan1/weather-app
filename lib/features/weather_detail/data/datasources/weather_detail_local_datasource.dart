import 'package:weatherapp/features/dashboard/domain/entities/forecast_entry.dart';

abstract class WeatherDetailLocalDataSource {
  Future<List<ForecastEntry>> getCachedForecast();
}

class WeatherDetailLocalDataSourceImpl implements WeatherDetailLocalDataSource {
  final List<ForecastEntry> Function() _forecastProvider;
  WeatherDetailLocalDataSourceImpl(this._forecastProvider);
  @override
  Future<List<ForecastEntry>> getCachedForecast() async => _forecastProvider();
}
