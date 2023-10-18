part of 'place_bloc.dart';

sealed class PlaceState extends Equatable {
  const PlaceState();
  
  @override
  List<Object> get props => [];
}

final class PlaceLoading extends PlaceState {}
final class PlaceLoaded extends PlaceState {

  final Place place;
  const PlaceLoaded({required this.place});
  @override
  List<Object> get props => [place];
}
final class PlaceError extends PlaceState {}
