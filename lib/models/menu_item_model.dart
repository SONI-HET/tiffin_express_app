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
  // factory MenuItem.fromMap(Map<String, dynamic> data) {
  //   final id = data['id'];
  //   final tiffinServiceProviderId = data['tiffinServiceProviderId'];
  //   final name = data['name'] as String;
  //   final category = data['category'] as String;
  //   final description = data['description'] as String;
  //   final price = data['price'] as double;
  //   return MenuItem(id: id,tiffinServiceProviderId: tiffinServiceProviderId, name: name, category: category,description: description, price: price);
  // }


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
      tiffinServiceProviderId: 1,
      name: 'Margherita',
      category: 'Pizza',
      description: 'Tomatoes, mozzarella, basil',
      price: 4.99,
    ),
    MenuItem(
      id: 2,
      tiffinServiceProviderId: 1,
      name: '4 Formaggi',
      category: 'Pizza',
      description: 'Tomatoes, mozzarella, basil',
      price: 4.99,
    ),
    MenuItem(
      id: 3,
      tiffinServiceProviderId: 1,
      name: 'Baviera',
      category: 'Pizza',
      description: 'Tomatoes, mozzarella, basil',
      price: 4.99,
    ),
    MenuItem(
      id: 4,
      tiffinServiceProviderId: 1,
      name: 'Baviera',
      category: 'Pizza',
      description: 'Tomatoes, mozzarella, basil',
      price: 4.99,
    ),
    MenuItem(
      id: 5,
      tiffinServiceProviderId: 1,
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
      tiffinServiceProviderId: 3,
      name: 'Water',
      category: 'Drink',
      description: 'A fresh drink',
      price: 1.99,
    ),
    MenuItem(
      id: 9,
      tiffinServiceProviderId: 2,
      name: 'Caesar Salad',
      category: 'Salad',
      description: 'A fresh drink',
      price: 1.99,
    ),
    MenuItem(
      id: 10,
      tiffinServiceProviderId: 3,
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
}
