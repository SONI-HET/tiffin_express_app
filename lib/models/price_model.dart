import 'package:equatable/equatable.dart';

class Price extends Equatable{
  final int id;
  final String price;

  Price({required this.id, required this.price});



  @override
  List<Object?> get props => [id,price];  

  static List<Price> prices = [
    Price(id: 1, price: '\u{20B9}'),
    Price(id: 2, price: '\u{20B9}\u{20B9}'),
    Price(id: 3, price: '\u{20B9}\u{20B9}\u{20B9}'),
  ];
}