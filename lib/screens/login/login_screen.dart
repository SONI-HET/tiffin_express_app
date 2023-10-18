import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyLogin extends StatefulWidget {
  const MyLogin({Key? key}) : super(key: key);
static const String routeName = '/login';
  static Route route() {
    return MaterialPageRoute(
        builder: (_) => MyLogin(),
        settings: RouteSettings(
          name: routeName,
        ));
  }
  @override
  _MyLoginState createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> fetchdata() async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please provide both email and password.'),
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final String userId = userCredential.user!.uid;

      final DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('Users').doc(userId).get();
      final bool isUser = userDoc.exists;

      final DocumentSnapshot serviceProviderDoc =
          await FirebaseFirestore.instance.collection('ServiceProviders').doc(userId).get();
      final bool isServiceProvider = serviceProviderDoc.exists;
      final String adminEmail = 'admin@gmail.com';
    final bool isAdmin = email == adminEmail;


      if (isUser) {
        final String userName = userDoc['Name'];
        final String successMessage = 'Logged In Successfully as $userName';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(successMessage),
            duration: Duration(seconds: 3),
          ),
        );
        if (isAdmin) {
        Navigator.pushNamed(context, '/admin'); // Replace with the admin route
      } else {
        Navigator.pushNamed(context, '/');
      }

      } else if (isServiceProvider) {
        final String serviceProviderName = serviceProviderDoc['name'];
        final String successMessage =
            'Logged In Successfully as Service Provider $serviceProviderName';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(successMessage),
            duration: Duration(seconds: 3),
          ),
        );
        Navigator.pushNamed(context, '/service-provider-screen');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('User does not exist.'),
            duration: Duration(seconds: 3),
          ),
        );
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Login error: $e');
      String errorMessage =
          'Invalid credentials. Please check your email and password.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          duration: Duration(seconds: 3),
        ),
      );

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/login1.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(),
            Container(
              padding: EdgeInsets.only(left: 35, top: 130),
              child: Text(
                'Login Here',
                style: TextStyle(color: Colors.white, fontSize: 33),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.42,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 35, right: 35),
                      child: Column(
                        children: [
                          TextField(
                            controller: _emailController,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              fillColor: Colors.grey.shade100,
                              filled: true,
                              hintText: "Email",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          TextField(
                            controller: _passwordController,
                            style: TextStyle(),
                            obscureText: true,
                            decoration: InputDecoration(
                              fillColor: Colors.grey.shade100,
                              filled: true,
                              hintText: "Password",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Sign in',
                                style: TextStyle(
                                  fontSize: 27,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Color(0xff4c505b),
                                child: isLoading
                                    ? CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                    : IconButton(
                                        color: Colors.white,
                                        onPressed: () async {
                                          if (!isLoading) {
                                            await fetchdata();
                                          }
                                        },
                                        icon: Icon(
                                          Icons.arrow_forward,
                                        ),
                                      ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/register');
                                },
                                child: Text(
                                  'Sign Up',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Color(0xff4c505b),
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, '/service-provider-signup');
                                },
                                child: Text(
                                  'Sign Up as \nService Provider',
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Color(0xff4c505b),
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
