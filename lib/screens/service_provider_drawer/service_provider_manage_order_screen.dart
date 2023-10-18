import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tiffin_express_app/screens/service_provider_drawer/service_provider_manage_order_detail_screen.dart';

class ManageOrderScreen extends StatefulWidget {
  static const String routeName = '/manage-order-screen';

  static Route route() {
    return MaterialPageRoute(
      builder: (_) => ManageOrderScreen(),
      settings: RouteSettings(
        name: routeName,
      ),
    );
  }

  @override
  _ManageOrderScreenState createState() => _ManageOrderScreenState();
}

class _ManageOrderScreenState extends State<ManageOrderScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    if (auth.currentUser == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Manage Orders'),
        ),
        body: Center(
          child: Text('Please sign in to view orders.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Orders'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore
            .collection('ServiceProviders')
            .doc(auth.currentUser!
                .uid) // Use the current user's UID as the document ID
            .collection('Orders')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final orders = snapshot.data?.docs;

          if (orders == null || orders.isEmpty) {
            return Center(
              child: Text('No orders found.'),
            );
          }

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              final orderData = order.data() as Map<String, dynamic>;

              if (orderData == null) {
                return SizedBox
                    .shrink(); // Skip rendering this item if orderData is null
              }

              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ServiceProvideOrderDetailScreen(
                        name: orderData['Name'] ?? 'N/A',
                        address: orderData['Address'] ?? 'N/A',
                        orderDate: orderData['OrderDate'] ?? 'N/A',
                        orderTime: orderData['OrderTime'] ?? 'N/A',
                        deliveryTime: orderData['deliveryTime'] ?? 'N/A',
                        items: (orderData['items'] as List<dynamic> ?? [])
                            .cast<String>(),
                        status: orderData['status'] ?? 'N/A',
                        userId: orderData['userId'] ?? 'N/A',
                        orderId: orderData['orderId'],
                        serviceProviderId: auth.currentUser!.uid,
                      ),
                    ),
                  );
                },
                child: Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Order ID: ${order.id}',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        Icon(Icons.keyboard_arrow_right,
                            color: Color.fromARGB(255, 13, 50,
                                172)), // Add the greater than icon here
                      ],
                    ),
                    subtitle: Text(
                      'UserName: ${orderData['Name'] ?? 'N/A'}, Status: ${orderData['status'] ?? 'N/A'}',
                      style: TextStyle(
                          fontSize: 13,
                          color: Color.fromARGB(255, 13, 50, 172),
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
