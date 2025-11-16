import 'package:weatherapp/features/dashboard/domain/entities/forecast_entry.dart';

class ForecastEntryModel extends ForecastEntry {
  const ForecastEntryModel({required super.time, required super.condition, required super.temperatureF});

  factory ForecastEntryModel.fromJson(Map<String, dynamic> json) {
    // json is one item from OpenWeather forecast list
    final dtTxt = json['dt_txt']?.toString();
    final time = dtTxt != null ? DateTime.parse(dtTxt) : DateTime.fromMillisecondsSinceEpoch((json['dt'] as int) * 1000);

    final temp = (json['main']?['temp'] as num?)?.toDouble() ?? 0.0;
    final cond = (json['weather'] is List && (json['weather'] as List).isNotEmpty)
        ? ((json['weather'][0]['main'] ?? 'Unknown').toString())
        : 'Unknown';

    return ForecastEntryModel(time: time, condition: cond, temperatureF: temp);
  }
}
