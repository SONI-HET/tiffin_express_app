import 'package:equatable/equatable.dart';
import 'package:tiffin_express_app/models/category_filter_model.dart';
import 'package:tiffin_express_app/models/price_filter_model.dart';


class Filter extends Equatable {
  final List<CategoryFilter> categoryFilters;
  final List<PriceFilter> priceFilters;

  const Filter({
    this.categoryFilters = const <CategoryFilter>[],
    this.priceFilters = const <PriceFilter>[],
  });

  Filter copyWith(
      {List<CategoryFilter>? categoryFilters,
      List<PriceFilter>? priceFilters}) {
    return Filter(
        categoryFilters: categoryFilters ?? this.categoryFilters,
        priceFilters: priceFilters ?? this.priceFilters);
  }
  
  @override
  // TODO: implement props
  List<Object?> get props => [
    categoryFilters,priceFilters
  ];
}
