import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:weatherapp/features/locations/domain/entities/location_result.dart';
import 'package:weatherapp/features/locations/domain/repositories/location_repository.dart';

part 'saved_locations_state.dart';

class SavedLocationsCubit extends Cubit<SavedLocationsState> {
  final LocationRepository repo;
  SavedLocationsCubit(this.repo) : super(const SavedLocationsState());

  Future<void> load() async {
    final list = await repo.savedLocations();
    emit(state.copyWith(items: list));
  }
}
