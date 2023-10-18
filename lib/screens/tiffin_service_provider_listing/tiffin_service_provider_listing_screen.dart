import 'package:flutter/material.dart';
import 'package:tiffin_express_app/models/service_provider_model.dart';
import 'package:tiffin_express_app/screens/home/home_screen.dart';

class TiffinServiceProviderListingScreen extends StatelessWidget {
  static const String routeName = '/TiffinServiceProviderListing';
  static Route route({required List<ServiceProvider> serviceProvider}) {
    return MaterialPageRoute(
        builder: (_) => TiffinServiceProviderListingScreen(
            serviceProvider: serviceProvider),
        settings: const RouteSettings(
          name: routeName,
        ));
  }

  final List<ServiceProvider> serviceProvider;
  const TiffinServiceProviderListingScreen(
      {super.key, required this.serviceProvider});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Tiffin Service Providers'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemBuilder: (context, index) {
              return ServiceProviderCard(serviceProvider: serviceProvider[index]);
            },
            itemCount: serviceProvider.length,
          ),
        ));
  }
}
