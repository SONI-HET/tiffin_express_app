part of 'place_bloc.dart';

sealed class PlaceEvent extends Equatable {
  const PlaceEvent();

  @override
  List<Object> get props => [];
}

class LoadPlace extends PlaceEvent{
  final String placeId;
  const LoadPlace({required this.placeId});
  @override
  List<Object> get props => [];
}