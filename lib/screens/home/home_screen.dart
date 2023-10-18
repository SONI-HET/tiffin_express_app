import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tiffin_express_app/main.dart';
import 'package:tiffin_express_app/models/category_model.dart';
import 'package:tiffin_express_app/models/menu_item_models.dart';
import 'package:tiffin_express_app/models/promo_model.dart';
import 'package:tiffin_express_app/models/service_provider_model.dart';
import 'package:tiffin_express_app/widgets/category_box.dart';
import 'package:tiffin_express_app/widgets/custom_drawer.dart';
import 'package:tiffin_express_app/widgets/food_search_box.dart';
import 'package:tiffin_express_app/widgets/promo_box.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);
  static const String routeName = '/';
  static Route route() {
    return MaterialPageRoute(
      builder: (_) => HomeScreen(),
      settings: RouteSettings(
        name: routeName,
      ),
    );
  }

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final user = FirebaseAuth.instance.currentUser;

  List<String> docIDs = [];
  List<ServiceProvider> serviceProviders = [];

  Future<void> getDocId() async {
  final querySnapshot =
      await FirebaseFirestore.instance.collection('ServiceProviders').get();
final serviceProviderIds = await getServiceProviderIds();
print(serviceProviderIds);
  final serviceProviderList = await Future.wait(querySnapshot.docs.map((doc) async {
    final data = doc.data() as Map<String, dynamic>;

    // Fetch menu items for the service provider
    final menuItemsQuerySnapshot =
        await doc.reference.collection('menu').get();

    final menuItemsList = menuItemsQuerySnapshot.docs.map((menuItemDoc) {
      final menuItemData = menuItemDoc.data() as Map<String, dynamic>;
      return MenuItem(
        id: int.tryParse(menuItemDoc.id) ?? 0,
        tiffinServiceProviderId: int.tryParse(doc.id) ?? 0,
        name: menuItemData['itemName'] ?? '',
        category: menuItemData['category'] ?? '',
        description: menuItemData['description'] ?? '',
        price: (menuItemData['price'] ?? 0).toDouble(),
      );
    }).toList();

    return ServiceProvider(
      // id: doc.id,
      id: data['serviceProviderDocumentId'] ?? '',
      name: data['tiffinServiceName'] ?? '',
      imageUrl: data['cover_image_url'] ?? '',
      tags: List<String>.from(data['tags'] ?? []),
      deliveryTime: int.tryParse(data['deliveryTime']) ?? 0,

      priceCategory: data['priceCategory'] ?? '',
      deliveryFee: double.tryParse(data['deliveryFee']) ?? 0.0,

      distance: double.tryParse(data['distance'] ) ?? 0.0,
      menuItems: menuItemsList,
    );
  }));

  setState(() {
    serviceProviders = serviceProviderList.cast<ServiceProvider>();
  });
}

Future<List<String>> getServiceProviderIds() async {
  final querySnapshot =
      await FirebaseFirestore.instance.collection('ServiceProviders').get();

  final serviceProviderIds = querySnapshot.docs.map((doc) => doc.id).toList();

  return serviceProviderIds;
}

  @override
  void initState() {
    super.initState();
    getDocId();
    fetchUserName();
  }
  Future<void> fetchUserName() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    final userId = user.uid;
    final displayName = await getUserDisplayName(userId);
    setState(() {
      userName = displayName;
    });
  }
  }
Future<String?> getUserDisplayName(String userId) async {
  try {
    final userDoc = await FirebaseFirestore.instance.collection('Users').doc(userId).get();
    final userData = userDoc.data();
    if (userData != null) {
      return userData['Name'];
    }
  } catch (e) {
    print('Error fetching user name: $e');
  }
  return null;
}
String? userName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome Back!!!',
              style: TextStyle(
                  color: Colors.white, fontSize: 16, fontFamily: 'Roboto'),
            ),
            Text(
             userName ?? 'User',
              style: TextStyle(
                  color: Colors.white, fontSize: 16, fontFamily: 'Roboto'),
            )
          ],
        ),
      ),
      drawer: const CustomDrawer(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: Categoryyy.categories.length,
                  itemBuilder: (context, index) {
                    return CategoryBox(category: Categoryyy.categories[index]);
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 125,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: Promo.promos.length,
                  itemBuilder: (context, index) {
                    return PromoBox(promo: Promo.promos[index]);
                  },
                ),
              ),
            ),
            FoodSearchBox(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Top Rated',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      fontFamily: 'Roboto'),
                ),
              ),
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: serviceProviders.length,
              itemBuilder: (context, index) {
                final serviceProvider = serviceProviders[index];
                return ServiceProviderCard(
                  serviceProvider: serviceProvider, // Provide a default value or handle null.
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

class ServiceProviderCard extends StatelessWidget {
  const ServiceProviderCard({Key? key, required this.serviceProvider})
      : super(key: key);
  final ServiceProvider serviceProvider;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/TiffinServiceProvidersDetails',
            arguments: serviceProvider);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 150,
                child: Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(5.0)),
                  child: Image.network(
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
                    color: Color.fromARGB(255, 13, 50, 172),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      '${serviceProvider.deliveryTime} min',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          fontFamily: 'Roboto'),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  serviceProvider.name,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                      fontFamily: 'Roboto'),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  serviceProvider.tags.join(', '),
                  style: Theme.of(context).textTheme.headline4!.copyWith(
                      fontFamily: 'Roboto',
                      fontSize: 13,
                      fontWeight: FontWeight.w300),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  child: Text(
                    '${serviceProvider.distance} km - \u{20B9} ${serviceProvider.deliveryFee} delivery fee',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w200,
                        fontSize: 12,
                        fontFamily: 'Roboto'),
                  ),
                ),
                Divider(color: Colors.black)
              ],
            ),
          )
        ],
      ),
    );
  }
}
