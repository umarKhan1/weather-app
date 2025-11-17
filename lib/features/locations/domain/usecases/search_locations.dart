import 'package:weatherapp/features/locations/domain/entities/location_result.dart';
import 'package:weatherapp/features/locations/domain/repositories/location_repository.dart';

class SearchLocations {
  final LocationRepository repo;
  const SearchLocations(this.repo);
  Future<List<LocationResult>> call(String query) => repo.search(query);
}
