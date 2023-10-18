import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiffin_express_app/blocs/filters/filters_bloc.dart';
import 'package:tiffin_express_app/models/price_model.dart';

class CustomPriceFilter extends StatelessWidget {
  final List<Price> prices;
  const CustomPriceFilter({super.key, required this.prices});

  @override
  // Widget build(BuildContext context) {
  //   return BlocBuilder<FiltersBloc, FiltersState>(
  //     builder: (context, state) {
  //       if (state is FiltersLoading) {
  //         return CircularProgressIndicator();
  //       }
  //       if(state is FiltersLoaded)
  //       {return Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: prices
  //             .map((price) => InkWell(
  //                   onTap: () {},
  //                   child: Container(
  //                     margin: const EdgeInsets.only(top: 10, bottom: 10),
  //                     padding: const EdgeInsets.symmetric(
  //                         horizontal: 40, vertical: 10),
  //                     decoration: BoxDecoration(
  //                         color: Colors.white,
  //                         borderRadius: BorderRadius.circular(5)),
  //                     child: Text(
  //                       price.price,
  //                       style: Theme.of(context).textTheme.headline5,
  //                     ),
  //                   ),
  //                 ))
  //             .toList(),
  //       );

  //       }
  //       else 
  //       {
  //         return Text('blablabla');
  //       }
        
  //     },
  //   );
  // }
  Widget build(BuildContext context) {
    return BlocBuilder<FiltersBloc, FiltersState>(
      builder: (context, state) {
        if (state is FiltersLoading) {
          return Center(child: CircularProgressIndicator());
        }
        if (state is FiltersLoaded) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: state.filter.priceFilters
                .asMap()
                .entries
                .map(
                  (price) => InkWell(
                    onTap: () {
                      context.read<FiltersBloc>().add(
                            UpdatePriceFilter(
                              priceFilter: state.filter.priceFilters[price.key]
                                  .copyWih(
                                      value: !state.filter
                                          .priceFilters[price.key].value),
                            ),
                          );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(
                        top: 10,
                        bottom: 10,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: state.filter.priceFilters[price.key].value
                            ? Theme.of(context)
                                .colorScheme
                                .primary
                                .withAlpha(100)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        '${state.filter.priceFilters[price.key].price.price}',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    ),
                  ),
                )
                .toList(),
          );
        } else {
          return Text('Something went wrong');
        }
      },
    );
  }
// Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: Price.prices
//           .map((price) => InkWell(
//                 onTap: () {},
//                 child: Container(
//                   margin: const EdgeInsets.only(top: 10, bottom: 10),
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
//                   decoration: BoxDecoration(
//                     color: Color.fromARGB(255, 46, 137, 247),
//                       borderRadius: BorderRadius.circular(5)),
//                   child: Text(
//                     price.price,
//                     style: Theme.of(context).textTheme.headline5,
//                   ),
//                 ),
//               ))
//           .toList(),
//     );
//   }
}
