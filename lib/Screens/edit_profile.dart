import 'dart:io';
import 'package:beirut/Screens/testit.dart';
import 'package:beirut/styles.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:firebase_database/firebase_database.dart';

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
    await _auth.currentUser().then((value) => userEmail = value.email);
  }

  void getCurrentData() async {
    await _auth.currentUser().then((value) => guardianName = value.displayName);
    await _auth.currentUser().then((value) => phoneNumber = value.phoneNumber);
  }

  /* Future _onPressedFirst() async {
    await _auth
        .currentUser()
        .then((value) => userEmail = value.email)
        .then((_) async {
      try {
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
        });
        BotToast.showText(
            contentColor: Colors.greenAccent,
            text: "LOADING (20%)...",
            textStyle:
                GoogleFonts.quicksand(fontSize: 20, color: Colors.white));
      } catch (e) {
        BotToast.showText(
            contentColor: Colors.redAccent,
            text: "FAILED!",
            textStyle:
                GoogleFonts.quicksand(fontSize: 20, color: Colors.white));
        return null;
      }
    });
    BotToast.showText(
        contentColor: Colors.greenAccent,
        text: "LOADING ...",
        textStyle: GoogleFonts.quicksand(fontSize: 20, color: Colors.white));
    try {
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
      });
      BotToast.showText(
          contentColor: Colors.greenAccent,
          text: "LOADING (45%)...",
          textStyle: GoogleFonts.quicksand(fontSize: 20, color: Colors.white));
    } catch (e) {
      BotToast.showText(
          contentColor: Colors.redAccent,
          text: "FAILED!",
          textStyle: GoogleFonts.quicksand(fontSize: 20, color: Colors.white));

      return null;
    }
    /* Navigator.pushNamed(context, Bar.id);
    BotToast.showText(
        contentColor: Colors.grey,
        text: "DONE",
        textStyle: GoogleFonts.quicksand(fontSize: 20, color: Colors.white));*/
  }*/

  Future _onPressedSecond() async {
    try {
      await FirebaseDatabase.instance
          .reference()
          .child("User Data")
          .push()
          .set({
        'status': status.toString(),
        'profile_pic_url': await saveImageOnFirebaseStorage(
            name, age, profileImg.path, profileImg),
        'name': name,
        'gender': gender,
        'age': age,
        'phoneNumber': phoneNumber,
        'message': message,
        'address': address,
        'id': '$name-$age-$gender-$message',
      });
      BotToast.showText(
          contentColor: Colors.greenAccent,
          text: "LOADING (50%)...",
          textStyle: GoogleFonts.quicksand(fontSize: 20, color: Colors.white));
    } catch (error) {
      BotToast.showText(
          contentColor: Colors.redAccent,
          text: "FAILED !",
          textStyle: GoogleFonts.quicksand(fontSize: 20, color: Colors.white));
    }
    var firebaseUser = await FirebaseAuth.instance.currentUser();
    await _auth
        .currentUser()
        .then((value) => userEmail = value.email)
        .then((_) async {
      try {
        FirebaseDatabase.instance
            .reference()
            .child("Users")
            .child(firebaseUser.uid)
            .child("profiles")
            .push()
            .set({
          'status': status.toString(),
          'profile_pic_url': newimageUrl,
          'name': name,
          'gender': gender,
          'age': age,
          'phoneNumber': phoneNumber,
          'message': message,
          'address': address,
          'id': '$name-$age-$gender-$message',
        });
        BotToast.showText(
            contentColor: Colors.greenAccent,
            text: "LOADING (100%)...",
            textStyle:
                GoogleFonts.quicksand(fontSize: 20, color: Colors.white));
      } catch (e) {
        BotToast.showText(
            contentColor: Colors.redAccent,
            text: "FAILED!",
            textStyle:
                GoogleFonts.quicksand(fontSize: 20, color: Colors.white));
        return null;
      }
    });
    Navigator.pushNamed(context, Bar.id);
    BotToast.showText(
        contentColor: Colors.greenAccent,
        text: "DONE!",
        textStyle: GoogleFonts.quicksand(fontSize: 20, color: Colors.white));
  }

  Future getImage() async {
    // ignore: deprecated_member_use
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      profileImg = image;
    });
  }

  String newimageUrl = '';

  Future<String> saveImageOnFirebaseStorage(
      String userName, int age, String imgPath, File file) async {
    var filename = userName + age.toString();
    storageReference =
        FirebaseStorage.instance.ref().child("images/$filename.png");

    final StorageUploadTask uploadTask = storageReference.putFile(file);
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    final String url = (await downloadUrl.ref.getDownloadURL());
    newimageUrl = url;
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
        cursorColor: Color(0xFF3F51B5),
        style: GoogleFonts.cairo(fontSize: 15, color: Colors.black54),
        // keyboardType:
        // (indicator != age || indicator != phoneNumber)
        //  TextInputType.text,
        // : TextInputType.number,
        // inputFormatters: (indicator != age || indicator != phoneNumber)
        //     ? null
        //     : <TextInputFormatter>[WhitelistingTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText,
            labelStyle: GoogleFonts.cairo(fontSize: 20, color: Colors.red),
            hintStyle: GoogleFonts.cairo(fontSize: 15, color: Colors.grey),
            contentPadding:
                EdgeInsets.only(left: 1, right: 5, bottom: 0, top: 10),
            prefixIcon: Icon(icon, color: Color(0xFF3F51B5))),
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
              'Create profile',
              style: GoogleFonts.quicksand(
                  fontSize: 25.0,
                  color: Color(0xFF3F51B5),
                  fontWeight: FontWeight.w200),
            ),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Color(0xFF3F51B5),
            ),
            onPressed: () {
              Navigator.pop(context, Bar.id);
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
                          backgroundColor: Color(0xFF3F51B5).withOpacity(.5),
                          child: Icon(
                            Icons.input,
                            color: Color(0xFF3F51B5),
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
                      minWidth: 150,
                      cornerRadius: 50,
                      initialLabelIndex: status == 'Safe'
                          ? 1
                          : status == 'Hospitalized' ? 0 : 2,
                      activeBgColor: status == 'Safe'
                          ? Colors.green
                          : status == 'Hospitalized'
                              ? Colors.redAccent
                              : status == 'Confirmed Deceased'
                                  ? Colors.red.shade800
                                  : Colors.red.shade800,
                      activeFgColor: Colors.white,
                      inactiveBgColor: Colors.white,
                      inactiveFgColor: Colors.grey.shade600,
                      labels: ['Hospitalized', 'Safe', 'Confirmed Deceased'],
                      fontSize: 12,
                      onToggle: (index) {
                        if (index == 1) {
                          setState(() {
                            status = 'Safe';
                          });
                        } else if (index == 0) {
                          setState(() {
                            status = 'Hospitalized';
                          });
                        } else if (index == 2) {
                          setState(() {
                            status = 'Confirmed Deceased';
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
                            color: nameError ? Colors.red : Color(0xFF3F51B5))),
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
                          color: phoneNumberError
                              ? Colors.red
                              : Color(0xFF3F51B5)),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    textField(
                        'Valid phone number', Icons.phone_android, phoneNumber),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Last Seen Address',
                      style: TextStyle(
                          color: adressError ? Colors.red : Color(0xFF3F51B5)),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    textField('Enter Address', Icons.location_on, address),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Message',
                      style: TextStyle(
                          color: messageError ? Colors.red : Color(0xFF3F51B5)),
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
                        cursorColor: Color(0xFF3F51B5),
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
                      color: Color(0xFF3F51B5),
                      borderRadius: BorderRadius.all(Radius.circular(24)),
                      border:
                          Border.all(color: Color(0xFF3F51B5).withOpacity(.5))),
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
                          text: "LOADING...",
                          textStyle: GoogleFonts.quicksand(
                              fontSize: 20, color: Colors.white));

                      await _onPressedSecond();
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
