import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileModel {
  String name;
  String phoneNumber;
  String status;
  //String instagram;
  String message;
  String address;
  String gender;
  int age;
  String imageURL;

  ProfileModel(
    this.name,
    this.phoneNumber,
    this.status,
    //   this.instagram = "unknown",
    this.message,
    this.address,
    this.gender,
    this.age,
    this.imageURL,
  );
}
