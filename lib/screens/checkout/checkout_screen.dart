import 'package:flutter/material.dart';
import 'package:tiffin_express_app/screens/home/home_screen.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  static const String routeName = '/Checkout';
  static Route route() {
    return MaterialPageRoute(
        builder: (_) => const CheckoutScreen(),
        settings: const RouteSettings(
          name: routeName,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Home Screen'),
          onPressed: () {
            Navigator.pushNamed(context, '/');
          },
        ),
      ),
    );
  }
}
