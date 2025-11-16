import 'package:weatherapp/features/dashboard/data/datasources/dashboard_local_datasource.dart';
import 'package:weatherapp/features/dashboard/domain/entities/news_item.dart';
import 'package:weatherapp/features/dashboard/domain/entities/weather_overview.dart';
import 'package:weatherapp/features/dashboard/domain/repositories/dashboard_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardLocalDataSource local;
  DashboardRepositoryImpl({required this.local});

  @override
  Future<WeatherOverview> fetchOverview() => local.getCachedOverview();

  @override
  Future<List<NewsItem>> fetchNews() => local.getCachedNews();
}
