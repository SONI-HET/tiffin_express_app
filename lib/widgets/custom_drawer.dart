import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> screens = {
      'Profile': {
        'routeName': '/profile',
        'icon': const Icon(Icons.person),
      },
      'My Order': {
        'routeName': '/my-order',
        'icon': const Icon(Icons.book),
      },
      // 'Opening Hours': {
      //   'routeName': '/opening-hours',
      //   'icon': const Icon(Icons.lock_clock),
      // },
      'Logout': {
        'routeName': '/login',
        'icon': const Icon(Icons.logout_outlined),
      },
    };
    return Drawer(
      child: ListView(
        children: [
          SizedBox(
            height: 63.7,
            child: DrawerHeader(
              decoration:
                  BoxDecoration(color: Theme.of(context).colorScheme.primary),
              child: Text(
                'Tiffin Express App',
                style: Theme.of(context)
                    .textTheme
                    .headline2!
                    .copyWith(color: Colors.white),
              ),
            ),
          ),
          ...screens.entries.map((screen) {
            return ListTile(
              leading: screen.value['icon'],
              title: Text(screen.key),
              onTap: () {
                if (screen.value['routeName'] == '/login') {
                  signOutUser();
                  Navigator.pushNamed(context, '/login');
                } 
                else if (screen.value['routeName'] == '/profile') {
                  // fetchDataForCurrentUser();
                  Navigator.pushNamed(context, '/profile');
                } 
                else {
                  Navigator.pushNamed(context, screen.value['routeName']);
                }
              },
            );
          })
        ],
      ),
    );
  }

  Future<void> signOutUser() async {
    try {
      await FirebaseAuth.instance.signOut();
      // Successful logout
      print('User logged out');
    } catch (e) {
      // Handle logout error
      print('Logout error: $e');
    }
  }
  void fetchDataForCurrentUser() async {
  final User? user = FirebaseAuth.instance.currentUser;
  
  if (user != null) {
    // Assuming your Firestore collection is named "users"
    final DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('Users').doc(user.uid).get();
    
    if (userSnapshot.exists) {
      // Access user data
      final userData = userSnapshot.data() as Map<String, dynamic>;
      
      // Example: Print user's name
      print('User Name: ${userData['Name']}');
    } else {
      print('User data not found.');
    }
  } else {
    print('User is not signed in.');
  }
}
}
