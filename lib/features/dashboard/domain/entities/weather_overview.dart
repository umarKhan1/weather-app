import 'package:equatable/equatable.dart';

class WeatherOverview extends Equatable {
  final String condition; // e.g. Partly Cloudy
  final String location; // e.g. Washington DC, USA
  final double temperatureF; // Fahrenheit
  final double rainChancePercent;
  final double uvIndex;
  final double windSpeedMph;
  final int? code; // OpenWeather condition code (e.g. 501 rain)

  const WeatherOverview({
    required this.condition,
    required this.location,
    required this.temperatureF,
    required this.rainChancePercent,
    required this.uvIndex,
    required this.windSpeedMph,
    this.code,
  });

  @override
  List<Object?> get props => [
        condition,
        location,
        temperatureF,
        rainChancePercent,
        uvIndex,
        windSpeedMph,
        code,
      ];
}
