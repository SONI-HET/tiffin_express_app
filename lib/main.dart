import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:tiffin_express_app/blocs/autocomplete/autocomplete_bloc.dart';
import 'package:tiffin_express_app/blocs/basket/basket_bloc.dart';
import 'package:tiffin_express_app/blocs/filters/filters_bloc.dart';
import 'package:tiffin_express_app/blocs/geolocation/geolocation_bloc.dart';
import 'package:tiffin_express_app/blocs/place/place_bloc.dart';
import 'package:tiffin_express_app/blocs/voucher/voucher_bloc.dart';
import 'package:tiffin_express_app/config/app_router.dart';
import 'package:tiffin_express_app/repositories/places/places_repository.dart';
import 'package:tiffin_express_app/repositories/voucher/voucher_repository.dart';
import 'package:tiffin_express_app/screens/login/login_screen.dart';
import 'package:tiffin_express_app/simple_bloc_observer.dart';
import 'config/theme.dart';
import 'package:bloc/bloc.dart';
import 'package:tiffin_express_app/screens/screens.dart';
import 'repositories/geolocation/geolocation_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  BlocOverrides.runZoned(
    () {
      Get.put(DataController());
  
      runApp(const MyApp());
    },
    blocObserver: SimpleBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<GeolocationRepository>(
          create: (_) => GeolocationRepository(),
        ),
        RepositoryProvider<PlacesRepository>(
          create: (_) => PlacesRepository(),
        )
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) => GeolocationBloc(
                  geolocationRepository: context.read<GeolocationRepository>())
                ..add(LoadGeolocation())),
          BlocProvider(
              create: (context) => AutocompleteBloc(
                  placesRepository: context.read<PlacesRepository>())
                ..add(LoadAutocomplete())),
          BlocProvider(
              create: (context) => PlaceBloc(
                  placesRepository: context.read<PlacesRepository>())),
          BlocProvider(
              create: (context) => FiltersBloc()
                ..add(
                  LoadFilter(),
                )),
          BlocProvider(
            create: (context) =>
                VoucherBloc(voucherRepository: VoucherRepository())
                  ..add(LoadVouchers()),
          ),
          BlocProvider(
            create: (context) =>
                BasketBloc(voucherBloc: BlocProvider.of<VoucherBloc>(context))
                  ..add(StartBasket()),
            child: BasketScreen(),
          ),
        ],
        child: MaterialApp(
          title: 'Tiffin Express',
          debugShowCheckedModeBanner: false,
          theme: theme(),
          onGenerateRoute: AppRouter.onGenerateRoute,
          initialRoute: MyLogin.routeName,
        ),
      ),
    );
  }
}
