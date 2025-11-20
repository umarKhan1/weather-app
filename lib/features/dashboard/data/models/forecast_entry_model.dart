import 'package:weatherapp/features/dashboard/domain/entities/forecast_entry.dart';

class ForecastEntryModel extends ForecastEntry {
  const ForecastEntryModel({
    required super.time,
    required super.condition,
    required super.temperatureF,
    super.pressure,
    super.humidity,
    super.weatherCode,
  });

  factory ForecastEntryModel.fromJson(Map<String, dynamic> json, {int timezoneOffsetSeconds = 0}) {
    // OpenWeather: 'dt' is UTC seconds. 'city.timezone' is offset in seconds from UTC for the location.
    final dtSec = (json['dt'] as int?) ?? 0;
    DateTime time;
    if (dtSec != 0) {
      final localMs = (dtSec + timezoneOffsetSeconds) * 1000;
      time = DateTime.fromMillisecondsSinceEpoch(localMs, isUtc: true);
    } else {
      final dtTxt = json['dt_txt']?.toString();
      time = dtTxt != null ? DateTime.parse(dtTxt) : DateTime.now().toUtc();
    }

    final main = (json['main'] as Map?) ?? const {};
    final temp = (main['temp'] as num?)?.toDouble() ?? 0.0;
    final pressure = (main['pressure'] as num?)?.toDouble();
    final humidity = (main['humidity'] as num?)?.toDouble();

    final weatherArr = (json['weather'] as List?) ?? const [];
    final w0 = weatherArr.isNotEmpty ? weatherArr.first as Map : const {};
    final cond = (w0['main'] ?? 'Unknown').toString();
    final code = w0['id'] as int?;

    return ForecastEntryModel(
      time: time,
      condition: cond,
      temperatureF: temp,
      pressure: pressure,
      humidity: humidity,
      weatherCode: code,
    );
  }
}
