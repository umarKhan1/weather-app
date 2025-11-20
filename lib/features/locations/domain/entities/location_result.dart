import 'package:equatable/equatable.dart';

class LocationResult extends Equatable {
  final String name;
  final double lat;
  final double lon;
  // Optional extra data for UI
  final String? subtitle; // e.g., City, Country or Country code
  final int? conditionCode; // OpenWeather weather[0].id

  const LocationResult({
    required this.name,
    required this.lat,
    required this.lon,
    this.subtitle,
    this.conditionCode,
  });

  @override
  List<Object?> get props => [name, lat, lon, subtitle, conditionCode];
}
