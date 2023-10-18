import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:tiffin_express_app/models/category_filter_model.dart';
import 'package:tiffin_express_app/models/models.dart';
import 'package:tiffin_express_app/models/price_filter_model.dart';

part 'filters_event.dart';
part 'filters_state.dart';

class FiltersBloc extends Bloc<FiltersEvent, FiltersState> {
  FiltersBloc() : super(FiltersLoading()) {
    on<LoadFilter>(_onLoadFilter);
    on<UpdateCategoryFilter>(_onLoadUpdateCategoryFilter);
    on<UpdatePriceFilter>(_onLoadUpdatePriceFilter);
  }

  void _onLoadFilter(LoadFilter event, Emitter<FiltersState> emit) {
    emit( FiltersLoaded(
        filter: Filter(
            categoryFilters: CategoryFilter.filters,
            priceFilters: PriceFilter.filters))
    );
  }

  void _onLoadUpdateCategoryFilter(
      UpdateCategoryFilter event, Emitter<FiltersState> emit) {
        final state = this.state;
        if (state is FiltersLoaded) {
      final List<CategoryFilter> updatedCategoryFilters =
          state.filter.categoryFilters.map((categoryFilter) {
        return categoryFilter.id == event.categoryFilter.id
            ? event.categoryFilter
            : categoryFilter;
      }).toList();

      emit( FiltersLoaded(
          filter: Filter(
              categoryFilters: updatedCategoryFilters,
              priceFilters: state.filter.priceFilters)));
    }

      }

  void _onLoadUpdatePriceFilter(
      UpdatePriceFilter event, Emitter<FiltersState> emit) {
        final state = this.state;
        if (state is FiltersLoaded) {
      final List<PriceFilter> updatedPriceFilters =
          state.filter.priceFilters.map((priceFilter) {
        return priceFilter.id == event.priceFilter.id
            ? event.priceFilter
            : priceFilter;
      }).toList();

      emit( FiltersLoaded(
          filter: Filter(
              categoryFilters: state.filter.categoryFilters,
              priceFilters: updatedPriceFilters)),);
    }

      }



}
