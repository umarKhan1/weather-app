import 'package:geolocator/geolocator.dart';

class LocationService {
  const LocationService();

  Future<({double lat, double lon})?> getCurrentLocation() async {
    // Check service enabled
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null;
    }

    // Check permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return null;
    }

    final pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    return (lat: pos.latitude, lon: pos.longitude);
  }
}
