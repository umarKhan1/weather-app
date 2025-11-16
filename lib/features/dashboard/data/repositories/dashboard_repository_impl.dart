import 'package:weatherapp/features/dashboard/data/datasources/dashboard_local_datasource.dart';
import 'package:weatherapp/features/dashboard/data/datasources/dashboard_remote_datasource.dart';
import 'package:weatherapp/features/dashboard/domain/entities/news_item.dart';
import 'package:weatherapp/features/dashboard/domain/entities/weather_overview.dart';
import 'package:weatherapp/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:weatherapp/features/dashboard/domain/entities/forecast_entry.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardLocalDataSource local;
  final DashboardRemoteDataSource remote;
  DashboardRepositoryImpl({required this.local, required this.remote});

  @override
  Future<WeatherOverview> fetchOverview() async {
    return remote.fetchOverviewFromApi();
  }

  @override
  Future<List<NewsItem>> fetchNews() => local.getCachedNews();

  @override
  Future<List<ForecastEntry>> fetchForecast() async {
    final models = await remote.fetchForecastFromApi();
    return models; // models already extend domain entity
  }
}
