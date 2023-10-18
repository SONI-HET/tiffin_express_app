import 'package:firebase_auth/firebase_auth.dart';
import 'package:tiffin_express_app/models/menu_item_models.dart';
import 'package:tiffin_express_app/repositories/order_repository/order_repository.dart';

class Orderrr {
  final String orderId;
  final User user;
  final List<MenuItem> items;
  final double totalPrice;
  final String deliveryAddress;
  // Add other properties as needed

  Orderrr({
    required this.orderId,
    required this.user,
    required this.items,
    required this.totalPrice,
    required this.deliveryAddress,
  });

  
  Orderrr copyWith({
    String? orderId,
    User? user,
    List<MenuItem>? items,
    double? totalPrice,
    String? deliveryAddress
  }) {
    return Orderrr(
      orderId: orderId ?? this.orderId,
      user: user ?? this.user,
      items: items ?? this.items,
      totalPrice: totalPrice ?? this.totalPrice,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
    );
  }

}
