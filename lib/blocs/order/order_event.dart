import 'package:equatable/equatable.dart';
import 'package:tiffin_express_app/models/order_model.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object> get props => [];
}

class PlaceOrderEvent extends OrderEvent {
  final Orderrr order;

  PlaceOrderEvent(this.order);

  @override
  List<Object> get props => [order];
}
