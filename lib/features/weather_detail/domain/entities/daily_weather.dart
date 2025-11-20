import 'package:equatable/equatable.dart';
import 'hourly_weather.dart';

class DailyWeather extends Equatable {
  final DateTime date; // normalized (year, month, day)
  final List<HourlyWeather> hours;

  const DailyWeather({required this.date, required this.hours});

  @override
  List<Object?> get props => [date, hours];
}
