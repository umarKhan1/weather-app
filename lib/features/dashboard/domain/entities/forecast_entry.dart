import 'package:equatable/equatable.dart';

class ForecastEntry extends Equatable {
  final DateTime time;
  final String condition;
  final double temperatureF;
  final double? pressure; // hPa
  final double? humidity; // %
  final int? weatherCode;

  const ForecastEntry({
    required this.time,
    required this.condition,
    required this.temperatureF,
    this.pressure,
    this.humidity,
    this.weatherCode,
  });

  @override
  List<Object?> get props => [time, condition, temperatureF, pressure, humidity, weatherCode];
}
