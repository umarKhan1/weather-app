import 'package:equatable/equatable.dart';

class ForecastEntry extends Equatable {
  final DateTime time;
  final String condition;
  final double temperatureF;

  const ForecastEntry({required this.time, required this.condition, required this.temperatureF});

  @override
  List<Object?> get props => [time, condition, temperatureF];
}
