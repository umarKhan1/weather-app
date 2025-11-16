import 'package:weatherapp/core/constants/app_images.dart';
import 'package:weatherapp/features/dashboard/data/models/news_item_model.dart';
import 'package:weatherapp/features/dashboard/data/models/weather_overview_model.dart';
import 'package:weatherapp/core/storage/prefs.dart';

abstract class DashboardLocalDataSource {
  Future<WeatherOverviewModel> getCachedOverview();
  Future<List<NewsItemModel>> getCachedNews();
}

class DashboardLocalDataSourceImpl implements DashboardLocalDataSource {
  DashboardLocalDataSourceImpl();

  @override
  Future<WeatherOverviewModel> getCachedOverview() async {
    // Example of using stored lat/lon (plug into API later)
    final coords = await AppPrefs.readLatLon();
    // ignore: avoid_print
    if (coords != null) print('Using stored coords lat=${coords.lat}, lon=${coords.lon}');

    return const WeatherOverviewModel(
      condition: 'Partly Cloudy',
      location: 'Washington DC, USA',
      temperatureF: 72,
      rainChancePercent: 60,
      uvIndex: 0.5,
      windSpeedMph: 124,
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
