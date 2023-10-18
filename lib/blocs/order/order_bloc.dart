import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore_platform_interface/src/platform_interface/platform_interface_index_definitions.dart';
import 'package:tiffin_express_app/blocs/order/order_event.dart';
import 'package:tiffin_express_app/blocs/order/order_state.dart';
import 'package:tiffin_express_app/models/order_model.dart';
import 'package:tiffin_express_app/repositories/order_repository/order_repository.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository orderRepository;

  OrderBloc(this.orderRepository) : super(InitialOrderState());

  @override
  Stream<OrderState> mapEventToState(OrderEvent event) async* {
    if (event is PlaceOrderEvent) {
      yield OrderPlacingState();

      try {
        final order = event.order;
        final orderId = await orderRepository.placeOrder(order);

        yield OrderPlacedState(order.copyWith(orderId: orderId));
      } catch (error) {
        yield OrderPlacementFailedState(error.toString());
      }
    }
  }
}
