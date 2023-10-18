import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceProvideOrderDetailScreen extends StatefulWidget {
  final String orderId;
  final String serviceProviderId;
  final String name;
  final String address;
  final String orderDate;
  final String orderTime;
  final String deliveryTime;
  final List<String> items;
  String status;
  final String userId;

  ServiceProvideOrderDetailScreen({
    required this.orderId,
    required this.serviceProviderId,
    required this.name,
    required this.address,
    required this.orderDate,
    required this.orderTime,
    required this.deliveryTime,
    required this.items,
    required this.status,
    required this.userId,
  });

  @override
  _ServiceProvideOrderDetailScreenState createState() =>
      _ServiceProvideOrderDetailScreenState();
}

class _ServiceProvideOrderDetailScreenState
    extends State<ServiceProvideOrderDetailScreen> {
  bool isStatusEditable = false;
  TextEditingController statusController = TextEditingController();
  String orderIdd = '';
  @override
  void initState() {
    super.initState();
    statusController.text = widget.status;
  }

  Future<void> updateStatus(String status) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    // Update the 'status' field in the global 'Orders' collection
    print(widget.orderId);
    await firestore.collection('Orders').doc(widget.orderId).update({
      'status': status,
    });

    // Update the 'status' field in the 'Orders' subcollection of the service provider's document
    final serviceProviderDocRef =
        firestore.collection('ServiceProviders').doc(widget.serviceProviderId);

    final serviceOrderCollection =
        serviceProviderDocRef.collection('Orders');

    QuerySnapshot querySnapshot = await serviceOrderCollection
        .where('orderId', isEqualTo: widget.orderId)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final orderDoc = querySnapshot.docs.first;
      await orderDoc.reference.update({
        'status': status,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final groupedItems = _groupItems(widget.items);

    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('User ID', widget.userId),
              _buildDivider(),
              _buildDetailRow('Name', widget.name),
              _buildDivider(),
              _buildDetailRow('Address', widget.address),
              _buildDivider(),
              _buildDetailRow('Order Date', widget.orderDate),
              _buildDivider(),
              _buildDetailRow('Order Time', widget.orderTime),
              _buildDivider(),
              _buildDetailRow('Delivery Time', widget.deliveryTime),
              _buildDivider(),
              _buildStatusRow(),
              _buildDivider(),
              _buildItemsList(groupedItems),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 13, 50, 172),
          ),
        ),
        SizedBox(height: 10),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Divider(
        height: 1.0,
        color: Colors.grey,
      ),
    );
  }

  Widget _buildStatusRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Status',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 13, 50, 172),
          ),
        ),
        SizedBox(height: 10),
        GestureDetector(
          onTap: () {
            setState(() {
              isStatusEditable = true;
            });
          },
          child: isStatusEditable
              ? TextFormField(
                  controller: statusController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  style: TextStyle(
                    fontSize: 18,
                  ),
                )
              : Text(
                  statusController.text,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
        ),
        SizedBox(height: 20),
        if (isStatusEditable)
          ElevatedButton(
            onPressed: () {
              // Save changes to the status
              final newStatus = statusController.text;
              updateStatus(newStatus);
              setState(() {
                isStatusEditable = false;
              });
            },
            child: Text('Save Changes'),
          ),
      ],
    );
  }

  Widget _buildItemsList(Map<String, int> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Items',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 13, 50, 172),
          ),
        ),
        SizedBox(height: 10),
        for (final item in items.entries)
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
              '${item.value}x - ${item.key}',
              style: TextStyle(
                fontSize: 18,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
      ],
    );
  }

  Map<String, int> _groupItems(List<String> items) {
    final groupedItems = <String, int>{};
    for (final item in items) {
      groupedItems.update(item, (value) => value + 1, ifAbsent: () => 1);
    }
    return groupedItems;
  }
}
