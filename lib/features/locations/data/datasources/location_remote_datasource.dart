import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LocationRemoteDataSource {
  final Dio _owm;
  LocationRemoteDataSource([Dio? dio])
      : _owm = dio ?? Dio(BaseOptions(baseUrl: 'https://api.openweathermap.org'));

  // OpenWeather Geo Direct API
  Future<List<Map<String, dynamic>>> searchGeoDirect(String query, {int limit = 5}) async {
    final apiKey = dotenv.env['OPENWEATHER_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('API key missing. Add OPENWEATHER_API_KEY to .env');
    }
    final resp = await _owm.get(
      '/geo/1.0/direct',
      queryParameters: {
        'q': query,
        'limit': limit,
        'appid': apiKey,
      },
    );
    final data = resp.data as List<dynamic>;
    return data.cast<Map<String, dynamic>>();
  }

  // Fetch current weather to obtain condition code for an icon
  Future<int?> fetchConditionCode({required double lat, required double lon, String units = 'metric'}) async {
    final apiKey = dotenv.env['OPENWEATHER_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('API key missing. Add OPENWEATHER_API_KEY to .env');
    }
    final resp = await _owm.get(
      '/data/2.5/weather',
      queryParameters: {
        'lat': lat,
        'lon': lon,
        'units': units,
        'appid': apiKey,
      },
    );
    final list = (resp.data['weather'] as List?)?.cast<Map<String, dynamic>>() ?? const [];
    return list.isNotEmpty ? (list.first['id'] as int?) : null;
  }
}
