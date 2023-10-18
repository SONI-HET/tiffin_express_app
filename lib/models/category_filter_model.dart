// import 'dart:ffi';
import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:tiffin_express_app/models/category_model.dart';

class CategoryFilter extends Equatable {
  final int id;
  final Categoryyy category;
  final bool value;

  CategoryFilter(
      {required this.id, required this.category, required this.value});

  CategoryFilter copyWih({
    int? id,
    Categoryyy? category,
    bool? value,
  }) {
    return CategoryFilter(
        id: id ?? this.id,
        category: category ?? this.category,
        value: value ?? this.value);
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        id,
        category,
        value,
      ];

  static List<CategoryFilter> filters = Categoryyy.categories.map((category) =>
      CategoryFilter(id: category.id, category: category, value: false)).toList();


}
