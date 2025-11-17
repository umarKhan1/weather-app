import 'package:equatable/equatable.dart';

class LocationResult extends Equatable {
  final String name;
  final double lat;
  final double lon;

  const LocationResult({required this.name, required this.lat, required this.lon});

  @override
  List<Object?> get props => [name, lat, lon];
}
