import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'category_model.dart';
import 'place_model.dart';

// import 'menu_item_model.dart';
import 'menu_item_models.dart';

class ServiceProvider extends Equatable {
  final String id;
  final String name;
  final String imageUrl;
  final List<String> tags;
  final List<MenuItem> menuItems;
  final int deliveryTime;
  final String priceCategory;
  final double deliveryFee;
  final double distance;

  ServiceProvider({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.tags,
    required this.menuItems,
    required this.deliveryTime,
    required this.priceCategory,
    required this.deliveryFee,
    required this.distance,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        imageUrl,
        tags,
        deliveryTime,
        priceCategory,
        deliveryFee,
        distance,
      ];

  static List<ServiceProvider> serviceProvider = [
    ServiceProvider(
      id: '1',
      name:
          'Roti, Bhindi sabji, Dal Bhat, Potato Sabji, Buttermilk, and Many More...',
      imageUrl: 'assets/tiffin_service-1.jpeg',
      tags: MenuItem.menuItems
          .where((menuItems) => menuItems.tiffinServiceProviderId == 1)
          .map((menuItems) => menuItems.category)
          .toSet()
          .toList(),
      menuItems: MenuItem.menuItems
          .where((menuItems) => menuItems.tiffinServiceProviderId == 1)
          .toList(),
      deliveryTime: 30,
      priceCategory: '\u20B9',
      deliveryFee: 10,
      distance: 0.2,
    ),
    ServiceProvider(
      id: '2',
      name:
          'Roti, Bataka Pauha, Dal Bhat, Panner Sabji, Mango Juice, and Many More...',
      imageUrl: 'assets/tiffin_service-2.png',
      tags: MenuItem.menuItems
          .where((menuItems) => menuItems.tiffinServiceProviderId == 2)
          .map((menuItems) => menuItems.category)
          .toSet()
          .toList(),
      menuItems: MenuItem.menuItems
          .where((menuItems) => menuItems.tiffinServiceProviderId == 2)
          .toList(),
      deliveryTime: 40,
      priceCategory: '\u20B9',
      deliveryFee: 15,
      distance: 0.1,
    ),
    ServiceProvider(
      id: '3',
      name: 'Khichdi , Kadhi, Potato Sabji, Buttermilk, and Many More...',
      imageUrl: 'assets/tiffin_service-3.jpeg',
      tags: MenuItem.menuItems
          .where((menuItems) => menuItems.tiffinServiceProviderId == 3)
          .map((menuItems) => menuItems.category)
          .toSet()
          .toList(),
      menuItems: MenuItem.menuItems
          .where((menuItems) => menuItems.tiffinServiceProviderId == 3)
          .toList(),
      deliveryTime: 15,
      priceCategory: '\u20B9',
      deliveryFee: 9,
      distance: 0.8,
    ),
    ServiceProvider(
      id: '4',
      name: 'Pav Bhaji, Simple Pulao, Onion, and Many More...',
      imageUrl: 'assets/tiffin_service-4.png',
      tags: MenuItem.menuItems
          .where((menuItems) => menuItems.tiffinServiceProviderId == 4)
          .map((menuItems) => menuItems.category)
          .toSet()
          .toList(),
      menuItems: MenuItem.menuItems
          .where((menuItems) => menuItems.tiffinServiceProviderId == 4)
          .toList(),
      deliveryTime: 60,
      priceCategory: '\u20B9',
      deliveryFee: 30,
      distance: 0.9,
    ),
    ServiceProvider(
      id: '5',
      name: 'Marghreta Pizza, Simple Pizza, Cheese Pizza, and Many More...',
      imageUrl: 'assets/tiffin_service-5.jpg',
      tags: MenuItem.menuItems
          .where((menuItems) => menuItems.tiffinServiceProviderId == 5)
          .map((menuItems) => menuItems.category)
          .toSet()
          .toList(),
      menuItems: MenuItem.menuItems
          .where((menuItems) => menuItems.tiffinServiceProviderId == 5)
          .toList(),
      deliveryTime: 60,
      priceCategory: '\u20B9',
      deliveryFee: 30,
      distance: 0.9,
    ),
  ];
}
