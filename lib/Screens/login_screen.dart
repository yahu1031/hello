import 'package:beirut/Components/Responsive/size_config.dart';
import 'package:beirut/Components/Services/auth_services.dart';
import 'package:beirut/Components/Services/user.dart';
import 'package:beirut/Screens/signup_screen.dart';
import 'package:beirut/Components/Widgets/customTextfield.dart';
import 'package:beirut/Components/dialogs.dart';
import 'package:beirut/Components/dialogs.dart' as dialogs;
import 'package:beirut/Screens/profile.dart';
import 'package:beirut/Screens/testit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:beirut/constants.dart';
import 'package:beirut/styles.dart' as style;
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  static const id = '/Login';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _email, _password;
  bool _validate = false;

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final AuthServices _auth = AuthServices();

    void logIn() async {
      if (formKey.currentState.validate()) {
        dialogs.showLoadingDialog(context);
        final User user = await _auth.signInWithEmailAndPassword(
          _email.trim(),
          _password.trim(),
        );
        Navigator.pop(context, true);
        if ((_email == null && _password == null) ||
            _email == null ||
            _password == null) {
          Dialogs.yesAbortDialog(context, kSorry, kEmptyCredString);
        } else if (!_email.contains('@')) {
          Dialogs.yesAbortDialog(context, kSorry, kEmailDomainMissingString);
        } else if (_password.length < 6) {
          Dialogs.yesAbortDialog(
              context, kPasswordTooShortString, kPasswordTooShortExplainString);
        } else if (user == null) {
          Dialogs.yesAbortDialog(context, kSorry, kCredMismatchString);
        } else {
          Navigator.pushReplacementNamed(context, Bar.id);
        }
      }
    }

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Container(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              kWelcome,
                              style: style.kTitle,
                            ),
                            Text(
                              kHand2Hand,
                              style: style.kTitle,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 20.0),
                              child: Text(
                                kSigninToGo,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 35.0),
                        child: Form(
                          autovalidate: _validate,
                          key: formKey,
                          child: Column(
                            children: <Widget>[
                              CustomTextField(
                                onChanged: (_input) => _email = _input,
                                hint: kMail,
                                isText: false,
                                isPassword: false,
                              ),
                              SizedBox(height: 5 * SizeConfig.heightMultiplier),
                              CustomTextField(
                                onChanged: (_input) => _password = _input,
                                hint: kPassword,
                                isPassword: true,
                              ),
                              Container(
                                alignment: Alignment(1.0, 0.0),
                                padding: EdgeInsets.only(top: 15.0, left: 20.0),
                                child: InkWell(
                                  child: Text(
                                    kForgotPassword,
                                    style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFFFFA084),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 3 * SizeConfig.heightMultiplier),
                              Container(
                                height: 50.0,
                                width: 200,
                                decoration: BoxDecoration(
                                  color: Color(0xFF3F51B5),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: FlatButton(
                                  onPressed: () {
                                    logIn();
                                    print('Login');
                                  },
                                  child: Center(
                                    child: FittedBox(
                                      child: Text(
                                        kLogin.toUpperCase(),
                                        style: GoogleFonts.montserrat(
                                          fontSize:
                                              5 * SizeConfig.widthMultiplier,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 35.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            kNoAccount,
                            style: GoogleFonts.montserrat(
                              fontSize: 2.5 * SizeConfig.heightMultiplier,
                              fontWeight: FontWeight.w300,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(width: 5.0),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, SignupScreen.id);
                            },
                            child: Text(
                              kSignup,
                              style: GoogleFonts.montserrat(
                                fontSize: 2.5 * SizeConfig.heightMultiplier,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFFFFA084),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onDropChange() {}

  test() {
    print('$_email \n' + '$_password \n');
  }
}
