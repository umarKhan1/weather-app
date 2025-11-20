import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:weatherapp/features/locations/domain/entities/location_result.dart';
import 'package:weatherapp/features/locations/domain/usecases/save_location_selection.dart';
import 'package:weatherapp/features/locations/domain/usecases/search_locations.dart';

part 'location_search_state.dart';

class LocationSearchCubit extends Cubit<LocationSearchState> {
  final SearchLocations _search;
  final SaveLocationSelection _save;
  Timer? _debounce;

  LocationSearchCubit(this._search, this._save) : super(const LocationSearchState());

  void queryChanged(String q) {
    emit(state.copyWith(query: q, error: null));
    _debounce?.cancel();
    if (q.trim().length < 2) {
      emit(state.copyWith(results: const [], loading: false));
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 350), () async {
      emit(state.copyWith(loading: true));
      try {
        final results = await _search(q);
        emit(state.copyWith(results: results, loading: false, error: null));
      } catch (e) {
        emit(state.copyWith(error: e.toString(), loading: false));
      }
    });
  }

  Future<void> select(LocationResult r) async {
    await _save(r);
    emit(state.copyWith(selected: r));
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
