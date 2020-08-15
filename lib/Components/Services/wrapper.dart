import 'package:beirut/Components/Services/user.dart';
import 'package:beirut/Screens/login_screen.dart';
import 'package:beirut/Screens/testit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class Wrapper extends StatelessWidget {
  static const id = '/';

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    //Return to home or Authentication Widget
    if (user == null) {
      return LoginScreen();
    } else {
      return Bar();
    }
  }
}
