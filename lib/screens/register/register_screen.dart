import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyRegister extends StatefulWidget {
  const MyRegister({Key? key}) : super(key: key);
static const String routeName = '/register';
  static Route route() {
    return MaterialPageRoute(
        builder: (_) => MyRegister(),
        settings: RouteSettings(
          name: routeName,
        ));
  }
  @override
  _MyRegisterState createState() => _MyRegisterState();
}

class _MyRegisterState extends State<MyRegister> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  bool isLoading = false;

  Future<void> registerUser() async {
    if (_emailController.text.isEmpty ||
        _nameController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _phoneNoController.text.isEmpty ||
        _addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all fields.'),
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      String userId = userCredential.user!.uid;

      // Store additional user data in Firestore
      await _firestore.collection('Users').doc(userId).set({
        'Name': _nameController.text.trim(),
        'Email': _emailController.text.trim(),
        'PhoneNo': _phoneNoController.text.trim(),
        'Address': _addressController.text.trim(),
        // Add more user data fields as needed
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Signed Up Successfully. Sign In Here.'),
          duration: Duration(seconds: 3),
        ),
      );

      Navigator.pushNamed(context, '/login');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred during registration. Please try again later.'),
          duration: Duration(seconds: 3),
        ),
      );
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
              margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.25),
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
                  SizedBox(height: 30),
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
                        child: isLoading
                            ? CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : IconButton(
                                color: Colors.white,
                                onPressed: () {
                                  registerUser();
                                },
                                icon: Icon(
                                  Icons.arrow_forward,
                                ),
                              ),
                      )
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
