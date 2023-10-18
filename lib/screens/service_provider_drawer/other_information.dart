import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ServiceProviderInfoScreen extends StatefulWidget {
  static const String routeName = '/service-provider-info';
  static Route route() {
    return MaterialPageRoute(
      builder: (_) => ServiceProviderInfoScreen(),
      settings: RouteSettings(
        name: routeName,
      ),
    );
  }

  // Pass the service provider ID to the screen

  ServiceProviderInfoScreen();

  @override
  _ServiceProviderInfoScreenState createState() =>
      _ServiceProviderInfoScreenState();
}

class _ServiceProviderInfoScreenState extends State<ServiceProviderInfoScreen> {
  // Define controllers for editing service details, tags, and other fields

  final String serviceProviderId = '';
  TextEditingController serviceDetailsController = TextEditingController();
  TextEditingController tagsController = TextEditingController();
  TextEditingController deliveryTimeController = TextEditingController();
  TextEditingController deliveryFeeController = TextEditingController();
  TextEditingController distanceController = TextEditingController();
  TextEditingController priceCategoryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Fetch and display the current service details, tags, and other fields
    // You can use FutureBuilder or other methods to fetch the data

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Service Provider Info'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Service Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextFormField(
                controller: serviceDetailsController,
                decoration: InputDecoration(
                  hintText: 'Enter service details...',
                ),
                // Add validation and onChanged logic as needed
              ),
              SizedBox(height: 16.0),
              Text(
                'Tags (comma-separated)',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextFormField(
                controller: tagsController,
                decoration: InputDecoration(
                  hintText: 'Enter tags...',
                ),
                // Add validation and onChanged logic as needed
              ),
              SizedBox(height: 16.0),
              Text(
                'Delivery Time',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextFormField(
                controller: deliveryTimeController,
                decoration: InputDecoration(
                  hintText: 'Enter delivery time...',
                ),
                // Add validation and onChanged logic as needed
              ),
              SizedBox(height: 16.0),
              Text(
                'Delivery Fee',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextFormField(
                controller: deliveryFeeController,
                decoration: InputDecoration(
                  hintText: 'Enter delivery fee...',
                ),
                // Add validation and onChanged logic as needed
              ),
              SizedBox(height: 16.0),
              Text(
                'Distance',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextFormField(
                controller: distanceController,
                decoration: InputDecoration(
                  hintText: 'Enter distance...',
                ),
                // Add validation and onChanged logic as needed
              ),
              SizedBox(height: 16.0),
              Text(
                'Price Category',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextFormField(
                controller: priceCategoryController,
                decoration: InputDecoration(
                  hintText: 'Enter price category...',
                ),
                // Add validation and onChanged logic as needed
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  // Save the edited data to the database
                  final newServiceDetails = serviceDetailsController.text;
                  final newTags = tagsController.text
                      .split(',')
                      .map((e) => e.trim())
                      .toList();
                  final newDeliveryTime = deliveryTimeController.text;
                  final newDeliveryFee = deliveryFeeController.text;
                  final newDistance = distanceController.text;
                  final newPriceCategory = priceCategoryController.text;
                  final User? user = FirebaseAuth.instance.currentUser;
      
                  // Update the data in the database and handle success/failure
                  // Example Firebase Firestore update:
                  if (user != null) {
                    final String serviceProviderId = user.uid;
      
                    // Now, you have the serviceProviderId, and you can update the document
                    FirebaseFirestore.instance
                        .collection('ServiceProviders')
                        .doc(serviceProviderId)
                        .update({
                      'serviceDetails': newServiceDetails,
                      'tags': newTags,
                      'deliveryTime': newDeliveryTime,
                      'deliveryFee': newDeliveryFee,
                      'distance': newDistance,
                      'priceCategory': newPriceCategory,
                    });
      
                    // Show a success message to the user
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Changes saved successfully'),
                      ),
                    );
                  } else {
                    // Handle the case where the user is not authenticated
                    // You can show an error message or navigate the user to a login screen
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('User is not authenticated'),
                      ),
                    );
                  }
      
                  // Show a success message to the user
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Changes saved successfully'),
                    ),
                  );
                },
                child: Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
