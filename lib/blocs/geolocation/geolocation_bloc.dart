import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:tiffin_express_app/repositories/geolocation/geolocation_repository.dart';

part 'geolocation_event.dart';
part 'geolocation_state.dart';

class GeolocationBloc extends Bloc<GeolocationEvent, GeolocationState> {
  
  final GeolocationRepository _geolocationRepository;
  StreamSubscription? _geolocationSubscription;


  GeolocationBloc({required GeolocationRepository geolocationRepository}) : 
      _geolocationRepository = geolocationRepository,
    super(GeolocationLoading())
    {
      on<LoadGeolocation>(_onLoadGeolocation as EventHandler<LoadGeolocation, GeolocationState>);
      on<UpdateGeolocation>(_onUpdateGeolocation as EventHandler<UpdateGeolocation, GeolocationState>);
    }
  // @override
  // Stream<GeolocationState> mapEventoState(
  //   GeolocationEvent event,
  // )
  // async*{

  //   if(event is LoadGeolocation){
  //     yield* _mapLoadGeolocationToState();
  //   }
  //   else if(event is UpdateGeolocation){
  //     yield* _mapUpdateGeolocationToState(event);
  //   }
  // }


  void _onLoadGeolocation(LoadGeolocation event, Emitter<LoadGeolocation> emit) async{
    final Position position = await _geolocationRepository.getCurrentLocation();
    add(UpdateGeolocation(position: position));
  }
  void _onUpdateGeolocation(UpdateGeolocation event, Emitter<UpdateGeolocation> emit) async{
    emit(GeolocationLoaded(position: event.position) as UpdateGeolocation);
  }
  // Stream<GeolocationState>_mapLoadGeolocationToState() async*{
  //     _geolocationSubscription?.cancel();
  //     final Position position = await _geolocationRepository.getCurrentLocation();

  //     add(UpdateGeolocation(position: position));
  // }
  // Stream<GeolocationState> _mapUpdateGeolocationToState(UpdateGeolocation event) async*{
  //   yield GeolocationLoaded(position: event.position);
  // }

  @override
  Future<void> close(){
    _geolocationSubscription?.cancel();
    return super.close();
  }
}
