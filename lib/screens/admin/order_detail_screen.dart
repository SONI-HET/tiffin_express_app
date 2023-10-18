import 'package:flutter/material.dart';

class AdminOrderDetailsScreen extends StatelessWidget {
  final String orderId;
  final String name;
  final String orderDate;
  final String orderTime;
  final String status;
  final String Total;
  final String deliveryTime;
  final List<String> menuItems; // Added menuItems parameter

  AdminOrderDetailsScreen({
    required this.orderId,
    required this.name,
    required this.orderDate,
    required this.orderTime,
    required this.status,
    required this.Total,
    required this.deliveryTime,
    required this.menuItems, // Initialize menuItems
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildField('Order ID', orderId),
              buildField('Name', name),
              buildField('Order Date', orderDate),
              buildField('Order Time', orderTime),
              buildField('Status', status),
              buildField('Total', Total),
              buildField('Delivery Time', deliveryTime),
              buildMenuItems(
                  'Items', menuItems), // Use a separate method for menu items
            ],
          ),
        ),
      ),
    );
  }

  Widget buildField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 13, 50, 172)),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 16), // Add spacing between fields
        Divider(color: Colors.black), // Add a horizontal line for separation
        SizedBox(height: 16), // Add more spacing after the line
      ],
    );
  }

  Widget buildMenuItems(String label, List<String> items) {
    // Create a map to count the occurrences of each menu item
    Map<String, int> itemCounts = {};

    for (String item in items) {
      itemCounts[item] = (itemCounts[item] ?? 0) + 1;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 13, 50, 172)),
        ),
        SizedBox(height: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: itemCounts.entries.map((entry) {
            String itemName = entry.key;
            int itemCount = entry.value;
            String displayText = '${itemCount}x - $itemName';
            return Container(
              margin:
                  EdgeInsets.only(bottom: 8), // Add spacing between menu items
              child: Text(
                displayText,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 16), // Add spacing between fields
        Divider(color: Colors.black), // Add a horizontal line for separation
        SizedBox(height: 16), // Add more spacing after the line
      ],
    );
  }
}
