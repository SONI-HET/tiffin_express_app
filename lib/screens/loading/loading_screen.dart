import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoadingScreen(),
    );
  }
}

class LoadingScreen extends StatefulWidget {
  static const String routeName = '/loading';
  static Route route() {
    return MaterialPageRoute(
        builder: (_) => LoadingScreen(),
        settings: RouteSettings(
          name: routeName,
        ));
  }
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoadingScreen> {
  bool isLoading = false;

  // Simulate a login process
  void performLogin() async {
    // Set isLoading to true to show the loading indicator
    setState(() {
      isLoading = true;
    });

    // Simulate a login delay (you should replace this with your actual login logic)
    await Future.delayed(Duration(seconds: 3));

    // After the login is complete, set isLoading to false
    setState(() {
      isLoading = false;
    });

    // Navigate to the next screen or perform other actions after login
    // For example: Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Example'),
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : ElevatedButton(
                onPressed: () {
                  // Call your login function here
                  performLogin();
                },
                child: Text('Login'),
              ),
      ),
    );
  }
}
