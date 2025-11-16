import 'package:weatherapp/features/dashboard/domain/entities/news_item.dart';
import 'package:weatherapp/features/dashboard/domain/entities/weather_overview.dart';

abstract class DashboardRepository {
  Future<WeatherOverview> fetchOverview();
  Future<List<NewsItem>> fetchNews();
}
