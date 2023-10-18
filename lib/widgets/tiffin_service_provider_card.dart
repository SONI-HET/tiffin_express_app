import 'package:flutter/material.dart';
import 'package:tiffin_express_app/models/service_provider_model.dart';
import 'package:tiffin_express_app/widgets/service_providers_tags.dart';

class ServiceProviderCard extends StatelessWidget {
  const ServiceProviderCard({super.key, required this.serviceProvider});
  final ServiceProvider serviceProvider;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/TiffinServiceProvidersDetails',arguments: ServiceProvider);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 150,
                // decoration: BoxDecoration(
                //   borderRadius: BorderRadius.circular(5.0),
                // ),
                child: Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(5.0)),
                  child: Image.asset(
                    serviceProvider.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  width: 60,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      '${serviceProvider.deliveryTime} min',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  serviceProvider.name,
                  style: Theme.of(context).textTheme.headline5,
                ),
                SizedBox(
                  height: 5,
                ),
                // Text('${serviceProvider.tags}'),
                ServiceProvidersTags(serviceProvider: serviceProvider),
                SizedBox(
                  height: 5,
                ),
                Text(
                    '${serviceProvider.distance} km - \u{20B9} ${serviceProvider.deliveryFee} delivery fee'),
              ],
            ),
          )
        ],
      ),
    );
  }
}
