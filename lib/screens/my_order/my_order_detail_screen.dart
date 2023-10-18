import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiffin_express_app/screens/my_order/my_order_screen.dart';

class OrderDetailsScreen extends StatelessWidget {
  static const routeName = '/order-details';

  static Route route() {
    return MaterialPageRoute(
      builder: (_) => OrderDetailsScreen(),
      settings: RouteSettings(
        name: routeName,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Order? order = Get.arguments as Order?;

    // Define a function to create space between fields and values.
    Widget spacedText(String label, String value) {
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
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
            ),
          ),
        ],
      );
    }

    // Create a divider with a specified color.
    Widget divider(Color color) {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        height: 1,
        color: color,
      );
    }

    // Function to format items with quantities.
    List<String> formatItemsWithQuantities(List<dynamic>? items) {
      Map<String, int> itemCounts = {};

      for (var item in items ?? []) {
        final itemString = item.toString();
        itemCounts[itemString] = (itemCounts[itemString] ?? 0) + 1;
      }

      List<String> formattedItems = [];

      itemCounts.forEach((item, count) {
        formattedItems.add('${count}x - $item');
      });

      return formattedItems;
    }

    List<String> formattedItems = formatItemsWithQuantities(order?.items ?? []);

    // Define a function to create a Text widget with status color
    Widget statusText(String status) {
      Color statusColor = Colors.black; // Default color

      if (status == 'Pending') {
        statusColor = Color.fromARGB(255, 201, 198, 39);
      } else if (status == 'Rejected') {
        statusColor = Colors.red;
      } else if (status == 'Delivered') {
        statusColor = Colors.green;
      }

      return Text(
        status,
        style: TextStyle(
            fontSize: 20, color: statusColor, fontWeight: FontWeight.bold),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
        backgroundColor:
            Color.fromARGB(255, 13, 50, 172), // Set the background color here
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            spacedText('Order ID:', '${order?.orderId ?? 'N/A'}'),
            divider(Colors.grey),
            spacedText('Order Date:', '${order?.date ?? 'N/A'}'),
            divider(Colors.grey),
            spacedText('Order Time:', '${order?.time ?? 'N/A'}'),
            divider(Colors.grey),
            spacedText('Delivery Time:', '${order?.deliveryTime ?? 'N/A'}'),
            divider(Colors.grey),
            spacedText('Total:', '${order?.Total ?? 'N/A'}'),
            divider(Colors.grey),
            // Display status with color
            Text(
              'Status:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 13, 50, 172),
              ),
            ),
            SizedBox(
              height: 4,
            ),
            statusText(order?.status ?? 'N/A'),
            divider(Colors.grey),
            SizedBox(height: 20),
            Text(
              'Items:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 13, 50, 172),
              ),
            ),
            SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: formattedItems.length,
                itemBuilder: (ctx, index) {
                  final formattedItem = formattedItems[index];
                  return Column(
                    children: [
                      ListTile(
                        title: Text(
                          formattedItem,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Divider(
                        // Add a divider between list items
                        color: Colors.grey,
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
