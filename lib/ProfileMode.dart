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

  ProfileModel({
    this.name = "unknown",
    this.phoneNumber = "unknown",
    this.status = "unknown",
    //   this.instagram = "unknown",
    this.message = "unknown",
    this.address = "unknown",
    this.gender = "unknown",
    this.age,
    this.imageURL,
  });

  factory ProfileModel.fromFireStore(DocumentSnapshot doc) {
    Map data = doc.data;
    return ProfileModel(
      name: data['name'],
      phoneNumber: data['phoneNumber'],
      status: data['status'],
      message: data['message'],
      address: data['address'],
      gender: data['gender'],
      age: data['age'],
      imageURL: data['profile_pic_url'],
    );
  }
}
