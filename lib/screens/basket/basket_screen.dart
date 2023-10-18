import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:tiffin_express_app/blocs/basket/basket_bloc.dart';
import 'package:tiffin_express_app/models/basket_model.dart';
import 'package:tiffin_express_app/models/menu_item_models.dart';
import 'package:tiffin_express_app/models/voucher_model.dart';
import 'package:tiffin_express_app/screens/home/home_screen.dart';
import 'package:tiffin_express_app/screens/tiffin_service_providers_details/tiffin_service_providers_details_screen.dart';

class BasketScreen extends StatefulWidget {
  BasketScreen({Key? key}) : super(key: key);
  static const String routeName = '/Basket';
  static Route route() {
    return MaterialPageRoute(
        builder: (_) => BasketScreen(),
        settings: const RouteSettings(
          name: routeName,
        ));
  }

  @override
  _BasketScreenState createState() => _BasketScreenState();
}

class _BasketScreenState extends State<BasketScreen> {
  bool _isLoading = false;
  final DataController dataController = Get.find<DataController>();

  @override
  Widget build(BuildContext context) {
// final dynamic arguments = ModalRoute.of(context)!.settings.arguments;
// print(arguments);
// final dynamic arguments = ModalRoute.of(context)!.settings.arguments;

// if (arguments is String) {
//   final serviceProviderId = arguments;
//   print(serviceProviderId); // Check if you get the expected value.
// } else {
//   print("Error: serviceProviderId is null or not a String.");
//   // Handle this error, such as navigating back or showing an error message.
// }

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Basket',
            style: TextStyle(fontFamily: 'Roboto', fontSize: 20),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/edit-basket');
                },
                icon: Icon(Icons.edit))
          ],
        ),
        bottomNavigationBar: BottomAppBar(
            child: Container(
          width: double.infinity,
          height: 50,
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (!_isLoading)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(),
                      padding: const EdgeInsets.symmetric(horizontal: 50)),
                  onPressed: () async {
                    setState(() {
                      _isLoading = true;
                    });
                    await Future.delayed(Duration(seconds: 3));

                    storeDataToFirebase(context);
                    setState(() {
                      _isLoading = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content:
                          Text('Your Order Has Been Placed Successfully...!!!'),
                      duration: Duration(seconds: 3),
                    ));
                    //               if (arguments is String) {
                    // final String serviceProviderId = arguments;

                    //               }

                    print("okokokok\n");
                    print(serviceProviderId);
                    Navigator.pushNamed(context, '/');
                  },
                  child: Text(
                    'Apply',
                    style: TextStyle(fontFamily: 'Roboto', fontSize: 20),
                  ),
                ),
              if (_isLoading)
                Container(
                  width: double.infinity,
                  height: 50,
                  color:
                      Colors.white.withOpacity(0.7), // Adjust opacity as needed
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          ),
        )),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cutlery',
                  style: Theme.of(context).textTheme.headline4!.copyWith(
                      color: Color.fromARGB(255, 13, 50, 172),
                      fontFamily: 'Roboto',
                      fontSize: 18),
                ),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 10, bottom: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5.0)),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text('Do you need cutlery?',
                              style: TextStyle(
                                fontSize: 17,
                                fontFamily: 'Roboto',
                              ))),
                      BlocBuilder<BasketBloc, BasketState>(
                        builder: (context, state) {
                          if (state is BasketLoading) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (state is BasketLoaded) {
                            return SizedBox(
                              width: 100,
                              child: SwitchListTile(
                                  dense: false,
                                  value: state.basket.cutlery,
                                  activeColor:
                                      Theme.of(context).colorScheme.primary,
                                  onChanged: (bool? newValue) {
                                    context
                                        .read<BasketBloc>()
                                        .add(ToogleSwitch());
                                  }),
                            );
                          } else {
                            return Text('Something went wrong.');
                          }
                        },
                      ),
                    ],
                  ),
                ),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                      Text(
                                          '\u{20B9} ${state.basket.itemQuantity(state.basket.items).keys.elementAt(index).price}',
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontFamily: 'Roboto',
                                          )),
                                    ],
                                  ),
                                );
                              });
                    } else {
                      return Text('Something went wrong');
                    }
                  },
                ),
                Container(
                  width: double.infinity,
                  height: 100,
                  margin: const EdgeInsets.only(top: 5),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                  ),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5.0)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset('assets/delivery.png'),
                      BlocBuilder<BasketBloc, BasketState>(
                        builder: (context, state) {
                          if (state is BasketLoading) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (state is BasketLoaded) {
                            return (state.basket.deliveryTime == null)
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        'Delivery in 20 minutes',
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize: 17,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pushNamed(
                                              context, '/delivery-time');
                                        },
                                        child: Text(
                                          'Change',
                                          style: TextStyle(
                                            fontFamily: 'Roboto',
                                            fontSize: 17,
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                : Text(
                                    'Delivery at ${state.basket.deliveryTime!.value}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  );
                          } else {
                            return Text('Something Went Erong');
                          }
                        },
                      )
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 100,
                  margin: const EdgeInsets.only(top: 5),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                  ),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5.0)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BlocBuilder<BasketBloc, BasketState>(
                        builder: (context, state) {
                          if (state is BasketLoading) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (state is BasketLoaded) {
                            final user = FirebaseAuth.instance.currentUser;

                            return (state.basket.voucher == null)
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'Do you have any voucher?',
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize: 17,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pushNamed(
                                              context, '/vouchers');
                                        },
                                        child: Text(
                                          'Apply',
                                          style: TextStyle(
                                            fontFamily: 'Roboto',
                                            fontSize: 17,
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                : Text(
                                    'Your Voucher is Added...!!!',
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                    ),
                                  );
                          } else {
                            return Text('Something Went Wrong');
                          }
                        },
                      ),
                      Image.asset('assets/voucher.png'),
                    ],
                  ),
                ),
                Container(
                    width: double.infinity,
                    height: 100,
                    margin: const EdgeInsets.only(top: 5),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                    ),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5.0)),
                    child: BlocBuilder<BasketBloc, BasketState>(
                      builder: (context, state) {
                        if (state is BasketLoading) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (state is BasketLoaded) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Subtotal',
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 17,
                                    ),
                                  ),
                                  Text(
                                    '\u{20B9} ${state.basket.subtotalString}',
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 17,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Delivery Fee',
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 17,
                                    ),
                                  ),
                                  Text(
                                    '\u{20B9} 5',
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 17,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Total',
                                    style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: 17,
                                        color: Color.fromARGB(255, 13, 50, 172),
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '\u{20B9} ${state.basket.totalString}',
                                    style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: 17,
                                        color: Color.fromARGB(255, 13, 50, 172),
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              )
                            ],
                          );
                        } else {
                          return Text('Something Went Wrong');
                        }
                      },
                    ))
              ],
            ),
          ),
        ));
  }

  Future<void> storeDataToFirebase(BuildContext context) async {
    // Access the BasketBloc's current state
    final state = context.read<BasketBloc>().state;

    // Check if the state is a BasketLoaded state
    if (state is BasketLoaded) {
      final basketData = state.basket;
      context.read<BasketBloc>().add(ClearBasket());
      context.read<BasketBloc>().add(UpdateDeliveryTime(null));
      context.read<BasketBloc>().add(RemoveVoucher());

      try {
        final user = FirebaseAuth.instance.currentUser;
        final FirebaseFirestore firestore = FirebaseFirestore.instance;

        QuerySnapshot userQuerySnapshot = await firestore
            .collection('Users')
            .where('Email', isEqualTo: user?.email)
            .get();

        DocumentSnapshot userDoc =
            await firestore.collection('Users').doc(user?.uid).get();
        if (user != null) {
          final serviceProviderId = dataController.serviceProviderId;
          final selectedServiceProviderId = serviceProviderId.toString();
          final orderData = {
            'userId': user.uid,
            'cutlery': state.basket.cutlery,
            'items': state.basket.items.map((item) => item.name).toList(),
            // 'totalAmount': state.basket.totalAmount,
            'deliveryTime': state.basket.deliveryTime?.value,
            'voucherAdded': state.basket.voucher != null,
            'Name': userDoc['Name'],
            'Email': user.email,
            'Address': userDoc['Address'],
            'Total': state.basket.totalString,
            'OrderTime': DateFormat('HH:mm:ss').format(DateTime.now()),
            'OrderDate': DateFormat('dd-MM-yyyy').format(DateTime.now()),
            'status': 'Pending',
          };

          final orderId = await FirebaseFirestore.instance
              .collection('Orders')
              .add(orderData);


          print('Order placed successfully with ID: ${orderId.id}');
          print(user.email);
          // final serviceProviderDocRef = firestore
          //     .collection('ServiceProviders')
          //     .doc(selectedServiceProviderId as String?);

          // Access the "Orders" subcollection of the service provider and add the order data
          // final serviceOrderCollection =
          //     serviceProviderDocRef.collection('Orders');
          // await serviceOrderCollection.add(orderData);

          // final documentId = await addUserDetails(name, email, password, phoneNo, address);
          await FirebaseFirestore.instance
              .collection('Orders')
              .doc(orderId.id)
              .update({
            'orderId': orderId.id,
          });
          final serviceProviderDocRef = firestore.collection('ServiceProviders').doc(selectedServiceProviderId as String?);
      final serviceOrderCollection = serviceProviderDocRef.collection('Orders');
      await serviceOrderCollection.add({
        ...orderData,
        'orderId': orderId.id,
      });

        } else {
          print('User is not logged in.');
        }
      } catch (e) {
        print('Error placing order: $e');
      }

      // Now you can access the data from basketData and store it to Firebase
      // For example, if you want to store items to Firebase:
      final items = basketData.items;

      // Your Firebase storage logic here...

      // Similarly, you can access other data from basketData and store it to Firebase.
    } else {
      // Handle the case where the state is not BasketLoaded
      print('Basket is not loaded');
    }
  }
}
