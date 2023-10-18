part of 'basket_bloc.dart';

sealed class BasketEvent extends Equatable {
  const BasketEvent();

  @override
  List<Object> get props => [];
}

class StartBasket extends BasketEvent{
  
  @override
  List<Object> get props => [];
}

class AddItem extends BasketEvent{
    final MenuItem item;
    const AddItem(this.item);
  @override
  List<Object> get props => [item];
}

class RemoveItem extends BasketEvent{
  final MenuItem item;
    const RemoveItem(this.item);
  @override
  List<Object> get props => [item];
}

class RemoveAllItem extends BasketEvent{
  final MenuItem item;
    const RemoveAllItem(this.item);
  @override
  List<Object> get props => [item];
}

class ToogleSwitch extends BasketEvent{
    const ToogleSwitch();
    
  @override
  List<Object> get props => [];
}


class ApplyVoucher extends BasketEvent{
  final Voucher voucher;
  const ApplyVoucher(this.voucher);

  @override
  List<Object> get props => [voucher];
}


class SelectDeliveyTime extends BasketEvent{
  final DeliveryTime deliveryTime;
  const SelectDeliveyTime(this.deliveryTime);

  @override
  List<Object> get props => [deliveryTime];
}


class ClearBasket extends BasketEvent {}
class UpdateDeliveryTime extends BasketEvent {
  final DeliveryTime? deliveryTime;

  UpdateDeliveryTime(this.deliveryTime);
}

class RemoveVoucher extends BasketEvent {}

