part of 'location_search_cubit.dart';

class LocationSearchState extends Equatable {
  final String query;
  final bool loading;
  final List<LocationResult> results;
  final String? error;
  final LocationResult? selected;

  const LocationSearchState({
    this.query = '',
    this.loading = false,
    this.results = const [],
    this.error,
    this.selected,
  });

  LocationSearchState copyWith({
    String? query,
    bool? loading,
    List<LocationResult>? results,
    String? error,
    LocationResult? selected,
  }) => LocationSearchState(
        query: query ?? this.query,
        loading: loading ?? this.loading,
        results: results ?? this.results,
        error: error,
        selected: selected ?? this.selected,
      );

  @override
  List<Object?> get props => [query, loading, results, error, selected];
}
