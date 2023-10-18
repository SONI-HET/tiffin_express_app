import 'package:flutter/material.dart';
import 'package:tiffin_express_app/models/category_model.dart';
import 'package:tiffin_express_app/models/service_provider_model.dart';

class CategoryBox extends StatelessWidget {
  final Categoryyy category;
  const CategoryBox({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<ServiceProvider> serviceProvider = ServiceProvider.serviceProvider.where((serviceProvider) => serviceProvider.tags.contains(category.name),).toList();
    return InkWell(
      onTap: (){
        Navigator.pushNamed(context, '/TiffinServiceProviderListing', arguments: serviceProvider);
      },
      child: Container(
        width: 80,
        margin: const EdgeInsets.only(right: 5.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: Color.fromARGB(255, 13, 50, 172)),
        child: Stack(
          children: [
            Positioned(
              top: 10,
              left: 10,
    
              child: Container(
                height: 50,
                width: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: Colors.white
                ),
                child: category.image,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  category.name,
                  style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontSize: 15, fontFamily: 'Roboto'),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
