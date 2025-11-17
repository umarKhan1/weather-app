import 'package:shared_preferences/shared_preferences.dart';
import 'package:weatherapp/core/location/saved_location.dart';

class AppPrefs {
  static const _keyLat = 'user_lat';
  static const _keyLon = 'user_lon';
  static const _keySavedLocations = 'saved_locations_v1';

  AppPrefs._();

  static Future<void> saveLatLon({required double lat, required double lon}) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setDouble(_keyLat, lat);
    await sp.setDouble(_keyLon, lon);
  }

  static Future<({double lat, double lon})?> readLatLon() async {
    final sp = await SharedPreferences.getInstance();
    final lat = sp.getDouble(_keyLat);
    final lon = sp.getDouble(_keyLon);
    if (lat == null || lon == null) return null;
    return (lat: lat, lon: lon);
  }

  static Future<List<SavedLocation>> readSavedLocations() async {
    final sp = await SharedPreferences.getInstance();
    final raw = sp.getString(_keySavedLocations);
    if (raw == null || raw.isEmpty) return [];
    return SavedLocation.decodeList(raw);
  }

  static Future<void> addSavedLocation(SavedLocation loc) async {
    final sp = await SharedPreferences.getInstance();
    final existing = await readSavedLocations();
    // avoid duplicates by name+coords
    if (!existing.any((e) => e.name == loc.name && e.lat == loc.lat && e.lon == loc.lon)) {
      existing.add(loc);
      await sp.setString(_keySavedLocations, SavedLocation.encodeList(existing));
    }
  }
}
