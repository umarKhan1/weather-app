import 'package:weatherapp/features/locations/domain/entities/location_result.dart';
import 'package:weatherapp/features/locations/domain/repositories/location_repository.dart';

class SaveLocationSelection {
  final LocationRepository repo;
  const SaveLocationSelection(this.repo);
  Future<void> call(LocationResult result) => repo.saveSelection(result);
}
