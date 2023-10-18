import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  static const String routeName = '/profile';
  static Route route() {
    return MaterialPageRoute(
        builder: (_) => ProfilePage(),
        settings: RouteSettings(
          name: routeName,
        ));
  }

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
      ),
      body: FutureBuilder(
        future: fetchProfileInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(), // Show a loading indicator
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'), // Show an error message
            );
          } else {
            final profileData = snapshot.data as Map<String, dynamic>;
            return ProfileContent(profileData: profileData);
          }
        },
      ),
    );
  }

  Future<Map<String, dynamic>> fetchProfileInfo() async {
    final User? user = _auth.currentUser;
    final Map<String, dynamic> profileData = {};

    if (user != null) {
      final DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .get();

      if (userData.exists) {
        final data = userData.data() as Map<String, dynamic>;
        profileData['profileImageUrl'] = data['ProfileImage'];
        profileData['name'] = data['Name'];
        profileData['email'] = data['Email'];
        profileData['phoneNo'] = data['PhoneNo'];
      }
    }

    return profileData;
  }
}

class ProfileContent extends StatelessWidget {
  final Map<String, dynamic> profileData;

  ProfileContent({required this.profileData});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 60,
            backgroundImage: profileData['profileImageUrl'] != null
                ? NetworkImage(profileData['profileImageUrl']!) as ImageProvider
                : AssetImage('assets/logo.png'), // You can use a placeholder image
          ),
          SizedBox(height: 20),
          ListTile(
            leading: Icon(Icons.person, size: 32),
            title: Text(profileData['name'] ?? 'Name not provided', style: TextStyle(fontSize: 20)),
          ),
          Divider(color: Colors.grey),
          ListTile(
            leading: Icon(Icons.email, size: 32),
            title: Text(profileData['email'] ?? 'Email not provided', style: TextStyle(fontSize: 20)),
          ),
          Divider(color: Colors.grey),
          ListTile(
            leading: Icon(Icons.phone, size: 32),
            title: Text(profileData['phoneNo'] ?? 'Phone number not provided', style: TextStyle(fontSize: 20)),
          ),
          Divider(color: Colors.grey),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              final result = await Navigator.pushNamed(context, '/edit-profile', arguments: {
                'name': profileData['name'],
                'phoneNo': profileData['phoneNo'],
                'profileImageUrl': profileData['profileImageUrl'],
              });

              if (result != null) {
                // Handle the result as needed
              }
            },
            child: Text('Edit Profile'),
          ),
        ],
      ),
    );
  }
}
