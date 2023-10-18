import 'package:flutter/material.dart';
import 'package:tiffin_express_app/models/service_provider_model.dart';

class ServiceProvidersTags extends StatelessWidget {
  const ServiceProvidersTags({
    super.key,
    required this.serviceProvider,
  });

  final ServiceProvider serviceProvider;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: serviceProvider.tags.map((tag) => 
        serviceProvider.tags.indexOf(tag) == serviceProvider.tags.length - 1
        ? Text(tag,style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.bold,fontSize: 15),) : Text('$tag, ',style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.bold,fontSize: 15)), 
      ).toList(),
    );
  }
}
