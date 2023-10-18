import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tiffin_express_app/blocs/basket/basket_bloc.dart';
import 'package:tiffin_express_app/screens/home/home_screen.dart';

class EditBasketScreen extends StatelessWidget {
  const EditBasketScreen({super.key});

  static const String routeName = '/edit-basket';
  static Route route() {
    return MaterialPageRoute(
        builder: (_) => const EditBasketScreen(),
        settings: const RouteSettings(
          name: routeName,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Edit Basket',
            style: TextStyle(fontFamily: 'Roboto', fontSize: 20),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
            child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(),
                    padding: const EdgeInsets.symmetric(horizontal: 50)),
                child: Text(
                  'Done',
                  style: TextStyle(fontFamily: 'Roboto', fontSize: 20),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          ),
        )),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Items',
                style: Theme.of(context).textTheme.headline4!.copyWith(
                    color: Color.fromARGB(255, 13, 50, 172),
                    fontFamily: 'Roboto',
                    fontSize: 18),
              ),
              BlocBuilder<BasketBloc, BasketState>(
                builder: (context, state) {
                  if (state is BasketLoading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state is BasketLoaded) {
                    return state.basket.items.length == 0
                        ? Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(top: 5),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'No items in the Basket',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontFamily: 'Roboto', fontSize: 17),
                                )
                              ],
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: state.basket
                                .itemQuantity(state.basket.items)
                                .keys
                                .length,
                            itemBuilder: (context, index) {
                              return Container(
                                width: double.infinity,
                                margin: const EdgeInsets.only(top: 5),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 5),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5.0)),
                                child: Row(
                                  children: [
                                    Text(
                                        '${state.basket.itemQuantity(state.basket.items).entries.elementAt(index).value}x',
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontFamily: 'Roboto',
                                            color: Color.fromARGB(
                                                255, 13, 50, 172))),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Expanded(
                                        child: Text(
                                            '${state.basket.itemQuantity(state.basket.items).keys.elementAt(index).name}',
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontFamily: 'Roboto',
                                            ))),
                                    IconButton(
                                        visualDensity: VisualDensity.compact,
                                        onPressed: () {
                                          context.read<BasketBloc>()
                                            ..add(RemoveAllItem(state.basket
                                                .itemQuantity(
                                                    state.basket.items)
                                                .keys
                                                .elementAt(index)));
                                        },
                                        icon: Icon(Icons.delete)),
                                    IconButton(
                                        visualDensity: VisualDensity.compact,
                                        onPressed: () {
                                          context.read<BasketBloc>()
                                            ..add(RemoveItem(state.basket
                                                .itemQuantity(
                                                    state.basket.items)
                                                .keys
                                                .elementAt(index)));
                                        },
                                        icon: Icon(Icons.remove_circle)),
                                    IconButton(
                                        visualDensity: VisualDensity.compact,
                                        onPressed: () {
                                          context.read<BasketBloc>()
                                            ..add(AddItem(state.basket
                                                .itemQuantity(
                                                    state.basket.items)
                                                .keys
                                                .elementAt(index)));
                                        },
                                        icon: Icon(Icons.add_circle))
                                  ],
                                ),
                              );
                            });
                  } else {
                    return Text('Something went wrong');
                  }
                },
              ),
            ],
          ),
        ));
  }
}
