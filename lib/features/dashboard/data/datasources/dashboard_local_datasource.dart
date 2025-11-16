import 'package:weatherapp/core/constants/app_images.dart';
import 'package:weatherapp/core/storage/prefs.dart';
import 'package:weatherapp/features/dashboard/data/models/news_item_model.dart';
import 'package:weatherapp/features/dashboard/data/models/weather_overview_model.dart';

abstract class DashboardLocalDataSource {
  Future<WeatherOverviewModel> getCachedOverview();
  Future<List<NewsItemModel>> getCachedNews();
}

class DashboardLocalDataSourceImpl implements DashboardLocalDataSource {
  DashboardLocalDataSourceImpl();

  @override
  Future<WeatherOverviewModel> getCachedOverview() async {
    // Deprecated in favor of remote API; kept for reference/tests.
    final _ = await AppPrefs.readLatLon();
    return const WeatherOverviewModel(
      condition: '—',
      location: '—',
      temperatureF: 0,
      rainChancePercent: 0,
      uvIndex: 0,
      windSpeedMph: 0,
    );
  }

  @override
  Future<List<NewsItemModel>> getCachedNews() async {
    return [
      NewsItemModel(
        id: '1',
        title: "Here's what to expect from Tuesday weather forecast",
        source: 'WC Channel',
        publishedAt: DateTime.now().subtract(const Duration(minutes: 14)),
        imagePath: AppImages.splashImage,
      ),
      NewsItemModel(
        id: '2',
        title: 'Rain approaching in the evening hours',
        source: 'Daily Weather',
        publishedAt: DateTime.now().subtract(const Duration(hours: 1)),
        imagePath: AppImages.splashImage,
      ),
    ];
  }
}
