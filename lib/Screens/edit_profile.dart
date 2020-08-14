import 'dart:io';
import 'package:beirut/Screens/profile.dart';
import 'package:beirut/Screens/testit.dart';
import 'package:beirut/styles.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:beirut/styles.dart';
import 'package:toggle_switch/toggle_switch.dart';

class EditProfile extends StatefulWidget {
  static const id = '/edit_profile';
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String address = '';
  String status = "Safe";
  String name = '';
  String gender = "Female";
  int age = 0;
  String phoneNumber = '';
  String message = '';
  String guardianName = '';

  StorageReference storageReference;
  File profileImg;

  final _auth = FirebaseAuth.instance;
  final fireStoreInstance = Firestore.instance;

  String userEmail = "";
  void getCurrentUserEmail() async {
    final user =
        await _auth.currentUser().then((value) => userEmail = value.email);
  }

  void getCurrentData() async {
    await _auth.currentUser().then((value) => guardianName = value.displayName);
    await _auth.currentUser().then((value) => phoneNumber = value.phoneNumber);
  }

  Future _onPressed() async {
    await _auth
        .currentUser()
        .then((value) => userEmail = value.email)
        .then((_) async {
      fireStoreInstance
          .collection("Users")
          .document(userEmail)
          .collection("profiles")
          .add({
        'status': status.toString(),
        'profile_pic_url': await saveImageOnFirebaseStorage(
            name, age, profileImg.path, profileImg),
        'name': name,
        'gender': gender,
        'age': age,
        'phoneNumber': phoneNumber,
        'message': message,
        'address': address,
      }).then((_) async {
        fireStoreInstance.collection("User Data").add({
          'status': status.toString(),
          'profile_pic_url': await saveImageOnFirebaseStorage(
              name, age, profileImg.path, profileImg),
          'name': name,
          'gender': gender,
          'age': age,
          'phoneNumber': phoneNumber,
          'message': message,
          'address': address,
          'quardianName': guardianName,
        }).then((_) {
          print("success!");
        });
      });
    });
  }

  Future getImage() async {
    // ignore: deprecated_member_use
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      profileImg = image;
    });
  }

  Future<String> saveImageOnFirebaseStorage(
      String userName, int age, String imgPath, File file) async {
    var filename = userName + age.toString();
    storageReference =
        await FirebaseStorage.instance.ref().child("images/$filename.png");

    final StorageUploadTask uploadTask = storageReference.putFile(file);
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    final String url = (await downloadUrl.ref.getDownloadURL());
    print("$url");
    return url;
  }

// added//
  bool nameError = false,
      phoneNumberError = false,
      messageError = false,
      adressError = false,
      imageError = false;
  Widget textField(hintText, icon, indicator) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.80,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color: Colors.white,
      ),
      child: TextField(
        onChanged: (value) {
          setState(() {
            if (indicator == age)
              age = int.parse(value);
            else if (indicator == name) {
              name = value;
              nameError = false;
            } else if (indicator == phoneNumber) {
              phoneNumber = value;
              phoneNumberError = false;
            } else if (indicator == address) {
              address = value;
              adressError = false;
            }
          });
        },
        cursorColor: Colors.orange,
        style: GoogleFonts.cairo(fontSize: 15, color: Colors.black54),
        keyboardType: (indicator == age || indicator == phoneNumber)
            ? TextInputType.number
            : TextInputType.text,
        inputFormatters: (indicator == age || indicator == phoneNumber)
            ? <TextInputFormatter>[WhitelistingTextInputFormatter.digitsOnly]
            : null,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText,
            labelStyle: GoogleFonts.cairo(fontSize: 20, color: Colors.red),
            hintStyle: GoogleFonts.cairo(fontSize: 15, color: Colors.grey),
            contentPadding:
                EdgeInsets.only(left: 1, right: 5, bottom: 0, top: 10),
            prefixIcon: Icon(icon, color: Colors.orange.shade500)),
      ),
    );
  }

  @override
  void initState() {
    getCurrentData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Container(
            margin: EdgeInsets.only(top: 20),
            child: Text(
              'Place Search',
              style: GoogleFonts.quicksand(
                  fontSize: 35.0,
                  color: Colors.orange,
                  fontWeight: FontWeight.w200),
            ),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.orange,
            ),
            onPressed: () {
              Navigator.pushNamed(context, Bar.id);
            },
          ),
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              Align(
                child: profileImg == null
                    ? GestureDetector(
                        onTap: () {
                          getImage();
                        },
                        child: CircleAvatar(
                          radius: 55,
                          backgroundColor: Colors.orange.shade50,
                          child: Icon(
                            Icons.input,
                            color: Colors.orange,
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          getImage();
                        },
                        child: CircleAvatar(
                            radius: 55,
                            backgroundImage: Image.file(profileImg).image),
                      ),
                alignment: FractionalOffset(0.5, 0.0),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: ToggleSwitch(
                      minHeight: 40,
                      minWidth: 90,
                      cornerRadius: 50,
                      initialLabelIndex: status == 'Safe' ? 1 : 0,
                      activeBgColor:
                          status == 'Safe' ? Colors.green : Colors.red,
                      activeFgColor: Colors.white,
                      inactiveBgColor: Colors.white,
                      inactiveFgColor: Colors.grey.shade600,
                      labels: ['Emergency', 'Safe'],
                      onToggle: (index) {
                        if (index == 1) {
                          setState(() {
                            status = 'Safe';
                          });
                        } else if (index == 0) {
                          setState(() {
                            status = 'Emergency';
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 25, right: 15, top: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Name',
                        style: TextStyle(
                            color: nameError ? Colors.red : Colors.orange)),
                    SizedBox(
                      height: 10,
                    ),
                    textField(
                        'Enter Missing Person Name (6 Characters at least)',
                        Icons.person,
                        name),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Age',
                      style: kOrangeText,
                    ),
                    textField('Enter age between 1 - 90',
                        Icons.accessibility_new, age),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Gender',
                      style: kOrangeText,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: ToggleSwitch(
                        minHeight: 35,
                        minWidth: 90,
                        cornerRadius: 50,
                        initialLabelIndex: gender == 'Female' ? 0 : 1,
                        activeBgColor:
                            gender == 'Female' ? Colors.pink : Colors.blueGrey,
                        activeFgColor: Colors.white,
                        inactiveBgColor: Colors.white,
                        inactiveFgColor: Colors.grey.shade600,
                        labels: ['Female', 'Male'],
                        icons: [Icons.pregnant_woman, Icons.perm_identity],
                        onToggle: (index) {
                          if (index == 1) {
                            setState(() {
                              gender = 'Male';
                            });
                          } else if (index == 0) {
                            setState(() {
                              gender = 'Female';
                            });
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Enter your phone Number',
                      style: TextStyle(
                          color: phoneNumberError ? Colors.red : Colors.orange),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    textField('At least valid phone number',
                        Icons.phone_android, phoneNumber),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'First Seen Adress',
                      style: TextStyle(
                          color: adressError ? Colors.red : Colors.orange),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    textField('Enter Adress', Icons.location_on, address),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Message',
                      style: TextStyle(
                          color: messageError ? Colors.red : Colors.orange),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.80,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        color: Colors.white,
                      ),
                      child: TextField(
                        maxLines: 7,
                        onChanged: (value) {
                          message = value;
                        },
                        cursorColor: Colors.orange,
                        style: GoogleFonts.cairo(
                            fontSize: 15, color: Colors.black54),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Write Message (At least 10 characters)...',
                          labelStyle: GoogleFonts.cairo(
                              fontSize: 20, color: Colors.red),
                          hintStyle: GoogleFonts.cairo(
                              fontSize: 15, color: Colors.grey),
                          contentPadding: EdgeInsets.all(20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.all(Radius.circular(24)),
                      border: Border.all(color: Colors.orange.shade50)),
                  width: 100,
                  height: 35,
                  child: FlatButton(
                    onPressed: () async {
                      if (profileImg == null) {
                        BotToast.showText(
                            contentColor: Colors.redAccent,
                            text: "You didn't select image",
                            textStyle: GoogleFonts.quicksand(
                                fontSize: 20, color: Colors.white));
                        return null;
                      }
                      if (name.isEmpty ||
                          address.isEmpty ||
                          message.isEmpty ||
                          age == 0 ||
                          phoneNumber.isEmpty) {
                        BotToast.showText(
                            contentColor: Colors.redAccent,
                            text: "You left textfield empty.",
                            textStyle: GoogleFonts.quicksand(
                                fontSize: 20, color: Colors.white));
                      } else if (name.length < 6 ||
                          phoneNumber.length < 5 ||
                          address.length < 5 ||
                          message.length < 10) {
                        setState(() {
                          if (name.length < 6) nameError = true;
                          if (phoneNumber.length < 5) phoneNumberError = true;
                          if (address.length < 5) adressError = true;
                          if (message.length < 10) messageError = true;
                          BotToast.showText(
                              contentColor: Colors.redAccent,
                              text: "You didn't respect textfield's rules.",
                              textStyle: GoogleFonts.quicksand(
                                  fontSize: 20, color: Colors.white));
                        });
                        return null;
                      }
                      BotToast.showText(
                          contentColor: Colors.greenAccent,
                          text: "LOADING ...",
                          textStyle: GoogleFonts.quicksand(
                              fontSize: 20, color: Colors.white));
                      await _onPressed();
                      Navigator.pushNamed(context, Bar.id);
                      BotToast.showText(
                          contentColor: Colors.grey,
                          text: "DONE !",
                          textStyle: GoogleFonts.quicksand(
                              fontSize: 20, color: Colors.white));
                    },
                    child: Text(
                      'SAVE',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
