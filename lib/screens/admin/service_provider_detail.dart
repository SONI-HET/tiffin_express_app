import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firebase Firestore

class ServiceProviderDetailsScreen extends StatefulWidget {
  final String serviceProviderId;
  final String name;
  final String email;
  final String serviceDetails;
  final String tiffinServiceName;
  final String info;
  final String phoneNo;

  ServiceProviderDetailsScreen({
    required this.serviceProviderId,
    required this.name,
    required this.email,
    required this.phoneNo,
    required this.info,
    required this.tiffinServiceName,
    required this.serviceDetails,
  });

  @override
  _ServiceProviderDetailsScreenState createState() =>
      _ServiceProviderDetailsScreenState();
}

class _ServiceProviderDetailsScreenState
    extends State<ServiceProviderDetailsScreen> {
  bool _isEditing = false;
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneNoController;
  late TextEditingController _infoController;
  late TextEditingController _tiffinServiceNameController;
  late TextEditingController _serviceDetailsController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _emailController = TextEditingController(text: widget.email);
    _phoneNoController = TextEditingController(text: widget.phoneNo);
    _infoController = TextEditingController(text: widget.info);
    _tiffinServiceNameController =
        TextEditingController(text: widget.tiffinServiceName);
    _serviceDetailsController =
        TextEditingController(text: widget.serviceDetails);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneNoController.dispose();
    _infoController.dispose();
    _tiffinServiceNameController.dispose();
    _serviceDetailsController.dispose();
    super.dispose();
  }

  void _toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  Future<void> _updateServiceProvider() async {
    if (_isEditing) {
      // Update Firebase Firestore
      try {
        await FirebaseFirestore.instance
            .collection('ServiceProviders')
            .doc(widget.serviceProviderId)
            .update({
          'name': _nameController.text,
          'email': _emailController.text,
          'phoneNo': _phoneNoController.text,
          'info': _infoController.text,
          'tiffinServiceName': _tiffinServiceNameController.text,
          'serviceDetails': _serviceDetailsController.text,
        });
      } catch (e) {
        print('Error updating service provider: $e');
        // Handle the error, e.g., show an error message to the user.
      }

      // After updating, exit edit mode
      _toggleEditing();
    } else {
      _toggleEditing();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Service Provider Details'),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: _toggleEditing,
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Service Provider ID', widget.serviceProviderId),
              _buildDivider(),
              _buildEditableField('User Name', _nameController),
              _buildDivider(),
              _buildEditableField('Tiffin Service Name', _tiffinServiceNameController),
              _buildDivider(),
              _buildEditableField('Email', _emailController),
              _buildDivider(),
              _buildEditableField('Phone No', _phoneNoController),
              _buildDivider(),
              _buildEditableField('Information', _infoController),
              _buildDivider(),
              _buildEditableField('Service Details', _serviceDetailsController),
            ],
          ),
        ),
      ),
      floatingActionButton: _isEditing
          ? FloatingActionButton(
              onPressed: _updateServiceProvider,
              child: Icon(Icons.check),
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
