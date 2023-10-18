import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tiffin_express_app/models/order_model.dart';

class OrderRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> placeOrder(Orderrr order) async {
    final orderData = {
      'user': order.user..toString(),
      'items': order.items.map((item) => item.toString()).toList(),
      'totalPrice': order.totalPrice,
      'deliveryAddress': order.deliveryAddress,
      // Add other order data as needed
    };

    final docRef = await _firestore.collection('orders').add(orderData);
    return docRef.id;
  }
}
