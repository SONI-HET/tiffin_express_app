import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ServiceProviderMenuScreen extends StatefulWidget {
  static const String routeName = '/service-provider-menu-screen';

  static Route route() {
    return MaterialPageRoute(
      builder: (_) => ServiceProviderMenuScreen(),
      settings: RouteSettings(
        name: routeName,
      ),
    );
  }

  @override
  _ServiceProviderMenuScreenState createState() =>
      _ServiceProviderMenuScreenState();
}

class _ServiceProviderMenuScreenState extends State<ServiceProviderMenuScreen> {
  List<Map<String, dynamic>> menuItems = [];
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool isLoading = false;
  int currentItemId = 1; // Item ID counter

  @override
  void initState() {
    super.initState();
    fetchMenuItems();
  }

  Future<void> fetchMenuItems() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final serviceProviderId = user.uid;
      try {
        final querySnapshot = await _firestore
            .collection('ServiceProviders')
            .doc(serviceProviderId)
            .collection('menu')
            .get();

        List<Map<String, dynamic>> fetchedMenuItems = querySnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();

        setState(() {
          menuItems = fetchedMenuItems;
        });
      } catch (e) {
        print('Error fetching menu items: $e');
      }
    }
  }

  Future<void> _addNewItem() async {
    setState(() {
      isLoading = true;
    });

    final itemName = nameController.text;
    final itemPrice = double.tryParse(priceController.text);
    final itemCategory = categoryController.text;
    final itemDescription = descriptionController.text;

    if (itemName.isNotEmpty && itemPrice != null && itemPrice > 0) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        try {
          final serviceProviderId = user.uid;

          final newItem = {
            'itemID': currentItemId, // Assign the item ID
            'itemName': itemName,
            'price': itemPrice,
            'category': itemCategory,
            'description': itemDescription,
          };

          // Increment the item ID for the next item
          currentItemId++;

          await _firestore
              .collection('ServiceProviders')
              .doc(serviceProviderId)
              .collection('menu')
              .add(newItem);

          setState(() {
            nameController.clear();
            priceController.clear();
            categoryController.clear();
            descriptionController.clear();
          });

          // Reload menu items after adding
          await fetchMenuItems();
        } catch (e) {
          print('Error adding item to Firestore: $e');
        } finally {
          setState(() {
            isLoading = false;
          });
        }
      }
    }
  }

  void _showEditItemDialog(String? itemName, Map<String, dynamic>? itemData) {
    if (itemName != null && itemData != null) {
      String updatedName = itemName;
      String updatedPrice = itemData['price'].toString();
      String updatedCategory = itemData['category'] ?? '';
      String updatedDescription = itemData['description'] ?? '';

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Edit Item'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: updatedName,
                  onChanged: (value) {
                    updatedName = value;
                  },
                  decoration: InputDecoration(labelText: 'Item Name'),
                ),
                TextFormField(
                  initialValue: updatedPrice,
                  onChanged: (value) {
                    updatedPrice = value;
                  },
                  decoration: InputDecoration(labelText: 'Item Price'),
                ),
                TextFormField(
                  initialValue: updatedCategory,
                  onChanged: (value) {
                    updatedCategory = value;
                  },
                  decoration: InputDecoration(labelText: 'Category'),
                ),
                TextFormField(
                  initialValue: updatedDescription,
                  onChanged: (value) {
                    updatedDescription = value;
                  },
                  decoration: InputDecoration(labelText: 'Description'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  final updatedItem = {
                    'price': updatedPrice,
                    'category': updatedCategory,
                    'description': updatedDescription,
                  };
                  _updateMenuItem(updatedName, updatedItem);
                  Navigator.of(context).pop();
                },
                child: Text('Save'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _updateMenuItem(
      String? updatedName, Map<String, dynamic>? itemData) async {
    setState(() {
      isLoading = true;
    });

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final serviceProviderId = user.uid;
      try {
        final documentReference = _firestore
            .collection('ServiceProviders')
            .doc(serviceProviderId)
            .collection('menu')
            .where('itemName',
                isEqualTo: updatedName) // Find the menu item by name
            .get();

        final menuItemsSnapshot = await documentReference;

        if (menuItemsSnapshot.docs.isNotEmpty) {
          // Assuming there's only one item with the same name, you can update the first one
          final menuItemId = menuItemsSnapshot.docs[0].id;

          // Update the specific fields (category and desc) in the menu item
          await _firestore
              .collection('ServiceProviders')
              .doc(serviceProviderId)
              .collection('menu')
              .doc(menuItemId)
              .update({
            'category': itemData?['category'],
            'description': itemData?['description'],
          });

          // Reload menu items after updating
          await fetchMenuItems();
        } else {
          print('Menu item not found: $updatedName');
        }
      } catch (e) {
        print('Error updating menu item: $e');
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _deleteItem(String? itemName) async {
    if (itemName != null) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final serviceProviderId = user.uid;
        try {
          final shouldDelete = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Delete Item'),
                content: Text('Are you sure you want to delete this item?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: Text('No'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: Text('Yes'),
                  ),
                ],
              );
            },
          );

          if (shouldDelete == true) {
            await _firestore
                .collection('ServiceProviders')
                .doc(serviceProviderId)
                .collection('menu')
                .where('itemName', isEqualTo: itemName)
                .get()
                .then((querySnapshot) {
              querySnapshot.docs.forEach((doc) {
                doc.reference.delete();
              });
            });

            // Reload menu items after deleting
            await fetchMenuItems();
          }
        } catch (e) {
          print('Error deleting menu item: $e');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu Items'),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: menuItems.length,
                    itemBuilder: (context, index) {
                      final menuItemData = menuItems[index];
                      final menuItemName = menuItemData['itemName'] ?? '';
                      return ListTile(
                        title: Text(menuItemName),
                        subtitle: Text(
                            '₹${double.parse(menuItemData['price'].toString()).toStringAsFixed(2)}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                _showEditItemDialog(menuItemName, menuItemData);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                _deleteItem(menuItemName);
                              },
                            ),
                            if (isLoading)
                              Center(
                                child: CircularProgressIndicator(),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Divider(),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(labelText: 'Item Name'),
                      ),
                    ),
                    SizedBox(width: 16.0),
                    Expanded(
                      child: TextFormField(
                        controller: priceController,
                        decoration: InputDecoration(labelText: 'Item Price'),
                      ),
                    ),
                    SizedBox(width: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        _addNewItem();
                      },
                      child: Text('Add'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
