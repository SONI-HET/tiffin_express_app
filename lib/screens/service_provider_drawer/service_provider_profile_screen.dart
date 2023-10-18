import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:tiffin_express_app/screens/service_provider_screen/service_provider_screen.dart';

class ProfileScreen extends StatefulWidget {
  static const String routeName = '/service-provider-profile';
  ProfileScreen({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(
      builder: (_) => ProfileScreen(),
      settings: RouteSettings(
        name: routeName,
      ),
    );
  }

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final firebase_storage.FirebaseStorage _storage =
      firebase_storage.FirebaseStorage.instance;

  String serviceProviderName = '';
  String serviceProviderEmail = '';
  String serviceProviderPhone = '';
  String serviceProviderAddress = '';
  XFile? _selectedProfileImage;
  String? _profileImageUrl;
  String profileURL =
      'https://firebasestorage.googleapis.com/v0/b/tiffin-service-provider-8bbc6.appspot.com/o/ServiceProviders%2FHe%20Soni%2Fprofile_image%2Fprofile_image_1696749526506.png?alt=media&token=3e0b9daf-fc67-4878-8fb2-71834685c04d';
  bool isLoading = true;
  bool isEditMode = false;
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController addressController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    addressController = TextEditingController();
    fetchServiceProviderData();
  }

  Future<void> fetchServiceProviderData() async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot documentSnapshot =
            await _firestore.collection('ServiceProviders').doc(user.uid).get();
        if (documentSnapshot.exists) {
          setState(() {
            serviceProviderName = documentSnapshot['name'];
            serviceProviderEmail = documentSnapshot['email'];
            serviceProviderPhone = documentSnapshot['phoneNo'];
            serviceProviderAddress = documentSnapshot['address'];

            nameController.text = serviceProviderName;
            emailController.text = serviceProviderEmail;
            phoneController.text = serviceProviderPhone;
            addressController.text = serviceProviderAddress;

            _profileImageUrl = documentSnapshot['profile_image_url'];
            profileURL = _profileImageUrl!;
            isLoading = false;
          });
        }
      } catch (e) {
        print('Error fetching data: $e');
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _pickProfileImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _selectedProfileImage = pickedImage;
      });
      await _uploadProfileImageToFirebase(_selectedProfileImage!.path);
    }
  }

  Future<void> _uploadProfileImageToFirebase(String filePath) async {
    try {
      String imageName =
          'profile_image_${DateTime.now().millisecondsSinceEpoch}.png';
      final user = _auth.currentUser;
      if (user != null) {
        final ref = _storage
            .ref()
            .child('ServiceProviders')
            .child(serviceProviderName)
            .child('profile_image')
            .child(imageName);
        await ref.putFile(File(filePath));
        final downloadURL = await ref.getDownloadURL();
        setState(() {
          _profileImageUrl = downloadURL;
        });
        await _updateProfileImageUrlInDatabase(downloadURL);
      }
    } catch (e) {
      print('Error uploading profile image: $e');
    }
  }

  Future<void> _updateProfileImageUrlInDatabase(String imageUrl) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('ServiceProviders').doc(user.uid).update({
          'profile_image_url': imageUrl,
        });
      }
    } catch (e) {
      print('Error updating profile image URL: $e');
    }
  }

  Future<void> _saveChanges() async {
    String updatedName = nameController.text;
    String updatedEmail = emailController.text;
    String updatedPhone = phoneController.text;
    String updatedAddress = addressController.text;

    try {
      final user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('ServiceProviders').doc(user.uid).update({
          'name': updatedName,
          'email': updatedEmail,
          'phoneNo': updatedPhone,
          'address': updatedAddress,
        });
        setState(() {
          serviceProviderName = updatedName;
          serviceProviderEmail = updatedEmail;
          serviceProviderPhone = updatedPhone;
          serviceProviderAddress = updatedAddress;
          isEditMode = false;
        });

        // Pass the updated data back to the previous screen
        Navigator.pop(context, {
          'name': updatedName,
          'email': updatedEmail,
          'phoneNo': updatedPhone,
          'address': updatedAddress,
        });
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ServiceProviderScreen(),
        ),
      );
    } catch (e) {
      print('Error updating profile: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Profile'),
      backgroundColor: Color.fromARGB(255, 13, 50, 172),
    ),
    body: Center(
      child: Visibility(
        visible: isLoading, // Show loading indicator when isLoading is true
        child: CircularProgressIndicator(),
        replacement: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 16.0),
              GestureDetector(
                onTap: isEditMode ? _pickProfileImage : null,
                child: Stack(
                  alignment: Alignment.center, 
                  children: [
                    CircleAvatar(
                      radius: 80.0,
                      backgroundColor: Colors.transparent,
                      backgroundImage: _profileImageUrl != null
                          ? NetworkImage(_profileImageUrl!)
                          : (_selectedProfileImage != null
                              ? FileImage(File(_selectedProfileImage!.path))
                              : NetworkImage(profileURL)
                                  as ImageProvider<Object>),
                    ),
                    if (isEditMode)
                      Positioned(
                        bottom: 0,
                        right: 10,
                        child: Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: Icon(
                            Icons.camera_alt,
                            color: Color.fromARGB(255, 13, 50, 172),
                            size: 24,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Service Provider Profile',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 16.0),
              ListTile(
                leading: Icon(Icons.person),
                title: Text(
                  'Name',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                subtitle: isEditMode
                    ? TextFormField(
                        controller: nameController,
                      )
                    : Text(
                        serviceProviderName,
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.grey[700],
                        ),
                      ),
              ),
              ListTile(
                leading: Icon(Icons.email),
                title: Text(
                  'Email',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                subtitle: isEditMode
                    ? TextFormField(
                        controller: emailController,
                      )
                    : Text(
                        serviceProviderEmail,
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.grey[700],
                        ),
                      ),
              ),
              ListTile(
                leading: Icon(Icons.phone),
                title: Text(
                  'Phone',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                subtitle: isEditMode
                    ? TextFormField(
                        controller: phoneController,
                      )
                    : Text(
                        serviceProviderPhone,
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.grey[700],
                        ),
                      ),
              ),
              ListTile(
                leading: Icon(Icons.location_on),
                title: Text(
                  'Address',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                subtitle: isEditMode
                    ? TextFormField(
                        controller: addressController,
                      )
                    : Text(
                        serviceProviderAddress,
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.grey[700],
                        ),
                      ),
              ),
              SizedBox(height: 16.0),
              isEditMode
                  ? ElevatedButton(
                      onPressed: () {
                        _saveChanges();
                      },
                      child: Text('Save Changes'),
                    )
                  : ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isEditMode = true;
                        });
                      },
                      child: Text('Edit'),
                    ),
            ],
          ),
        ),
      ),
    ),
  );
}

}
