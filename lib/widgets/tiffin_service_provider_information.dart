import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tiffin_express_app/models/service_provider_model.dart';
import 'package:tiffin_express_app/widgets/service_providers_tags.dart';

class tiffinServiceProviderInfo extends StatelessWidget {
  final ServiceProvider serviceProvider;
  const tiffinServiceProviderInfo({super.key, required this.serviceProvider});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //  Divider(color: Colors.black,),
          Text(serviceProvider.name,
              style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 13, 50, 172))),
          SizedBox(
            height: 10,
          ),
          ServiceProvidersTags(serviceProvider: serviceProvider),
          SizedBox(
            height: 5,
          ),
          Text(
              '${serviceProvider.distance} km away - \u{20B9}${serviceProvider.deliveryFee} delivery fee',
              style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w500,
                  fontSize: 15)),
          SizedBox(
            height: 5,
          ),
          Text('Tiffin Service Provider Information :- ',
              style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w600,
                  fontSize: 20)),
          SizedBox(
            height: 5,
          ),
          Text(
              'We are popular tiffin service providers and we specializes in delivering homemade meals or tiffin boxes to customers doorsteps.',
              style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w500,
                  fontSize: 15)),
          Divider(color: Colors.black)
        ],
      ),
    );
  }
}
