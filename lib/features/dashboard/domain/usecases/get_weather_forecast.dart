import 'package:weatherapp/features/dashboard/domain/entities/forecast_entry.dart';
import 'package:weatherapp/features/dashboard/domain/repositories/dashboard_repository.dart';

class GetWeatherForecast {
  final DashboardRepository _repo;
  const GetWeatherForecast(this._repo);

  Future<List<ForecastEntry>> call() => _repo.fetchForecast();
}
