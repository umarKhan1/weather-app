import 'package:weatherapp/features/dashboard/domain/entities/weather_overview.dart';
import 'package:weatherapp/features/dashboard/domain/repositories/dashboard_repository.dart';

class GetWeatherOverview {
  final DashboardRepository repository;
  const GetWeatherOverview(this.repository);

  Future<WeatherOverview> call() => repository.fetchOverview();
}
