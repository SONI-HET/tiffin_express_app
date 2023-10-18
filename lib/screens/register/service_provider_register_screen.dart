import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceProviderSignUp extends StatefulWidget {
  const ServiceProviderSignUp({Key? key}) : super(key: key);

  static const String routeName = '/service-provider-signup';

  static Route route() {
    return MaterialPageRoute(
      builder: (_) => ServiceProviderSignUp(),
      settings: RouteSettings(
        name: routeName,
      ),
    );
  }

  @override
  _ServiceProviderSignUpState createState() => _ServiceProviderSignUpState();
}

class _ServiceProviderSignUpState extends State<ServiceProviderSignUp> {
  final TextEditingController _tiffinServiceNameController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  bool _isServiceProvider = false;
    bool _isLoading = false; // Track loading state


  Future<void> _registerUser() async {
  final String tiffinServiceName = _tiffinServiceNameController.text.trim();
  final String name = _nameController.text.trim();
  final String email = _emailController.text.trim();
  final String phoneNo = _phoneNoController.text.trim();
  final String password = _passwordController.text.trim();
  final String address = _addressController.text.trim();

  if (tiffinServiceName.isEmpty ||
      name.isEmpty ||
      email.isEmpty ||
      phoneNo.isEmpty ||
      password.isEmpty ||
      address.isEmpty) {
    // All fields are required
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('All fields are required.'),
        duration: Duration(seconds: 3),
      ),
    );
    return;
  }

  try {
    setState(() {
      _isLoading = true; // Show loading indicator
    });

    // Fetch the current counter value
    final counterDoc =
        await FirebaseFirestore.instance.collection('Counters').doc('serviceProviderCounter').get();

    // Increment the counter and use it as the ID
    final int currentCounter = counterDoc['value'];
    final int serviceProviderId = currentCounter + 1;

    // Create the user account using Firebase Authentication
    final UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Get the user's ID from the authentication result
    final String userId = userCredential.user!.uid;

    // Store additional user data in Firestore
    await FirebaseFirestore.instance.collection('ServiceProviders').doc(userId).set({
      'tiffinServiceName': tiffinServiceName,
      'name': name,
      'email': email,
      'phoneNo': phoneNo,
      'address': address,
      'isServiceProvider': _isServiceProvider,
      'password': password,
      'serviceProviderId': serviceProviderId, // Store the assigned integer ID
    });

    // Update the counter in Firestore for the next registration
    await counterDoc.reference.update({'value': serviceProviderId});
await FirebaseFirestore.instance.collection('ServiceProviders').doc(userId).update({
      'serviceProviderDocumentId': userId,
    });

    Navigator.pushNamed(context, '/login');
    // Registration successful
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Registration successful.'),
        duration: Duration(seconds: 3),
      ),
    );

    // Navigate to the home screen or any other screen as needed
    // Example: Navigator.pushNamed(context, '/home');
  } catch (e) {
    // Handle registration errors
    print('Registration error: $e');
    String errorMessage = 'Registration failed. Please try again.';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        duration: Duration(seconds: 3),
      ),
    );
  } finally {
    setState(() {
      _isLoading = false; // Hide loading indicator
    });
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/register.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 35),
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Create Account Here,',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 33,
                    ),
                  ),
                  SizedBox(height: 50),
                  TextField(
                    controller: _tiffinServiceNameController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      hintText: "Tiffin Service Name",
                      hintStyle: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _nameController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      hintText: "Name",
                      hintStyle: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _emailController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      hintText: "Email",
                      hintStyle: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _phoneNoController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      hintText: "Phone Number",
                      hintStyle: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _passwordController,
                    style: TextStyle(color: Colors.white),
                    obscureText: true,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      hintText: "Password",
                      hintStyle: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _addressController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      hintText: "Address",
                      hintStyle: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Checkbox(
                        value: _isServiceProvider,
                        onChanged: (value) {
                          setState(() {
                            _isServiceProvider = value ?? false;
                          });
                        },
                      ),
                      Text(
                        'Yes, I am a service provider',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 27,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Color(0xff4c505b),
                        child: _isLoading
                                    ? CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                    :  IconButton(
                          color: Colors.white,
                          onPressed: () {
                            _registerUser();
                          },
                          icon: Icon(
                            Icons.arrow_forward,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
