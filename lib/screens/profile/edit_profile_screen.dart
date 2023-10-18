import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EditProfilePage extends StatefulWidget {
  static const String routeName = '/edit-profile';

  static Route route() {
    return MaterialPageRoute(
      builder: (_) => EditProfilePage(),
      settings: RouteSettings(
        name: routeName,
      ),
    );
  }

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  bool _isEditing = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ImagePicker _imagePicker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;

  String? profileImageUrl;
  bool _isUpdating = false;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    fetchProfileImage();
    fetchProfileInfo();
  }

  void fetchProfileInfo() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      final DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .get();
      final data = userData.data() as Map<String, dynamic>;

      setState(() {
        _nameController.text = data['Name'] ?? '';
        _phoneNumberController.text = data['PhoneNo'] ?? '';
        _passwordController.text = ''; // You may want to set this to the user's password if you wish to display it
        _addressController.text = data['Address'] ?? '';
      });
    }
  }

  void fetchProfileImage() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      final DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .get();
      final data = userData.data() as Map<String, dynamic>;

      setState(() {
        profileImageUrl = data['ProfileImage'];
      });
    }
  }

  Future<void> changeProfilePicture() async {
    final XFile? pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _isUploading = true;
      });

      final Reference storageReference = _storage.ref().child('profile_images/${_auth.currentUser!.uid}');
      final TaskSnapshot uploadTask = await storageReference.putFile(File(pickedFile.path));
      final String imageUrl = await storageReference.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('Users')
          .doc(_auth.currentUser!.uid)
          .update({'ProfileImage': imageUrl});

      setState(() {
        profileImageUrl = imageUrl;
        _isUploading = false;
      });
    }
  }

  Future<void> _updateProfile() async {
    if (_isUpdating) return; // Don't allow multiple updates

    setState(() {
      _isUpdating = true;
    });

    final User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      try {
        await FirebaseFirestore.instance.collection('Users').doc(currentUser.uid).update({
          'Name': _nameController.text,
          'PhoneNo': _phoneNumberController.text,
          // 'Password': _passwordController.text, // You should not update the password like this
          'Address': _addressController.text,
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Profile updated successfully.'),
        ));

        // Return the updated data to the previous screen and pop the current screen
        Navigator.pop(context, {
          'name': _nameController.text,
          'phoneNo': _phoneNumberController.text,
          'profileImageUrl': profileImageUrl,
        });
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to update profile: $error'),
        ));
      }

      setState(() {
        _isUpdating = false;
        _isEditing = false; // Exit editing mode
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        actions: [
          IconButton(
            icon: _isEditing ? Icon(Icons.check) : Icon(Icons.edit),
            onPressed: () {
              setState(() {
                if (_isEditing) {
                  _updateProfile();
                }
                _isEditing = !_isEditing;
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Name',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  TextField(
                    controller: _nameController,
                    enabled: _isEditing,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Phone Number',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  TextField(
                    controller: _phoneNumberController,
                    enabled: _isEditing,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Password',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  TextField(
                    controller: _passwordController,
                    enabled: _isEditing,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Address',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  TextField(
                    controller: _addressController,
                    enabled: _isEditing,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Add a button to change the profile picture
                  if (_isEditing)
                    ElevatedButton(
                      onPressed: () {
                        if (!_isUploading) {
                          changeProfilePicture();
                        }
                      },
                      child: Text('Change Profile Picture'),
                    ),
                ],
              ),
            ),
          ),
          if (_isUpdating)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Dispose of the text controllers to prevent memory leaks
    _nameController.dispose();
    _phoneNumberController.dispose();
    _passwordController.dispose();
    _addressController.dispose();
    super.dispose();
  }
}
