import 'dart:convert';

class SavedLocation {
  final String name;
  final double lat;
  final double lon;

  const SavedLocation({required this.name, required this.lat, required this.lon});

  Map<String, dynamic> toJson() => {'name': name, 'lat': lat, 'lon': lon};

  factory SavedLocation.fromJson(Map<String, dynamic> json) => SavedLocation(
        name: json['name'] as String,
        lat: (json['lat'] as num).toDouble(),
        lon: (json['lon'] as num).toDouble(),
      );

  static String encodeList(List<SavedLocation> list) => jsonEncode(list.map((e) => e.toJson()).toList());
  static List<SavedLocation> decodeList(String source) {
    final data = jsonDecode(source) as List<dynamic>;
    return data.map((e) => SavedLocation.fromJson(e as Map<String, dynamic>)).toList();
  }
}
