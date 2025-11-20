import 'package:weatherapp/features/dashboard/domain/entities/forecast_entry.dart';
import 'package:weatherapp/features/dashboard/domain/entities/news_item.dart';
import 'package:weatherapp/features/dashboard/domain/entities/weather_overview.dart';

abstract class DashboardLocalDataSource {
  Future<WeatherOverview?> getCachedOverview();
  Future<List<NewsItem>> getCachedNews();
  Future<List<ForecastEntry>> getCachedForecast();
}

class DashboardLocalDataSourceImpl implements DashboardLocalDataSource {
  @override
  Future<WeatherOverview?> getCachedOverview() async => null;

  @override
  Future<List<NewsItem>> getCachedNews() async => [
        NewsItem(
          id: 'n1',
            title: 'Storm systems move across the region this week',
            source: 'Daily Forecast',
            publishedAt: DateTime.now().subtract(const Duration(minutes: 12)),
            imagePath: 'assets/images/rain.png',
          ),
        NewsItem(
          id: 'n2',
          title: 'Here\'s what is happening in weather today',
          source: 'Weather Desk',
          publishedAt: DateTime.now().subtract(const Duration(hours: 2)),
          imagePath: 'assets/images/partlycloudy.png',
        ),
      ];

  @override
  Future<List<ForecastEntry>> getCachedForecast() async => const [];
}
