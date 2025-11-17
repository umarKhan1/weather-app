import 'package:weatherapp/features/locations/domain/entities/location_result.dart';

abstract class LocationRepository {
  Future<List<LocationResult>> search(String query);
  Future<void> saveSelection(LocationResult result);
  Future<List<LocationResult>> savedLocations();
}
