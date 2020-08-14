import 'package:beirut/ProfileMode.dart';
import 'package:beirut/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class ProfileCard extends StatelessWidget {
  ProfileCard(
      {@required this.profileName,
      this.profileGender,
      this.profileAge,
      this.profileStatue,
      this.profileMsg,
      this.profilePicture,
      this.profileNumber,
      this.showDetails,
      this.profileAddress});
  final String profileName;
  final String profileGender;
  final String profileAge;
  final String profileStatue;
  final String profileMsg;
  final String profilePicture;
  final String profileNumber;
  final bool showDetails;
  final String profileAddress;
  ProfileModel profileModel;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(profilePicture),
                        radius: 40.0,
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '$profileName',
                            style: GoogleFonts.quicksand(
                                color: Colors.black87,
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '$profileGender',
                            style: GoogleFonts.quicksand(
                                color: Colors.black87, fontSize: 18),
                          ),
                          RichText(
                            text: TextSpan(
                              text: 'Age: ',
                              style: DefaultTextStyle.of(context).style,
                              children: <TextSpan>[
                                TextSpan(
                                  text: '$profileAge',
                                  style: GoogleFonts.quicksand(
                                      color: Color(0xFF3F51B5),
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Visibility(
              visible: showDetails,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  RichText(
                    text: TextSpan(
                      text: 'Statue: ',
                      style: DefaultTextStyle.of(context).style,
                      children: <TextSpan>[
                        TextSpan(
                          text: '$profileStatue',
                          style: GoogleFonts.quicksand(
                              color: profileStatue == 'Safe'
                                  ? Colors.lightGreen
                                  : Colors.redAccent,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      text: 'Address: ',
                      style: DefaultTextStyle.of(context).style,
                      children: <TextSpan>[
                        TextSpan(
                          text: '$profileAddress',
                          style: GoogleFonts.quicksand(
                              color: Colors.orange.shade700,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: 'Message:',
                      style: DefaultTextStyle.of(context).style,
                      children: <TextSpan>[
                        TextSpan(
                          text: '\n$profileMsg',
                          style: GoogleFonts.quicksand(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.call,
                            color: Colors.greenAccent, size: 30),
                        onPressed: () {
                          UrlLauncher.launch(
                              'tel:+961 ${profileNumber.toString()}');
                        },
                      ),
                      Text(
                        'Call',
                        style: GoogleFonts.quicksand(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.green),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      IconButton(
                        icon: Icon(Icons.message,
                            color: Colors.black38, size: 30),
                        onPressed: () {
                          UrlLauncher.launch(
                              'sms:+961 ${profileNumber.toString()}');
                        },
                      ),
                      Text(
                        'Message',
                        style: GoogleFonts.quicksand(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
