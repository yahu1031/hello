import 'package:beirut/ProfileMode.dart';
import 'package:beirut/Screens/testit.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';

class Profile extends StatefulWidget {
  static const id = '/profile';

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final fireStoreInstance = Firestore.instance;

  @override
  void initState() {
    //getUid();
    getData();
    super.initState();
  }

  String name;
  String gender;
  int age;
  int phoneNumber;
  String message;

  File profileImg;
  Future deleteItem(index) async {
    try {
      await FirebaseDatabase.instance
          .reference()
          .child('User Data')
          .orderByChild('name')
          .equalTo(dataList[index].name)
          .once()
          .then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> children = snapshot.value;
        children.forEach((key, value) async {
          await FirebaseDatabase.instance
              .reference()
              .child('User Data')
              .child(key)
              .remove();
        });
      });
    } catch (e) {
      BotToast.showText(
          contentColor: Colors.redAccent,
          text: "ERROR ! \n $e",
          textStyle: GoogleFonts.quicksand(fontSize: 20, color: Colors.white));
    }
    var firebaseUser = await FirebaseAuth.instance.currentUser();
    try {
      await FirebaseDatabase.instance
          .reference()
          .child("Users")
          .child(firebaseUser.uid)
          .child("profiles")
          .orderByChild('name')
          .equalTo(dataList[index].name)
          .onChildAdded
          .listen((Event event) async {
        await FirebaseDatabase.instance
            .reference()
            .child("Users")
            .child(firebaseUser.uid)
            .child("profiles")
            .child(event.snapshot.key)
            .remove();
      }, onError: (Object o) {
        final DatabaseError error = o;
        print('Error: ${error.code} ${error.message}');
      });
    } catch (e) {
      BotToast.showText(
          contentColor: Colors.redAccent,
          text: "ERROR ! \n $e",
          textStyle: GoogleFonts.quicksand(fontSize: 20, color: Colors.white));
    }
    Future.delayed(Duration(seconds: 1));
    BotToast.showText(
        contentColor: Colors.lightGreen,
        text: "DONE !",
        textStyle: GoogleFonts.quicksand(fontSize: 20, color: Colors.white));
  }

  final _auth = FirebaseAuth.instance;
  String userEmail;
  void getCurrentUserEmail() async {
    final user =
        await _auth.currentUser().then((value) => userEmail = value.email);
    print(userEmail);
  }

  bool showText = false, showIndicator = false;
  List<ProfileModel> dataList = [];
  void getData() async {
    showIndicator = true;
    getCurrentUserEmail();
    var firebaseUser = await FirebaseAuth.instance.currentUser();
    DatabaseReference ref = FirebaseDatabase.instance
        .reference()
        .child("Users")
        .child(firebaseUser.uid)
        .child("profiles");
    dataList.clear();
    ref.once().then((DataSnapshot snapshot) {
      var data = snapshot.value;
      if (snapshot.value == null) {
        setState(() {
          showIndicator = false;
          showText = true;
        });
      } else
        for (var key in snapshot.value.keys) {
          setState(() {
            dataList.add(ProfileModel(
              data[key]['name'],
              data[key]['phoneNumber'],
              data[key]['status'],
              data[key]['message'],
              data[key]['address'],
              data[key]['gender'],
              data[key]['age'],
              data[key]['profile_pic_url'],
            ));
          });
        }
      showIndicator = false;
    });
    setState(() {
      print(dataList.toString());
    });
  }

  /*List <ProfileModel>profilsList = [];
  Future createListofProfiles() async {
    QuerySnapshot qn =
    await Firestore.instance.collection('User Data').getDocuments();
    var docs = qn.documents;
    for (var Doc in docs) {
    for (var Doc in docs) {
      profilsList.add(ProfileModel.fromFireStore(Doc));
    }
  }*/
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Container(
            margin: EdgeInsets.only(top: 20),
            child: Text(
              'All Profiles',
              style: GoogleFonts.quicksand(
                  fontSize: 28.0,
                  color: Color(0xFF3F51B5),
                  fontWeight: FontWeight.w200),
            ),
          ),
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Divider(
                height: 20,
                endIndent: 50,
                indent: 50,
                thickness: 0.2,
              ),
              StreamBuilder(
                  stream: FirebaseAuth.instance.onAuthStateChanged,
                  builder: (context, result) {
                    if (!result.hasData) {
                      return Text('');
                    }
                    return showIndicator
                        ? CircularProgressIndicator()
                        : showText
                            ? Center(
                                child: Text(
                                  "You haven't posted any profile . \nSo, Dear user/volunteer click below to add profiles",
                                  style: TextStyle(
                                      fontSize: 15.0, color: Colors.grey),
                                ),
                              )
                            : ListView.separated(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: dataList.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                      padding: EdgeInsets.all(10),
                                      child: Column(
                                        children: [
                                          CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                dataList[index].imageURL),
                                            radius: 40.0,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                'Name: ${dataList[index].name}',
                                                style: GoogleFonts.quicksand(
                                                    color: Colors.black87,
                                                    fontSize: 25,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                dataList[index].gender,
                                                style: GoogleFonts.quicksand(
                                                    color: Colors.black87,
                                                    fontSize: 18),
                                              ),
                                              RichText(
                                                text: TextSpan(
                                                  text: 'Age: ',
                                                  style: DefaultTextStyle.of(
                                                          context)
                                                      .style,
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                      text: dataList[index]
                                                          .age
                                                          .toString(),
                                                      style: GoogleFonts
                                                          .quicksand(
                                                              color: Colors
                                                                  .orangeAccent,
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: <Widget>[
                                              RichText(
                                                text: TextSpan(
                                                  text: 'Statue: ',
                                                  style: DefaultTextStyle.of(
                                                          context)
                                                      .style,
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                      text: dataList[index]
                                                          .status,
                                                      style: GoogleFonts.quicksand(
                                                          color: dataList[index]
                                                                      .status ==
                                                                  'Safe'
                                                              ? Colors
                                                                  .lightGreen
                                                              : Colors
                                                                  .redAccent,
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              RichText(
                                                textAlign: TextAlign.center,
                                                text: TextSpan(
                                                  text: 'Address',
                                                  style: DefaultTextStyle.of(
                                                          context)
                                                      .style,
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                      text:
                                                          '\n${dataList[index].address}',
                                                      style:
                                                          GoogleFonts.quicksand(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              RichText(
                                                textAlign: TextAlign.center,
                                                text: TextSpan(
                                                  text: 'Message',
                                                  style: DefaultTextStyle.of(
                                                          context)
                                                      .style,
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                      text:
                                                          '\n${dataList[index].message}',
                                                      style:
                                                          GoogleFonts.quicksand(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 30,
                                              ),
                                              FlatButton(
                                                color: Colors.transparent,
                                                splashColor: Colors.transparent,
                                                onPressed: () async {
                                                  BotToast.showText(
                                                      contentColor:
                                                          Colors.black54,
                                                      text: "LOADING ... ",
                                                      textStyle:
                                                          GoogleFonts.quicksand(
                                                              fontSize: 20,
                                                              color: Colors
                                                                  .white));
                                                  await deleteItem(index);
                                                  setState(() {
                                                    dataList.removeAt(index);
                                                  });

                                                  print(
                                                      'lrnghhhhhh ${dataList.length}');
                                                },
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Icon(Icons.delete,
                                                        color: Colors.red),
                                                    Text(
                                                      'DELETE',
                                                      style:
                                                          GoogleFonts.quicksand(
                                                              color:
                                                                  Colors.red),
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ));
                                },
                                separatorBuilder: (context, index) {
                                  return Divider(
                                    height: 50,
                                    endIndent: 70,
                                    indent: 70,
                                  );
                                });
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
