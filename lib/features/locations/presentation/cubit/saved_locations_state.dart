part of 'saved_locations_cubit.dart';

class SavedLocationsState extends Equatable {
  final List<LocationResult> items;
  const SavedLocationsState({this.items = const []});

  SavedLocationsState copyWith({List<LocationResult>? items}) => SavedLocationsState(items: items ?? this.items);

  @override
  List<Object?> get props => [items];
}
