import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiffin_express_app/blocs/filters/filters_bloc.dart';
import 'package:tiffin_express_app/models/category_model.dart';
import 'package:tiffin_express_app/models/models.dart';
import 'package:tiffin_express_app/models/price_model.dart';
import 'package:tiffin_express_app/screens/home/home_screen.dart';
import 'package:tiffin_express_app/widgets/custom_category_filter.dart';
import 'package:tiffin_express_app/widgets/custom_price_filter.dart';

class FilterScreen extends StatelessWidget {
  const FilterScreen({super.key});

  static const String routeName = '/filters';
  static Route route() {
    return MaterialPageRoute(
        builder: (_) => const FilterScreen(),
        settings: const RouteSettings(
          name: routeName,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Filter',
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
            child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BlocBuilder<FiltersBloc, FiltersState>(
                builder: (context, state) {
                  if (state is FiltersLoading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state is FiltersLoaded) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(),
                          padding: const EdgeInsets.symmetric(horizontal: 50)),
                      onPressed: () {
                        var categories = state.filter.categoryFilters
                            .where((filter) => filter.value)
                            .map((filter) => filter.category.name)
                            .toList();
                        print(categories);
                        var prices = state.filter.priceFilters
                            .where((filter) => filter.value)
                            .map((filter) => filter.price.price)
                            .toList();
                        print(prices);

                        List<ServiceProvider> serviceProviders = ServiceProvider
                            .serviceProvider
                            .where((serviceProvider) => categories.any(
                                (category) =>
                                    serviceProvider.tags.contains(category)))
                                    
                                      .where((serviceProvider) => prices.any(
                                (prices) =>
                                    serviceProvider.priceCategory.contains(prices)))
                            .toList();
                          Navigator.pushNamed(context, '/TiffinServiceProviderListing', arguments: serviceProviders);
                      },
                      child: Text(
                        'Apply',
                        style: TextStyle(fontFamily: 'Roboto', fontSize: 20),
                      ),
                    );
                  } else {
                    return Text('Something went wrong');
                  }
                },
              )
            ],
          ),
        )),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Text(
                'Price',
                style: TextStyle(
                    color: Color.fromARGB(255, 13, 50, 172),
                    fontFamily: 'Roboto',
                    fontSize: 17,
                    fontWeight: FontWeight.bold),
              ),
              CustomPriceFilter(prices: Price.prices),
              Text(
                'Category',
                style: TextStyle(
                    color: Color.fromARGB(255, 13, 50, 172),
                    fontFamily: 'Roboto',
                    fontSize: 17,
                    fontWeight: FontWeight.bold),
              ),
              CustomCategoryFilter(categories: Categoryyy.categories),
            ],
          ),
        ));
  }
}
