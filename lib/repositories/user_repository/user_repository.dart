import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiffin_express_app/models/user_model.dart';

abstract class UserRepository implements GetxController {
  static UserRepository get instance => Get.find();
  final _db = FirebaseFirestore.instance;
  createUser(UserModel user) async {
   await _db
        .collection("Users")
        .add(user.toJson())
        .whenComplete(
          () => Get.snackbar("Success", "Your account has been created",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.blue.withOpacity(0.1),
              colorText: Colors.blue),
        )
        .catchError((error, stackTrace) {
      Get.snackbar("Error", "Something Went Wrong. Try Again Later!!!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.1),
          colorText: Colors.red);
      print(error.toString());
    });
  }
}
