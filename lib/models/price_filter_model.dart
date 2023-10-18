// import 'dart:ffi';
import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:tiffin_express_app/models/category_model.dart';
import 'package:tiffin_express_app/models/price_model.dart';

class PriceFilter extends Equatable {
  final int id;
  final Price price;
  final bool value;

  PriceFilter(
      {required this.id, required this.price, required this.value});

  PriceFilter copyWih({
    int? id,
    Price? price,
    bool? value,
  }) {
    return PriceFilter(
        id: id ?? this.id,
        price: price ?? this.price,
        value: value ?? this.value);
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        id,
        price,
        value,
      ];

  static List<PriceFilter> filters = Price.prices.map((price) =>
      PriceFilter(id: price.id, price: price, value: false)).toList();


}
