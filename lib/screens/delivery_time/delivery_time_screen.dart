import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiffin_express_app/blocs/basket/basket_bloc.dart';
import 'package:tiffin_express_app/models/delivery_time_model.dart';
import 'package:tiffin_express_app/screens/home/home_screen.dart';

class DeliveryTimeScreen extends StatelessWidget {
  const DeliveryTimeScreen({super.key});

  static const String routeName = '/delivery-time';
  static Route route() {
    return MaterialPageRoute(
        builder: (_) => const DeliveryTimeScreen(),
        settings: const RouteSettings(
          name: routeName,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery',style: TextStyle(fontFamily: 'Roboto',fontSize: 20),),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  shape: RoundedRectangleBorder(),
                  primary: Theme.of(context).colorScheme.secondary,
                ),
                child: Text('Select'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose a date',
              style: TextStyle(
                  color: Color.fromARGB(255, 13, 50, 172),
                  fontSize: 17,
                  fontWeight: FontWeight.bold),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 10),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Delivery is Today!!!'),
                        duration: Duration(seconds: 2),
                      ));
                    },
                    child: Text('Today'),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Delivery is Tomorrow!!!'),
                        duration: Duration(seconds: 2),
                      ));
                    },
                    child: Text('Tomorrow'),
                  ),
                ],
              ),
            ),
            Text(
              'Choose the Time',
              style: TextStyle(
                  color: Color.fromARGB(255, 13, 50, 172),
                  fontSize: 17,
                  fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 2.5,
                    ),
                    itemCount: DeliveryTime.deliveryTimes.length,
                    itemBuilder: (context, index) {

                      return BlocBuilder<BasketBloc, BasketState>(
                        builder: (context, state) {
                          return Card(
                              child: TextButton(
                            onPressed: () {
                              context.read<BasketBloc>().add(SelectDeliveyTime(DeliveryTime.deliveryTimes[index]));
                              print(DeliveryTime.deliveryTimes[index].value);
                            },
                            child: Text(
                                '${DeliveryTime.deliveryTimes[index].value}',
                                style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 17,
                                    color: Colors.black)),
                          ));
                        },
                      );
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
