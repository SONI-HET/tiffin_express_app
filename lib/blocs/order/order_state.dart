import 'package:equatable/equatable.dart';
import 'package:tiffin_express_app/models/order_model.dart';

abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object> get props => [];
}

class InitialOrderState extends OrderState {}

class OrderPlacingState extends OrderState {}

class OrderPlacedState extends OrderState {
  final Orderrr order;

  OrderPlacedState(this.order);

  @override
  List<Object> get props => [order];
}

class OrderPlacementFailedState extends OrderState {
  final String error;

  OrderPlacementFailedState(this.error);

  @override
  List<Object> get props => [error];
}
