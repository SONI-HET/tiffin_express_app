import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:tiffin_express_app/blocs/voucher/voucher_bloc.dart';
import 'package:tiffin_express_app/models/basket_model.dart';
import 'package:tiffin_express_app/models/delivery_time_model.dart';
import 'package:tiffin_express_app/models/menu_item_models.dart';
// import 'package:tiffin_express_app/models/order_model.dart';
import 'package:tiffin_express_app/models/voucher_model.dart';
import 'package:tiffin_express_app/screens/my_order/my_order_screen.dart';

part 'basket_event.dart';
part 'basket_state.dart';

class BasketBloc extends Bloc<BasketEvent, BasketState> {
  final VoucherBloc _voucherBloc;
  late StreamSubscription _voucherSubscription;
  BasketBloc({required VoucherBloc voucherBloc})
      : _voucherBloc = voucherBloc,
        super(BasketLoading()) {
    on<StartBasket>(_onStartBasket);
    on<AddItem>(_onAddItem);
    on<RemoveItem>(_onRemoveItem);
    on<RemoveAllItem>(_onRemoveAllItem);
    on<ToogleSwitch>(_onToogleSwitch);
    on<ApplyVoucher>(_onApplyVoucher);
    on<SelectDeliveyTime>(_onSelectDeliveyTime);
    on<ClearBasket>(_onClearBasket); // Add this line
    on<UpdateDeliveryTime>(_onUpdateDeliveryTime); // Add this line
    on<RemoveVoucher>(_onRemoveVoucher); // Add this line

    _voucherSubscription = voucherBloc.stream.listen((state) {
      if (state is VoucherSelected) add(ApplyVoucher(state.voucher));
    });
  }
  void _onClearBasket(
    ClearBasket event,
    Emitter<BasketState> emit,
  ) {
    emit(BasketLoaded(basket: Basket()));
  }

  void _onUpdateDeliveryTime(
    UpdateDeliveryTime event,
    Emitter<BasketState> emit,
  ) {
    final state = this.state;
    if (state is BasketLoaded) {
      emit(BasketLoaded(
        basket: state.basket.copyWith(deliveryTime: event.deliveryTime),
      ));
    }
  }

void _onRemoveVoucher(
    RemoveVoucher event,
    Emitter<BasketState> emit,
  ) {
    final state = this.state;
    if (state is BasketLoaded) {
      emit(BasketLoaded(
        basket: state.basket.copyWith(voucher: null),
      ));
    }
  }

  void _onStartBasket(
    StartBasket event,
    Emitter<BasketState> emit,
  ) async {
    emit(BasketLoading());
    try {
      await Future<void>.delayed(const Duration(seconds: 1));
      emit(BasketLoaded(basket: Basket()));
    } catch (_) {}
  }

  void _onAddItem(
    AddItem event,
    Emitter<BasketState> emit,
  ) {
    final state = this.state;
    if (state is BasketLoaded) {
      try {
        emit(BasketLoaded(
            basket: state.basket.copyWith(
                items: List.from(state.basket.items)..add(event.item))));
      } catch (_) {}
    }
  }

  void _onRemoveItem(
    RemoveItem event,
    Emitter<BasketState> emit,
  ) {
    final state = this.state;
    if (state is BasketLoaded) {
      try {
        emit(BasketLoaded(
            basket: state.basket.copyWith(
                items: List.from(state.basket.items)..remove(event.item))));
      } catch (_) {}
    }
  }

  void _onRemoveAllItem(
    RemoveAllItem event,
    Emitter<BasketState> emit,
  ) {
    final state = this.state;
    if (state is BasketLoaded) {
      try {
        emit(BasketLoaded(
            basket: state.basket.copyWith(
                items: List.from(state.basket.items)
                  ..removeWhere((item) => item == event.item))));
      } catch (_) {}
    }
  }

  void _onToogleSwitch(
    ToogleSwitch event,
    Emitter<BasketState> emit,
  ) {
    final state = this.state;
    if (state is BasketLoaded) {
      try {
        emit(BasketLoaded(
          basket: state.basket.copyWith(
            cutlery: !state.basket.cutlery,
          ),
        ));
      } catch (_) {}
    }
  }

  void _onApplyVoucher(
    ApplyVoucher event,
    Emitter<BasketState> emit,
  ) {
    final state = this.state;
    if (state is BasketLoaded) {
      try {
        emit(
          BasketLoaded(
            basket: state.basket.copyWith(voucher: event.voucher),
          ),
        );
      } catch (_) {}
    }
  }

  void _onSelectDeliveyTime(
    SelectDeliveyTime event,
    Emitter<BasketState> emit,
  ) {
    final state = this.state;
    if (state is BasketLoaded) {
      try {
        emit(BasketLoaded(
            basket: state.basket.copyWith(deliveryTime: event.deliveryTime)));
      } catch (_) {}
    }
  }
}
