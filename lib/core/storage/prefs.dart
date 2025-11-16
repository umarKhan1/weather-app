import 'package:shared_preferences/shared_preferences.dart';

class AppPrefs {
  static const _keyLat = 'user_lat';
  static const _keyLon = 'user_lon';

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
}
