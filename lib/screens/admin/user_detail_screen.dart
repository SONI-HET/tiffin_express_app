import 'package:flutter/material.dart';
import 'package:tiffin_express_app/screens/admin/admin_screen.dart';

class UserDetailsScreen extends StatefulWidget {
  final String userId;
  final String Name;
  final String Email;
  final String Password;
  final String PhoneNo;
  final FirebaseService firebaseService;

  UserDetailsScreen({
    required this.userId,
    required this.Name,
    required this.Email,
    required this.Password,
    required this.PhoneNo,
    required this.firebaseService,
  });

  @override
  _UserDetailsScreenState createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  bool _isEditing = false;
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneNoController;

  late Future<void> _updateUserFuture = Future.value(); // Initialize with a completed Future

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.Name);
    _emailController = TextEditingController(text: widget.Email);
    _phoneNoController = TextEditingController(text: widget.PhoneNo);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneNoController.dispose();
    super.dispose();
  }

  void _toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  Future<void> updateUser(
      String userId, String name, String email, String phoneNo) async {
    setState(() {
      _updateUserFuture = widget.firebaseService.updateUser(
        userId,
        name,
        email,
        phoneNo,
      );
    });

    await _updateUserFuture;
    _toggleEditing();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Details'),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: _toggleEditing,
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('User ID', widget.userId),
            _buildDivider(),
            _buildEditableField('Name', _nameController),
            _buildDivider(),
            _buildEditableField('Email', _emailController),
            _buildDivider(),
            Text(
              'Password: ********', // Hide the password
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
            _buildDivider(),
            _buildEditableField('Phone Number', _phoneNoController),
          ],
        ),
      ),
      floatingActionButton: _isEditing
          ? FutureBuilder<void>(
              future: _updateUserFuture,
              builder: (context, snapshot) {
                return FloatingActionButton(
                  onPressed: () {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // Show a loading indicator
                      return null; // Return null when in loading state
                    } else {
                      // Show the check icon and update the user
                      updateUser(
                        widget.userId,
                        _nameController.text,
                        _emailController.text,
                        _phoneNoController.text,
                      );
                    }
                  },
                  child: snapshot.connectionState == ConnectionState.waiting
                      ? CircularProgressIndicator(color: Colors.white,)
                      : Icon(Icons.check),
                );
              },
            )
          : null,
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 13, 50, 172),
          ),
        ),
        SizedBox(height: 8.0),
        Text(
          value,
          style: TextStyle(
            fontSize: 18.0,
          ),
        ),
      ],
    );
  }

  Widget _buildEditableField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 13, 50, 172),
          ),
        ),
        SizedBox(height: 8.0),
        TextFormField(
          controller: controller,
          enabled: _isEditing,
          style: TextStyle(
            fontSize: 18.0,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Divider(
        height: 1.0,
        color: Colors.grey,
      ),
    );
  }
}
