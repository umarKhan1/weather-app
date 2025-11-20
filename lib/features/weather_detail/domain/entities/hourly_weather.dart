import 'package:equatable/equatable.dart';

class HourlyWeather extends Equatable {
  final DateTime time;
  final String condition;
  final double temperatureF;
  final int? code;
  final double? pressure; // hPa
  final double? humidity; // percent
  final double? windSpeed; // m/s or mph depending on units
  final double? feelsLikeF;

  const HourlyWeather({
    required this.time,
    required this.condition,
    required this.temperatureF,
    this.code,
    this.pressure,
    this.humidity,
    this.windSpeed,
    this.feelsLikeF,
  });

  @override
  List<Object?> get props => [time, condition, temperatureF, code, pressure, humidity, windSpeed, feelsLikeF];
}
