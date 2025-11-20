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
    // Use OpenWeather Geo Direct API
    final raw = await remote.searchGeoDirect(query, limit: 10);

    // Map to domain entities
    final baseResults = raw.map((e) {
      final name = (e['name']?.toString() ?? '').trim();
      final country = (e['country']?.toString() ?? '').trim();
      final state = (e['state']?.toString() ?? '').trim();
      final lat = (e['lat'] as num).toDouble();
      final lon = (e['lon'] as num).toDouble();
      final subtitle = [
        if (state.isNotEmpty) state,
        if (country.isNotEmpty) country,
      ].join(', ');
      return LocationResult(
        name: name,
        lat: lat,
        lon: lon,
        subtitle: subtitle.isEmpty ? null : subtitle,
      );
    }).toList();

    // Fetch condition codes in parallel
    final futures = baseResults.map((r) async {
      try {
        final code = await remote.fetchConditionCode(lat: r.lat, lon: r.lon);
        return code;
      } catch (_) {
        return null;
      }
    }).toList();

    final codes = await Future.wait(futures);

    final results = <LocationResult>[];
    for (var i = 0; i < baseResults.length; i++) {
      final r = baseResults[i];
      results.add(LocationResult(
        name: r.name,
        lat: r.lat,
        lon: r.lon,
        subtitle: r.subtitle,
        conditionCode: codes[i],
      ));
    }

    return results;
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
