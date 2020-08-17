import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:beirut/Components/Services/auth_services.dart';
import 'package:beirut/Screens/login_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends StatefulWidget {
  static const id = '/profilepage';

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String userName;
  String userLocation;
  String userphoneNumber;

  final firestore = Firestore.instance;
  String userEmail;
  final _auth = FirebaseAuth.instance;
  void getCurrentUserEmail() async {
    await _auth.currentUser().then((value) => userEmail = value.email);
    print(userEmail);
  }

  bool showText = false, showIndicator = false;
  void getData() async {
    getCurrentUserEmail();
    showIndicator = true;
    var firebaseUser = await FirebaseAuth.instance.currentUser();
    DatabaseReference ref = FirebaseDatabase.instance
        .reference()
        .child("Users")
        .child(firebaseUser.uid)
        .child("settings");
    ref.once().then((DataSnapshot snapshot) {
      var data = snapshot.value;
      setState(() {
        userName = data['name'];
        userphoneNumber = data['phoneNumber'];
        userLocation = data['location'];
      });
      showIndicator = false;
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final AuthServices _auth = AuthServices();
    void logout() async {
      print('Signout');
      await _auth.signOut();
      Navigator.pushNamedAndRemoveUntil(context, LoginScreen.id, (_) => false);
    }

    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 90),
        child: FloatingActionButton.extended(
          heroTag: "bt-1",
          onPressed: () {
            logout();
          },
          backgroundColor: Color(0xFF3F51B5).withOpacity(.5),
          label: Text('Logout'),
          icon: Icon(Icons.exit_to_app),
        ),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Container(
          margin: EdgeInsets.only(top: 20),
          child: Text(
            'Profile',
            style: GoogleFonts.quicksand(
                fontSize: 35.0,
                color: Color(0xFF3F51B5),
                fontWeight: FontWeight.w200),
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: ListView(
          children: <Widget>[
            StreamBuilder(
                stream: FirebaseAuth.instance.onAuthStateChanged,
                builder: (context, result) {
                  if (!result.hasData) {
                    return Text('No data');
                  }
                  return showIndicator
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            CircularProgressIndicator(),
                          ],
                        )
                      : Column(
                          children: <Widget>[
                            SizedBox(
                              height: 80,
                            ),
                            CircleAvatar(
                              backgroundColor: Colors.grey.shade300,
                              radius: 80,
                              child: Image.asset(
                                'images/user.png',
                                height: 100,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              userName,
                              style: GoogleFonts.quicksand(
                                  fontWeight: FontWeight.bold, fontSize: 30),
                            ),
                            Text(
                              userEmail,
                              style: GoogleFonts.quicksand(
                                  fontWeight: FontWeight.w300, fontSize: 20),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              margin: EdgeInsets.all(30),
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.location_on,
                                    color: Color(0xFF3F51B5),
                                    size: 20,
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    userLocation,
                                    style: GoogleFonts.quicksand(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.all(30),
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.phone_android,
                                    color: Color(0xFF3F51B5),
                                    size: 30,
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    userphoneNumber,
                                    style: GoogleFonts.quicksand(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 20),
                                  ),
                                ],
                              ),
                            )
                          ],
                        );
                }),
          ],
        ),
      ),
    );
  }
}
