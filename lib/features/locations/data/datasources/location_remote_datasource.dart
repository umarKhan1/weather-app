import 'package:dio/dio.dart';

class LocationRemoteDataSource {
  final Dio _dio;
  LocationRemoteDataSource([Dio? dio]) : _dio = dio ?? Dio(BaseOptions(baseUrl: 'https://geocoding-api.open-meteo.com'));

  Future<List<Map<String, dynamic>>> searchRaw(String query) async {
    final resp = await _dio.get('/v1/search', queryParameters: {'name': query, 'count': 10});
    final data = (resp.data as Map<String, dynamic>);
    final list = (data['results'] as List?) ?? const [];
    return list.cast<Map<String, dynamic>>();
  }
}
