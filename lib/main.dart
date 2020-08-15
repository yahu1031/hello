import 'package:beirut/Components/Responsive/size_config.dart';
import 'package:beirut/Components/Services/auth_services.dart';
import 'package:beirut/Components/Services/user.dart';
import 'package:beirut/Components/Services/wrapper.dart';
import 'package:beirut/Screens/edit_profile.dart';
import 'package:beirut/Screens/forgot_password.dart';
import 'package:beirut/Screens/login_screen.dart';
import 'package:beirut/Screens/profile.dart';
import 'package:beirut/Screens/signup_screen.dart';
import 'package:beirut/Screens/profile_page.dart';
import 'package:beirut/Screens/search_users.dart';
import 'package:beirut/Screens/testit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Screens/login_screen.dart';
import 'package:bot_toast/bot_toast.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            SizeConfig().init(constraints, orientation);
            return StreamProvider<User>.value(
              value: AuthServices().user,
              child: MaterialApp(
                builder: BotToastInit(), //1. call BotToastInit
                navigatorObservers: [BotToastNavigatorObserver()],
                debugShowCheckedModeBanner: false,
                initialRoute: Wrapper.id,
                routes: {
                  LoginScreen.id: (context) => LoginScreen(),
                  Wrapper.id: (context) => Wrapper(),
                  SignupScreen.id: (context) => SignupScreen(),
                  EditProfile.id: (context) => EditProfile(),
                  Profile.id: (context) => Profile(),
                  SearchUserPage.id: (context) => SearchUserPage(),
                  ProfilePage.id: (context) => ProfilePage(),
                  Bar.id: (context) => Bar(),
                  ForgotPassword.id: (context) => ForgotPassword(),
                },
              ),
            );
          },
        );
      },
    );
  }
}
