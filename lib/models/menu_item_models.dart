import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class MenuItem extends Equatable {
  final int id;
  final int tiffinServiceProviderId;
  final String name;
  final String category;
  final String description;
  final double price;

 MenuItem({
    required this.id,
    required this.tiffinServiceProviderId,
    required this.name,
    required this.category,
    required this.description,
    required this.price,
  });

  @override
  List<Object?> get props => [
        id,
        tiffinServiceProviderId,
        name,
        category,
        description,
        price,
      ];

  static List<MenuItem> menuItems = [
    MenuItem(
      id: 1,
      tiffinServiceProviderId: 2,
      name: 'Margherita',
      category: 'Pizza',
      description: 'Tomatoes, mozzarella, basil',
      price: 4.99,
    ),
    MenuItem(
      id: 2,
      tiffinServiceProviderId: 2,
      name: 'Pizza',
      category: 'Pizza',
      description: 'Cheese Pizza',
      price: 4.99,
    ),
    MenuItem(
      id: 3,
      tiffinServiceProviderId: 1,
      name: 'Pizza',
      category: 'Pizza',
      description: 'Marghreta Pizza',
      price: 4.99,
    ),
    MenuItem(
      id: 4,
      tiffinServiceProviderId: 2,
      name: 'Baviera',
      category: 'Pizza',
      description: 'Tomatoes, mozzarella, basil',
      price: 4.99,
    ),
    MenuItem(
      id: 5,
      tiffinServiceProviderId: 2,
      name: 'Coca Cola',
      category: 'Drink',
      description: 'A fresh drink',
      price: 1.99,
    ),
    MenuItem(
      id: 6,
      tiffinServiceProviderId: 1,
      name: 'Coca Cola',
      category: 'Drink',
      description: 'A fresh drink',
      price: 1.99,
    ),
    MenuItem(
      id: 7,
      tiffinServiceProviderId: 2,
      name: 'Coca Cola',
      category: 'Drink',
      description: 'A fresh drink',
      price: 1.99,
    ),
    MenuItem(
      id: 8,
      tiffinServiceProviderId: 2,
      name: 'Water',
      category: 'Drink',
      description: 'A fresh drink',
      price: 1.99,
    ),
    MenuItem(
      id: 9,
      tiffinServiceProviderId: 1,
      name: 'Caesar Salad',
      category: 'Salad',
      description: 'Made with fresh vegetables',
      price: 1.99,
    ),
    MenuItem(
      id: 10,
      tiffinServiceProviderId: 1,
      name: 'CheeseBurger',
      category: 'Burger',
      description: 'A burger with Cheese',
      price: 9.99,
    ),
    MenuItem(
      id: 11,
      tiffinServiceProviderId: 4,
      name: 'Chocolate Cake',
      category: 'Desser',
      description: 'A cake with chocolate',
      price: 9.99,
    )
  ];
  factory MenuItem.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return MenuItem(
      id: data['id'],
      tiffinServiceProviderId: data['tiffinServiceProviderId'],
      name: data['name'],
      category: data['category'],
      description: data['description'],
      price: data['price'] is double
          ? data['price']
          : (data['price'] as num).toDouble(),
    );
  }

}
