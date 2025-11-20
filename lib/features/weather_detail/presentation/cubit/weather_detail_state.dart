import 'package:equatable/equatable.dart';
import '../../domain/entities/daily_weather.dart';

enum WeatherDetailStatus { initial, loading, success, failure }

class WeatherDetailState extends Equatable {
  final WeatherDetailStatus status;
  final List<DailyWeather> days;
  final int selectedIndex;
  final String? error;

  const WeatherDetailState({
    this.status = WeatherDetailStatus.initial,
    this.days = const [],
    this.selectedIndex = 0,
    this.error,
  });

  WeatherDetailState copyWith({
    WeatherDetailStatus? status,
    List<DailyWeather>? days,
    int? selectedIndex,
    String? error,
  }) {
    return WeatherDetailState(
      status: status ?? this.status,
      days: days ?? this.days,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      error: error,
    );
  }

  DailyWeather? get selectedDay => days.isEmpty ? null : days[selectedIndex];
  double? get pressure => selectedDay?.hours.isNotEmpty == true ? selectedDay!.hours.first.pressure : null;
  double? get humidity => selectedDay?.hours.isNotEmpty == true ? selectedDay!.hours.first.humidity : null;
  double? get windSpeed => selectedDay?.hours.isNotEmpty == true ? selectedDay!.hours.first.windSpeed : null;
  double? get uvIndex => null; // placeholder (requires separate API)

  @override
  List<Object?> get props => [status, days, selectedIndex, error];
}
