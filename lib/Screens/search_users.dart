import 'package:beirut/Components/Responsive/sizequery.dart';
import 'package:beirut/ProfileMode.dart';
import 'package:beirut/Screens/login_screen.dart';
import 'package:beirut/Screens/profile.dart';
import 'package:beirut/Screens/profile_page.dart';
import 'package:beirut/profile_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:beirut/Components/Services/search-timer.dart';

class SearchUserPage extends StatefulWidget {
  static const id = '/searchuser';
  @override
  _SearchUserPageState createState() => _SearchUserPageState();
}

class _SearchUserPageState extends State<SearchUserPage> {
  // List<Widget> profileList = [
  //   ProfileCard(),
  //   ProfileCard(),
  // ];
  bool _showDetails = false;
  final _auth = FirebaseAuth.instance;
  void logout() async {
    print('Signout');
    await _auth.signOut();
    Navigator.pushNamedAndRemoveUntil(context, LoginScreen.id, (_) => false);
  }

  List<ProfileModel> newList = [];
  List<ProfileModel> oldList = [];

  bool showText = false;
  void _filter(string) {
    newList = oldList
        .where((u) => (u.name.toLowerCase().contains(string.toLowerCase())))
        .toList();
  }

  Future createListofProfiles() async {
    QuerySnapshot qn =
        await Firestore.instance.collection('User Data').getDocuments();
    var docs = qn.documents;
    for (var Doc in docs) {
      oldList.add(ProfileModel.fromFireStore(Doc));
    }
    setState(() {
      newList = oldList;
    });
  }

  TextEditingController _text = TextEditingController();
  final _debouncer = Debouncer(milliseconds: 500);
  @override
  @override
  void initState() {
    createListofProfiles();
    _filter('');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Container(
          margin: EdgeInsets.only(top: 20),
          child: Text(
            'Search',
            style: GoogleFonts.quicksand(
                fontSize: 35.0,
                color: Color(0xFF3F51B5),
                fontWeight: FontWeight.w200),
          ),
        ),
      ),
      body: StreamBuilder<FirebaseUser>(
          stream: FirebaseAuth.instance.onAuthStateChanged,
          builder: (context, result) {
            if (!result.hasData) {
              return Text('');
            }
            return StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance.collection('User Data').snapshots(),
                builder: (context, snapshot) {
                  return Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              height: 50,
                              width: 220.0,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.white,
                              ),
                              child: TextField(
                                onChanged: (string) {
                                  _debouncer.run(() {
                                    setState(() {
                                      _filter(string);
                                      if (newList.isEmpty)
                                        showText = true;
                                      else
                                        showText = false;
                                    });
                                  });
                                },
                                cursorColor: Color(0xFF3F51B5),
                                style: GoogleFonts.cairo(
                                    fontSize: 15, color: Colors.black54),
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Seach by name",
                                    labelStyle: GoogleFonts.cairo(
                                        fontSize: 20, color: Colors.red),
                                    hintStyle: GoogleFonts.cairo(
                                        fontSize: 15, color: Colors.grey),
                                    contentPadding: EdgeInsets.only(
                                        left: 1, right: 5, bottom: 0, top: 10),
                                    prefixIcon: Icon(Icons.search,
                                        color:
                                            Color(0xFF3F51B5).withOpacity(.5))),
                              ),
                            ),
                            Container(
                              height: 50,
                              width: 120.0,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(10),
                                      topRight: Radius.circular(10))),
                              child: Container(
                                  margin: EdgeInsets.all(8.0),
                                  height: 50,
                                  width: 120.0,
                                  padding: EdgeInsets.all(5),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: Color(0xFF3F51B5).withOpacity(.5),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.0))),
                                  child: Icon(
                                    Icons.person_pin_circle,
                                    color: Colors.white,
                                  )),
                            ),
                          ],
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.only(top: 50),
                          child: showText ? Text('User Not Found.') : Center()),
                      Expanded(
                          child: ListView.separated(
                              separatorBuilder: (context, index) {
                                return Divider(
                                  height: 30,
                                  endIndent: 50,
                                  indent: 50,
                                );
                              },
                              physics: BouncingScrollPhysics(),
                              itemCount: newList.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  child: ProfileCard(
                                    profileName: newList[index].name,
                                    profileAge: newList[index].age.toString(),
                                    profileGender: newList[index].gender,
                                    profileStatue: newList[index].status,
                                    profileMsg: newList[index].message,
                                    profilePicture: newList[index].imageURL,
                                    profileNumber: newList[index].phoneNumber,
                                    profileAddress: newList[index].address,
                                    showDetails: _showDetails,
                                  ),
                                );
                              }))
                    ],
                  );
                });
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 80.0),
        child: FloatingActionButton(
          heroTag: "bt-3",
          onPressed: () {
            setState(() {
              if (_showDetails)
                _showDetails = false;
              else
                _showDetails = true;
            });
          },
          backgroundColor: Color(0xFF3F51B5).withOpacity(.5),
          child: Icon(Icons.info),
        ),
      ),
    );
  }
}
