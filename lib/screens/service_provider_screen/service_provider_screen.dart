import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceProviderScreen extends StatefulWidget {
  static const String routeName = '/service-provider-screen';

  static Route route() {
    return MaterialPageRoute(
      builder: (_) => ServiceProviderScreen(),
      settings: RouteSettings(
        name: routeName,
      ),
    );
  }

  @override
  _ServiceProviderScreenState createState() => _ServiceProviderScreenState();
}

class _ServiceProviderScreenState extends State<ServiceProviderScreen> {
  XFile? _selectedProfileImage;
  XFile? _selectedCoverImage;
  String serviceProviderName = '';
  String serviceProviderEmail = '';
  String serviceProviderPhone = '';
  String serviceProviderAddress = '';
  String serviceProviderInfo= '';
  String serviceProviderTags= '';
  String imageURL =
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTnCZxKdEhP-Br73uHyiT6fELLQNUoTSwfpwQ&usqp=CAU';
  String profileURL =
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRFrAeGZS6pC90zXGR17NB8g4E_ICBdZYh8YA&usqp=CAU';

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final firebase_storage.FirebaseStorage _storage =
      firebase_storage.FirebaseStorage.instance;
  bool isProfileImageLoading = true;
  bool isCoverImageLoading = true;

  @override
  void initState() {
    super.initState();
    // Fetch service provider data when the screen loads
    fetchServiceProviderData();
  }

  Future<void> fetchServiceProviderData() async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        // Fetch service provider data from Firestore
        DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
            .collection('ServiceProviders')
            .doc(user.uid)
            .get();

        if (documentSnapshot.exists) {
          setState(() {
            // Update state variables with fetched data
            serviceProviderName = documentSnapshot['name'];
            serviceProviderEmail = documentSnapshot['email'];
            serviceProviderPhone = documentSnapshot['phoneNo'];
            serviceProviderAddress = documentSnapshot['address'];
            imageURL = documentSnapshot['cover_image_url'];
            profileURL = documentSnapshot['profile_image_url'];
            serviceProviderInfo = documentSnapshot['info'];
            serviceProviderTags = documentSnapshot['tags'];
            isProfileImageLoading = false; // Set loading state to false
            isCoverImageLoading = false; // Set loading state to false
          });
        }
      } catch (e) {
        print('Error fetching data: $e');
        setState(() {
          isProfileImageLoading =
              false; // Set loading state to false in case of an error
          isCoverImageLoading =
              false; // Set loading state to false in case of an error
        });
      }
    }
  }

  Future<void> _pickCoverImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _selectedCoverImage = pickedImage;
      });
      _uploadCoverImageToFirebase(_selectedCoverImage!);
    }
  }

  Future<void> _uploadCoverImageToFirebase(XFile imageFile) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        // Fetch the username of the service provider
        DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
            .collection('ServiceProviders')
            .doc(user.uid)
            .get();

        if (documentSnapshot.exists) {
          String serviceProviderUsername = documentSnapshot['name'];
          String imageName =
              'cover_image_${DateTime.now().millisecondsSinceEpoch}.png';
          final ref = _storage
              .ref()
              .child('ServiceProviders')
              .child(serviceProviderUsername)
              .child('cover_image')
              .child(imageName);
          await ref.putFile(File(imageFile.path));
          String downloadURL = await ref.getDownloadURL();
          _updateCoverImageURLInDatabase(downloadURL);
        }
      }
    } catch (e) {
      print('Error uploading cover image: $e');
    }
  }

  void _updateCoverImageURLInDatabase(String downloadURL) {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        FirebaseFirestore.instance
            .collection('ServiceProviders')
            .doc(user.uid)
            .update({
          'cover_image_url': downloadURL,
        }).then((_) {
          // Fetch the username of the service provider
          FirebaseFirestore.instance
              .collection('ServiceProviders')
              .doc(user.uid)
              .get()
              .then((documentSnapshot) {
            if (documentSnapshot.exists) {
              String serviceProviderUsername = documentSnapshot['name'];

              // Update the cover image URL in the user's directory with their username
              FirebaseFirestore.instance
                  .collection('ServiceProviders')
                  .doc(user.uid)
                  .update({
                'cover_image_url': downloadURL,
              });

              print('Cover image URL updated in Firestore: $downloadURL');
            }
          });
        });
      }
    } catch (e) {
      print('Error updating cover image URL: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tiffin Service Provider'),
        backgroundColor: Color.fromARGB(255, 13, 50, 172),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 13, 50, 172),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    child: isProfileImageLoading
                        ? CircularProgressIndicator() // Show loading indicator
                        : null,
                    radius: 40,
                    backgroundColor: Colors.white,
                    backgroundImage: isProfileImageLoading
                        ? null
                        : (_selectedProfileImage != null
                            ? FileImage(File(_selectedProfileImage!.path))
                            : NetworkImage(profileURL)
                                as ImageProvider<Object>),
                  ),
                  SizedBox(height: 10),
                  Text(
                    serviceProviderName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    serviceProviderEmail,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('My Profile'),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/service-provider-profile',
                  arguments: _selectedProfileImage?.path,
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.shopping_cart),
              title: Text('Manage Orders'),
              onTap: () {
                // Navigate to the order received screen here
                Navigator.pushNamed(context, '/manage-order-screen');
              },
            ),
            ListTile(
              leading: Icon(Icons.restaurant_menu),
              title: Text('Manage Menu Items'),
              onTap: () {
                // Navigate to the order received screen here
                Navigator.pushNamed(context, '/service-provider-menu-screen');
              },
            ),
            ListTile(
              leading: Icon(Icons.photo),
              title: Text('Change Cover Photo'),
              onTap: _pickCoverImage,
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('Other Information'),
              onTap: () {
                // Navigate to the order received screen here
                Navigator.pushNamed(context, '/service-provider-info');
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Logout'),
              onTap: () {
                _signOut();
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                if (!isProfileImageLoading) {
                  _pickCoverImage();
                }
              },
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  Container(
                    height: 250,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: _selectedCoverImage != null
                            ? FileImage(File(_selectedCoverImage!.path))
                                as ImageProvider<Object>
                            : NetworkImage(imageURL),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: isCoverImageLoading
            ? Center(
                child: CircularProgressIndicator(), // Show loading indicator
              )
            : null,

                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 15.0,
                    ),
                    child: Icon(
                      Icons.camera_alt,
                      size: 40,
                      color: Color.fromARGB(255, 13, 50, 172).withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Service Details',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Panjab Tiffin Service Provider is a popular food delivery service that specializes in delivering homemade meals or tiffin boxes to customers doorsteps.',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Tags',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Roti, Bhindi Sabji, Dal Bhat, Pulao, Khichdi',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(20),
              color: Colors.grey[200],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Contact Information',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  ListTile(
                    leading: Icon(Icons.phone),
                    title: Text(serviceProviderPhone),
                  ),
                  ListTile(
                    leading: Icon(Icons.email),
                    title: Text(serviceProviderEmail),
                  ),
                  ListTile(
                    leading: Icon(Icons.location_on),
                    title: Text(serviceProviderAddress),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      print('Error logging out: $e');
    }
  }
}
