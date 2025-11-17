import 'package:weatherapp/core/location/saved_location.dart';
import 'package:weatherapp/core/storage/prefs.dart';
import 'package:weatherapp/features/locations/data/datasources/location_remote_datasource.dart';
import 'package:weatherapp/features/locations/domain/entities/location_result.dart';
import 'package:weatherapp/features/locations/domain/repositories/location_repository.dart';

class LocationRepositoryImpl implements LocationRepository {
  final LocationRemoteDataSource remote;
  LocationRepositoryImpl(this.remote);

  @override
  Future<List<LocationResult>> search(String query) async {
    final raw = await remote.searchRaw(query);
    return raw.map((e) {
      final parts = <String>[];
      final name = (e['name']?.toString() ?? '').trim();
      final admin1 = (e['admin1']?.toString() ?? '').trim();
      final country = (e['country']?.toString() ?? '').trim();
      if (name.isNotEmpty) parts.add(name);
      if (admin1.isNotEmpty) parts.add(admin1);
      if (country.isNotEmpty) parts.add(country);
      return LocationResult(
        name: parts.join(', '),
        lat: (e['latitude'] as num).toDouble(),
        lon: (e['longitude'] as num).toDouble(),
      );
    }).toList();
  }

  @override
  Future<void> saveSelection(LocationResult result) async {
    await AppPrefs.addSavedLocation(SavedLocation(name: result.name, lat: result.lat, lon: result.lon));
    await AppPrefs.saveLatLon(lat: result.lat, lon: result.lon);
  }

  @override
  Future<List<LocationResult>> savedLocations() async {
    final list = await AppPrefs.readSavedLocations();
    return list.map((e) => LocationResult(name: e.name, lat: e.lat, lon: e.lon)).toList();
  }
}
