import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:tiffin_express_app/models/delivery_time_model.dart';
import 'package:tiffin_express_app/screens/admin/order_detail_screen.dart';
import 'package:tiffin_express_app/screens/admin/service_provider_detail.dart';
import 'package:tiffin_express_app/screens/admin/user_detail_screen.dart';

class AdminScreen extends StatefulWidget {
  static const String routeName = '/admin';
  static Route route() {
    return MaterialPageRoute(
        builder: (_) => AdminScreen(),
        settings: RouteSettings(
          name: routeName,
        ));
  }

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int _currentIndex = 0;

  final FirebaseService _firebaseService = FirebaseService();
  List<Map<String, dynamic>> _userData = [];
  List<Map<String, dynamic>> _orderData = [];
  bool isLoading = true; // Initially, set loading to true

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _fetchOrderData();
  }

  // Function to fetch user data
  void _fetchUserData() async {
    final userData = await _firebaseService.fetchUserData();
    setState(() {
      _userData = userData;
      isLoading = false; // Set loading to false when data is fetched
    });
  }

  // Function to fetch order data
  void _fetchOrderData() async {
    final orderData = await _firebaseService.fetchOrderData();
    setState(() {
      _orderData = orderData;
    });
  }

  void _openUserDetails(String userId, String Name, String Email,
      String Password, String PhoneNo) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserDetailsScreen(
          userId: userId,
          Name: Name,
          Email: Email,
          Password: Password,
          PhoneNo: PhoneNo,
          firebaseService: FirebaseService(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Admin Screen', style: TextStyle(fontSize: 15),),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              _signOut(); // Call a function to sign out the user
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(), // Show loading indicator
            )
          : _currentIndex == 0
              ? _buildUserSection()
              : _currentIndex == 1
                  ? _buildOrderSection()
                  : _currentIndex == 2
                      ? ServiceProviderList()
                  : Container(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Users',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business), // Use an appropriate icon for service providers
            label: 'Service Provider',
          ),

        ],
      ),
    );
  }
 
  Widget _buildUserSection() {
    return ListView.builder(
      itemCount: _userData.length,
      itemBuilder: (context, index) {
        final user = _userData[index];
        final userId =
            user['userId']; // Assuming you have an 'id' field in your user data
        final Name = user['Name'];
        final Email = user['Email'];
        final Password = user['Password'];
        final PhoneNo = user['PhoneNo'];

        return Card(
          elevation: 2.0,
          margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: ListTile(
            onTap: () {
              _openUserDetails(userId, Name, Email, Password, PhoneNo);
            },
            title: Text(
              Name,
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              Email,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 13, 50, 172)),
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: () {
                _deleteUser(userId);
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildOrderSection() {
    return ListView.builder(
      itemCount: _orderData.length,
      itemBuilder: (context, index) {
        final order = _orderData[index];
        final orderId = order[
            'orderId']; // Assuming you have an 'id' field in your order data
        final Name = order['Name'];
        final orderTime = order['OrderTime'];
        final orderDate = order['OrderDate'];
        final status = order['status'];
        final Total = order['Total'];
        final deliveryTime = order['deliveryTime'];
        final items = order['items'];
        return Card(
          elevation: 2.0,
          margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: ListTile(
            title: Text(
              Name ?? 'N/A',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            // subtitle: Text(orderDetails),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Status: $status',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 13, 50, 172)),
                ),
              ],
            ),

            trailing: IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: () {
                _deleteOrder(orderId);
              },
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AdminOrderDetailsScreen(
                    orderId: orderId,
                    name: Name ?? 'N/A',
                    orderDate: orderDate ?? 'N/A',
                    orderTime: orderTime ?? 'N/A',
                    status: status,
                    Total: Total,
                    deliveryTime: deliveryTime,
                    menuItems: items
                        .map((item) => item.toString())
                        .toList()
                        .cast<String>(),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _deleteUser(String userId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this user?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _firebaseService.deleteUser(userId);
                Navigator.of(context).pop();
                _fetchUserData();
              },
              child: Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void _deleteOrder(String orderId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this order?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _firebaseService.deleteOrder(orderId);
                Navigator.of(context).pop();
                _fetchOrderData();
              },
              child: Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushReplacementNamed(
          '/login'); // Navigate to the login screen after sign-out
    } catch (e) {
      print('Error signing out: $e');
      // Handle sign-out error, if any
    }
  }
}

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<void> updateUser(
      String userId, String name, String email, String phoneNo) async {
    try {
      await _firestore.collection('Users').doc(userId).update({
        'Name': name,
        'Email': email,
        'PhoneNo': phoneNo,
      });
    } catch (e) {
      print('Error updating user: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchUserData() async {
    try {
      final querySnapshot = await _firestore.collection('Users').get();
      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Error fetching user data: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchOrderData() async {
    try {
      final querySnapshot = await _firestore.collection('Orders').get();
      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Error fetching order data: $e');
      return [];
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      await _firestore.collection('Users').doc(userId).delete();
    } catch (e) {
      print('Error deleting user: $e');
    }
  }

  Future<void> deleteOrder(String orderId) async {
    try {
      await _firestore.collection('Orders').doc(orderId).delete();
    } catch (e) {
      print('Error deleting order: $e');
    }
  }
}


class ServiceProviderList extends StatefulWidget {
  @override
  _ServiceProviderListState createState() => _ServiceProviderListState();
}

class _ServiceProviderListState extends State<ServiceProviderList> {
  List<Map<String, dynamic>> _serviceProviders = [];
  bool isLoading = true; // Initially, set loading to true
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    // Call the method to fetch service providers and set loading to false when data is loaded
    _fetchServiceProviders();
  }

  Future<void> _fetchServiceProviders() async {
    try {
      final querySnapshot = await _firestore.collection('ServiceProviders').get();
      final serviceProviderData =
          querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      setState(() {
        _serviceProviders = serviceProviderData;
        isLoading = false; // Set loading to false when data is fetched
      });
    } catch (e) {
      print('Error fetching service provider data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: _serviceProviders.length,
            itemBuilder: (context, index) {
              final serviceProvider = _serviceProviders[index];
              final serviceProviderId = serviceProvider['serviceProviderDocumentId'];
              final name = serviceProvider['name'];
              final email = serviceProvider['email'];
              final phoneNo = serviceProvider['phoneNo'];
              final serviceDetails = serviceProvider['serviceDetails'] ?? 'Service Details Not By Service Provider';
              final info = serviceProvider['info'] ?? 'Info Not Provided By Service Provider';
              final tiffinServiceName = serviceProvider['tiffinServiceName'];
              return Card(
                elevation: 2.0,
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: ListTile(
                  onTap: () {
                    _openServiceProviderDetails(serviceProviderId, name, email, phoneNo, info,tiffinServiceName, serviceDetails);
                  },
                  title: Text(
                    name,
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    email,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 13, 50, 172),
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      _deleteServiceProvider(serviceProviderId);
                    },
                  ),
                ),
              );
            },
          );
  }

  void _openServiceProviderDetails(String serviceProviderId, String name, String email, String phoneNo, String info, String tiffinServiceName, String serviceDetails) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ServiceProviderDetailsScreen(
        serviceProviderId: serviceProviderId,
        name: name,
        email: email,
        phoneNo: phoneNo,
        info: info,
        tiffinServiceName: tiffinServiceName,
        serviceDetails: serviceDetails, 
      ),
    ),
  );
}


  void _deleteServiceProvider(String serviceProviderId) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Confirm Delete'),
        content: Text('Are you sure you want to delete this service provider?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('Cancel', style: TextStyle(color: Colors.blue)),
          ),
          TextButton(
            onPressed: () async {
              // Add logic to delete the service provider
              await _firestore.collection('ServiceProviders').doc(serviceProviderId).delete();
              // After deletion, refresh the service provider list
              _fetchServiceProviders();
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      );
    },
  );
}

}

