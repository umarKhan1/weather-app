import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weatherapp/core/network/dio_client.dart';
import 'package:weatherapp/core/storage/prefs.dart';
import 'package:weatherapp/features/dashboard/data/models/weather_overview_model.dart';
import 'package:weatherapp/features/dashboard/data/models/forecast_entry_model.dart';

abstract class DashboardRemoteDataSource {
  Future<WeatherOverviewModel> fetchOverviewFromApi();
  Future<List<ForecastEntryModel>> fetchForecastFromApi();
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final Dio _dio;
  DashboardRemoteDataSourceImpl(DioClient client) : _dio = client.instance;

  @override
  Future<WeatherOverviewModel> fetchOverviewFromApi() async {
    final coords = await AppPrefs.readLatLon();
    if (coords == null) {
      throw Exception('Location not available. Please enable location services.');
    }

    final apiKey = dotenv.env['OPENWEATHER_API_KEY'];
    if (apiKey == null || apiKey.isEmpty || apiKey == 'YOUR_API_KEY_HERE') {
      throw Exception('API key missing. Add OPENWEATHER_API_KEY to .env');
    }

    final units = dotenv.env['UNITS'] ?? 'imperial'; // imperial -> Fahrenheit

    try {
      final resp = await _dio.get(
        '/data/2.5/weather',
        queryParameters: {
          'lat': coords.lat,
          'lon': coords.lon,
          'appid': apiKey,
          'units': units,
        },
      );

      if (resp.statusCode != null && resp.statusCode! >= 400) {
        // Normalize error response
        throw Exception(_extractServerMessage(resp) ?? 'Server error (${resp.statusCode})');
      }

      final data = resp.data as Map<String, dynamic>;
      return _mapOpenWeatherToModel(data);
    } on DioException catch (e) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          throw Exception('Request timed out. Please try again.');
        case DioExceptionType.connectionError:
          throw Exception('No internet connection.');
        case DioExceptionType.badResponse:
          throw Exception(_extractServerMessage(e.response) ?? 'Server error (${e.response?.statusCode})');
        case DioExceptionType.badCertificate:
          throw Exception('Bad SSL certificate.');
        case DioExceptionType.cancel:
          throw Exception('Request was cancelled.');
        case DioExceptionType.unknown:
          throw Exception(e.message ?? 'Unexpected network error');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<List<ForecastEntryModel>> fetchForecastFromApi() async {
    final coords = await AppPrefs.readLatLon();
    if (coords == null) {
      throw Exception('Location not available. Please enable location services.');
    }

    final apiKey = dotenv.env['OPENWEATHER_API_KEY'];
    if (apiKey == null || apiKey.isEmpty || apiKey == 'YOUR_API_KEY_HERE') {
      throw Exception('API key missing. Add OPENWEATHER_API_KEY to .env');
    }

    final units = dotenv.env['UNITS'] ?? 'imperial';

    try {
      final resp = await _dio.get(
        '/data/2.5/forecast',
        queryParameters: {
          'lat': coords.lat,
          'lon': coords.lon,
          'appid': apiKey,
          'units': units,
        },
      );

      if (resp.statusCode != null && resp.statusCode! >= 400) {
        throw Exception(_extractServerMessage(resp) ?? 'Server error (${resp.statusCode})');
      }

      final body = resp.data as Map<String, dynamic>;
      final list = (body['list'] as List?) ?? const [];
      return list.map((e) => ForecastEntryModel.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      final code = e.response?.statusCode;
      final message = e.response?.data is Map
          ? (e.response?.data['message']?.toString() ?? 'Network error')
          : e.message ?? 'Network error';
      throw Exception('Request failed${code != null ? ' ($code)' : ''}: $message');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  String? _extractServerMessage(Response? resp) {
    final data = resp?.data;
    if (data is Map<String, dynamic>) {
      if (data['message'] is String) return data['message'] as String;
      if (data['error'] is String) return data['error'] as String;
    }
    return null;
  }

  WeatherOverviewModel _mapOpenWeatherToModel(Map<String, dynamic> json) {
    final weatherList = (json['weather'] as List?) ?? const [];
    final firstWeather = weatherList.isNotEmpty ? weatherList[0] as Map<String, dynamic> : null;
    final condition = firstWeather != null ? (firstWeather['main']?.toString() ?? 'Unknown') : 'Unknown';
    final code = firstWeather != null ? (firstWeather['id'] as int?) : null;
    final location = json['name']?.toString() ?? '—';
    final temp = (json['main']?['temp'] as num?)?.toDouble() ?? 0;
    final rainChancePercent = (json['clouds']?['all'] as num?)?.toDouble() ?? 0;
    final windSpeed = (json['wind']?['speed'] as num?)?.toDouble() ?? 0;
    final windSpeedMph = windSpeed;
    final uvIndex = 0.0;

    return WeatherOverviewModel(
      condition: condition,
      location: location,
      temperatureF: temp,
      rainChancePercent: rainChancePercent,
      uvIndex: uvIndex,
      windSpeedMph: windSpeedMph,
      code: code,
    );
  }
}
