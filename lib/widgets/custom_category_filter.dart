import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiffin_express_app/blocs/filters/filters_bloc.dart';
import 'package:tiffin_express_app/models/category_model.dart';

class CustomCategoryFilter extends StatelessWidget {
  final List<Categoryyy> categories;

  const CustomCategoryFilter({super.key, required this.categories});

  @override
  // Widget build(BuildContext context) {
  //   bool? isChecked = false;

  //   return ListView.builder(
  //     shrinkWrap: true,
  //     itemCount: categories.length,
  //     itemBuilder: (context, index) {
  //       return Container(
  //         width: double.infinity,
  //         margin: EdgeInsets.only(top: 10),
  //         padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
  //         decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(5.0)),
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Text(
  //               categories[index].name,
  //               style: Theme.of(context).textTheme.headline5,
  //             ),
  //             SizedBox(
  //               height: 25,
  //               child: Checkbox(value: isChecked, onChanged: (newValue) {
  //               }),
  //             )
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }
  Widget build(BuildContext context) {
    return BlocBuilder<FiltersBloc, FiltersState>(
      builder: (context, state) {
        if (state is FiltersLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is FiltersLoaded) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: state.filter.categoryFilters.length,
            itemBuilder: (context, index) {
              return Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5.0)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      state.filter.categoryFilters[index].category.name,
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    SizedBox(
                      height: 25,
                      child: Checkbox(
                        value: state.filter.categoryFilters[index].value,
                        activeColor: Theme.of(context).colorScheme.primary,
                        onChanged: (bool? newValue) {
                          context.read<FiltersBloc>().add(
                                UpdateCategoryFilter(
                                  categoryFilter: state
                                      .filter.categoryFilters[index]
                                      .copyWih(
                                          value: !state.filter
                                              .categoryFilters[index].value),
                                ),
                              );
                        },
                      ),
                    )
                  ],
                ),
              );
            },
          );
        } else {
          return Text('Something went wrong.');
        }
      },
    );
  }
}