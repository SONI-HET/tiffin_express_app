import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:tiffin_express_app/screens/my_order/my_order_detail_screen.dart';

class Order {
  final String orderId;
  final String orderId1;
  final String date;
  final String time;
  final String Total;
  final String deliveryTime;
  final List items;
  final String status;
  // final String status;
  Order(
      {required this.orderId,
      required this.date,
      required this.time,
      required this.Total,
      required this.deliveryTime,
      required this.items,
      required this.status,
      required this.orderId1});
}

class TiffinOrderScreen extends StatefulWidget {
  // ...
  static const String routeName = '/my-order';
  static Route route() {
    return MaterialPageRoute(
        builder: (_) => TiffinOrderScreen(),
        settings: RouteSettings(
          name: routeName,
        ));
  }

  @override
  _TiffinOrderScreenState createState() => _TiffinOrderScreenState();
}

class _TiffinOrderScreenState extends State<TiffinOrderScreen> {
  List<Order> orders = [
    // Order(
    //   date: DateTime.now(),
    //   time: DateTime.now(),
    //   orderId: 'nsdjkhf4n89',
    //   Total: '800',
    //   deliveryTime: DateTime.now(),
    //   items: [],
    //   // status: 'Delivered',
    // ),
    // Order(
    //   date: DateTime.now(),
    //   time: DateTime.now(),
    //   orderId: 'nsdjknfkjhf4n89',
    //   Total: '800',
    //   deliveryTime: DateTime.now(),
    //   items: [],
    //   // status: 'Pending',
    // ),
    // Add more orders here
  ];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  void fetchOrders() async {
    final userOrders = await getUserOrders();
    setState(() {
      orders = userOrders;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Recent Orders'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          backgroundColor: Color.fromARGB(255, 13, 50, 172),
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: Color.fromARGB(255, 13, 50, 172),
                ),
              )
            : orders.isEmpty
                ? Center(
                    child: Text(
                      'No orders till now',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (ctx, index) {
                      return Card(
                        margin: EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text(
                            'Order ID: ${orders[index].orderId}',
                            style: TextStyle(color: Colors.black),
                          ),
                          subtitle: Text(
                            'Order Date: ${orders[index].date}, Order Time: ${orders[index].time}',
                            style: TextStyle(
                              color: Color.fromARGB(255, 13, 50, 172),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.arrow_forward_ios),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  // Call a function to remove the order
                                  // removeOrder(orders[index].orderId1);
                                  showDeleteConfirmationDialog(
                                      orders[index].orderId1);
                                },
                              ),
                            ],
                          ),
                          onTap: () {
                            Get.to(OrderDetailsScreen(),
                                arguments: orders[index]);
                          },
                        ),
                      );
                    },
                  ),
      ),
    );
  }
Future<void> showDeleteConfirmationDialog(String orderId) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Order'),
          content: Text('Are you sure you want to delete this order?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                // User confirmed the deletion
                removeOrder(orderId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  void removeOrder(String orderId) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final userId = user.uid;
      final ordersCollection = FirebaseFirestore.instance.collection('Orders');

      // Delete the order from the Orders collection
      await ordersCollection.doc(orderId).delete();

      // Update the local list of orders to reflect the removal
      setState(() {
        orders.removeWhere((order) => order.orderId == orderId);
      });
    }
  }

// Function to get user orders
  Future<List<Order>> getUserOrders() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final userId = user.uid;
      final ordersCollection = FirebaseFirestore.instance.collection('Orders');

      final QuerySnapshot querySnapshot = await ordersCollection
          .where('userId',
              isEqualTo:
                  userId) // Assuming you have a 'userId' field in your orders
          .get();

      final List<Order> orders = [];

      querySnapshot.docs.forEach((doc) {
        print('Fetched Order ID: ${doc['userId']}');
        print('Date: ${doc['OrderDate']}');
        print('Total: ${doc['Total']}');
        orders.add(Order(
          orderId: doc['orderId'],
          date: doc['OrderDate'],
          time: doc['OrderTime'],
          Total: doc['Total'],
          deliveryTime: doc['deliveryTime'] ?? '',
          items: doc['items'],
          status: doc['status'],
          orderId1: doc['orderId'],
          // status: doc['status'],
        ));
      });

      return orders;
    }

    return [];
  }
}
