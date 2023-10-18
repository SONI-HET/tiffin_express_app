import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Categoryyy extends Equatable {
  final int id;
  final String name;
  // final String description;
  final Image image;
  // final int index;

  Categoryyy({
    required this.id,
    required this.name,
    // required this.description,
    required this.image,
    // required this.index,
  });

  @override
  List<Object?> get props => [id, name, image];

  // factory Categoryyy.fromSnapshot(Map<String, dynamic> snap) {
  //   return Categoryy(
  //     id: snap['id'].toString(),
  //     name: snap['name'],
  //     description: snap['description'],
  //     image: snap['image'],
  //     index: snap['index'],
  //   );
  // }

  static List<Categoryyy> categories = [
    Categoryyy(
      id: 1,
      name: 'Butter Roti',
      // description: 'Differnent types of roti\'s are availabale',
      image: Image.asset('assets/roti.png'),
      // index: 0,
    ),
    Categoryyy(
      id: 2,
      name: 'Sabji',
      // description: 'Differnent types of pizza\'s are availabale',
      image: Image.asset('assets/bhindi_sabji.png'),
      // index: 1,
    ),
    Categoryyy(
      id: 3,
      name: 'Dal Bhat',
      // description: 'Differnent types of pulao\'s are availabale',
      image: Image.asset('assets/rice_dal.png'),
      // index: 2,
    ),
    Categoryyy(
      id: 4,
      name: 'Chass',
      // description: 'Differnent types of juice\'s are availabale',
      image: Image.asset('assets/buttermilk.png'),
      // index: 3,
    ),
    Categoryyy(
      id: 5,
      name: 'Sabji',
      // description: 'Differnent types of salad\'s are availabale',
      image: Image.asset('assets/potato_sabji.png'),
      // index: 4,
    ),
  ];
}
