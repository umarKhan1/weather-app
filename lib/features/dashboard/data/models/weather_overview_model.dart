import 'package:weatherapp/features/dashboard/domain/entities/weather_overview.dart';

class WeatherOverviewModel extends WeatherOverview {
  const WeatherOverviewModel({
    required super.condition,
    required super.location,
    required super.temperatureF,
    required super.rainChancePercent,
    required super.uvIndex,
    required super.windSpeedMph,
    super.code,
  });

  factory WeatherOverviewModel.fromJson(Map<String, dynamic> json) => WeatherOverviewModel(
        condition: json['condition'] as String,
        location: json['location'] as String,
        temperatureF: (json['temperatureF'] as num).toDouble(),
        rainChancePercent: (json['rainChancePercent'] as num).toDouble(),
        uvIndex: (json['uvIndex'] as num).toDouble(),
        windSpeedMph: (json['windSpeedMph'] as num).toDouble(),
        code: json['code'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'condition': condition,
        'location': location,
        'temperatureF': temperatureF,
        'rainChancePercent': rainChancePercent,
        'uvIndex': uvIndex,
        'windSpeedMph': windSpeedMph,
        'code': code,
      };
}
