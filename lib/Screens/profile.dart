import 'package:beirut/ProfileMode.dart';
import 'package:beirut/Screens/login_screen.dart';
import 'package:beirut/Screens/profile_page.dart';
import 'package:beirut/Screens/search_users.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants.dart';
import 'dart:io';
import 'package:beirut/styles.dart';

class Profile extends StatefulWidget {
  static const id = '/profile';

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final fireStoreInstance = Firestore.instance;

  @override
  void initState() {
    getCurrentUserEmail();
    super.initState();
  }

  String name;
  String gender;
  int age;
  int phoneNumber;
  String message;

  File profileImg;

  final _auth = FirebaseAuth.instance;

  String userEmail;
  void getCurrentUserEmail() async {
    final user =
        await _auth.currentUser().then((value) => userEmail = value.email);
    print(userEmail);
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
              'Submitted Profiles',
              style: GoogleFonts.quicksand(
                  fontSize: 35.0,
                  color: Colors.orange,
                  fontWeight: FontWeight.w200),
            ),
          ),
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
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
                    return StreamBuilder<QuerySnapshot>(
                        stream: fireStoreInstance
                            .collection("Users")
                            .document(userEmail)
                            .collection("profiles")
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError)
                            return new Text('Error: ${snapshot.error}');
                          else if (snapshot.data.documents.length == 0)
                            return const Center(
                              child: Text(
                                "You haven't posted any profile .",
                                style: TextStyle(
                                    fontSize: 10.0, color: Colors.grey),
                              ),
                            );
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            case ConnectionState.none:
                              return Center(
                                child: Text('Create Your Profile',
                                    style: TextStyle(
                                        fontSize: 30, color: Colors.orange)),
                              );
                            default:
                              return ListView.separated(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: snapshot.data.documents.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                        padding: EdgeInsets.all(10),
                                        child: Column(
                                          children: [
                                            CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                  snapshot.data.documents[index]
                                                      .data['profile_pic_url']),
                                              radius: 40.0,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  'Name: ${snapshot.data.documents[index]['name']}',
                                                  style: GoogleFonts.quicksand(
                                                      color: Colors.black87,
                                                      fontSize: 25,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  snapshot.data.documents[index]
                                                      ['gender'],
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
                                                        text: snapshot
                                                            .data
                                                            .documents[index]
                                                                ['age']
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
                                                        text: snapshot
                                                                .data.documents[
                                                            index]['status'],
                                                        style: GoogleFonts.quicksand(
                                                            color: snapshot.data
                                                                            .documents[index]
                                                                        [
                                                                        'status'] ==
                                                                    'Safe'
                                                                ? Colors
                                                                    .lightGreen
                                                                : Colors
                                                                    .redAccent,
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
                                                    text: 'Address',
                                                    style: DefaultTextStyle.of(
                                                            context)
                                                        .style,
                                                    children: <TextSpan>[
                                                      TextSpan(
                                                        text:
                                                            '\n${snapshot.data.documents[index]['address']}',
                                                        style: GoogleFonts
                                                            .quicksand(
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
                                                            '\n${snapshot.data.documents[index]['message']}',
                                                        style: GoogleFonts
                                                            .quicksand(
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
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Icon(Icons.delete,
                                                        color: Colors.red),
                                                    GestureDetector(
                                                      onTap: () async {
                                                        BotToast.showText(
                                                            contentColor:
                                                                Colors.black54,
                                                            text:
                                                                "LOADING ... ",
                                                            textStyle: GoogleFonts
                                                                .quicksand(
                                                                    fontSize:
                                                                        20,
                                                                    color: Colors
                                                                        .white));
                                                        await Firestore.instance
                                                            .runTransaction(
                                                                (Transaction
                                                                    myTransaction) async {
                                                          await myTransaction
                                                              .delete(snapshot
                                                                  .data
                                                                  .documents[
                                                                      index]
                                                                  .reference);
                                                        });

                                                        Firestore.instance
                                                            .collection(
                                                                'User Data')
                                                            .where("name",
                                                                isEqualTo: snapshot
                                                                            .data
                                                                            .documents[
                                                                        index]
                                                                    ['name'])
                                                            .where("age",
                                                                isEqualTo: snapshot
                                                                        .data
                                                                        .documents[
                                                                    index]['age'])
                                                            .getDocuments()
                                                            .then((snapshot) {
                                                          snapshot.documents
                                                              .first.reference
                                                              .delete();
                                                          BotToast.showText(
                                                              contentColor: Colors
                                                                  .greenAccent,
                                                              text: "Done ! ",
                                                              textStyle: GoogleFonts
                                                                  .quicksand(
                                                                      fontSize:
                                                                          20,
                                                                      color: Colors
                                                                          .white));
                                                        });
                                                      },
                                                      child: Text(
                                                        'DELETE',
                                                        style: GoogleFonts
                                                            .quicksand(
                                                                color:
                                                                    Colors.red),
                                                      ),
                                                    )
                                                  ],
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
                          }
                        });
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
