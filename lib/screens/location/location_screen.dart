import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tiffin_express_app/blocs/autocomplete/autocomplete_bloc.dart';
import 'package:tiffin_express_app/blocs/geolocation/geolocation_bloc.dart';
import 'package:tiffin_express_app/blocs/place/place_bloc.dart';
import 'package:tiffin_express_app/models/place_model.dart';
import 'package:tiffin_express_app/screens/home/home_screen.dart';
import 'package:tiffin_express_app/widgets/gmap.dart';

class LocationScreen extends StatelessWidget {
  const LocationScreen({super.key});

  static const String routeName = '/location';
  static Route route() {
    return MaterialPageRoute(
        builder: (_) => LocationScreen(),
        settings: const RouteSettings(
          name: routeName,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<PlaceBloc, PlaceState>(
        builder: (context, state) {
          if(state is PlaceLoading){
            return Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                child: Gmap(
                  lat: 100.12214,
                  lng: -109.53442,
                ),
                //   child: BlocBuilder<GeolocationBloc, GeolocationState>(
                //   builder: (context, state) {
                //      if (state is GeolocationLoaded) {
                //       return Gmap(
                //         lat: state.position.latitude,
                //         lng: state.position.longitude,
                //       );
                //     }
                //     else{
                //       return const Text('Something Went Wrong.');
                //     }
                //   },
                // ),
              ),
              SaveButton(),
              Location(),
            ],
          );
          }
          else if(state is PlaceLoaded){
            return Stack(
              children: [
                Gmap(
                  lat: state.place.lat,
                  lng: state.place.lon,
                ),
                SaveButton(),
                Location(),
              ],
            );
          }
          else{
            return Text('Something went wrong');
          }
          
        },
      ),
    );
  }
}

class Location extends StatelessWidget {
  const Location({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 50,
      left: 10,
      right: 15,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Container(
              margin: EdgeInsets.fromLTRB(3, 1, 10, 34),
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(
                    top: Radius.circular(30), bottom: Radius.circular(12)),
                child: Image.asset(
                  'assets/logo.png',
                  height: 50,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 2,
          ),
          Expanded(
              child: Column(
            children: [
              LocationSearchBox(),
              BlocBuilder<AutocompleteBloc, AutocompleteState>(
                builder: (context, state) {
                  if (state is AutocompleteLoading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is AutocompleteLoaded) {
                    return Container(
                      margin: const EdgeInsets.all(8),
                      height: 20,
                      color: state.autocomplete.length > 0
                          ? Colors.black.withOpacity(0.6)
                          : Colors.transparent,
                      child: ListView.builder(
                        itemCount: state.autocomplete.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(
                              state.autocomplete[index].description,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .copyWith(color: Colors.white),
                            ),
                            onTap: () {
                              context.read<PlaceBloc>().add(LoadPlace(placeId: state.autocomplete[index].placeId,));
                            },
                          );
                        },
                      ),
                    );
                  } else {
                    return Text('Something Went Wrong.');
                  }
                },
              )
            ],
          )),
        ],
      ),
    );
  }
}

class SaveButton extends StatelessWidget {
  const SaveButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: 700,
        left: 20,
        right: 20,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 70),
          child: ElevatedButton(
            // style: ElevatedButton.styleFrom(  primary: Theme.of(context).primaryColor),
            child: Text('Save'),
            onPressed: () {},
          ),
        ));
  }
}

class LocationSearchBox extends StatelessWidget {
  const LocationSearchBox({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: 'Enter Your Location',
            suffixIcon: const Icon(Icons.search),
            contentPadding:
                const EdgeInsets.only(left: 20, bottom: 5, right: 5, top: 10),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.white)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.white))),
      ),
    );
  }
}
