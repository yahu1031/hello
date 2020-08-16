import 'package:beirut/Components/dialogs.dart';
import 'package:beirut/Screens/testit.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:beirut/Components/Responsive/size_config.dart';
import 'package:beirut/Components/Widgets/customTextfield.dart';
import 'package:beirut/constants.dart';
import 'package:beirut/styles.dart' as style;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class SignupScreen extends StatefulWidget {
  static const id = '/signup';
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  String _nameController;
  String _emailController;
  String _locationController;
  String _phoneController;
  String _passwordController;
  final _firestore = Firestore.instance;

  final _auth = FirebaseAuth.instance;
  bool showProgressBar = false;

  bool emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return false;
    } else {
      return true;
    }
  }

  bool _validate = false;
  void registerUserChecker() async {
    if ((_emailController == null && _passwordController == null) ||
        _emailController == null ||
        _passwordController == null) {
      Dialogs.yesAbortDialog(context, kSorry, kEmptyCredString);
    } else if (!_emailController.contains('@')) {
      Dialogs.yesAbortDialog(context, kSorry, kEmailDomainMissingString);
    } else if (_passwordController.length < 6) {
      Dialogs.yesAbortDialog(
          context, kPasswordTooShortString, kPasswordTooShortExplainString);
    } else {
      registerUser();
    }
  }

  void registerUser() async {
    BotToast.showText(
        contentColor: Colors.grey.shade600,
        text: "LOADING ...",
        textStyle: GoogleFonts.quicksand(fontSize: 20, color: Colors.white));
    try {
      final newUser = await _auth.createUserWithEmailAndPassword(
          email: _emailController.trim(), password: _passwordController.trim());
      if (newUser != null) {
        registerUserDetails();
        Navigator.pushReplacementNamed(context, Bar.id);
        BotToast.showText(
            contentColor: Colors.green,
            text: "Welcome to Beirut Tracking App !",
            textStyle:
                GoogleFonts.quicksand(fontSize: 20, color: Colors.white));
      }
    } catch (signUpError) {
      if (signUpError is PlatformException) {
        if (signUpError.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
          Dialogs.yesAbortDialog(context, 'Error', 'Email already exists !');
        }
      }
    }
  }

  Future registerUserDetails() async {
    var firebaseUser = await FirebaseAuth.instance.currentUser();
    await FirebaseDatabase.instance
        .reference()
        .child("Users")
        .child(firebaseUser.uid)
        .child("settings")
        .set({
      "name": _nameController,
      "email": _emailController.trim(),
      "location": _locationController,
      "phoneNumber": _phoneController,
    });
    /* _firestore
        .collection("Users")
        .document(_emailController.trim())
        .collection("settings")
        .add({
      "name": _nameController,
      "email": _emailController.trim(),
      "location": _locationController,
      "phoneNumber": _phoneController,
    });*/
  }

  bool validatePassword = false;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _signupKey = GlobalKey<FormState>();

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: ModalProgressHUD(
          inAsyncCall: showProgressBar,
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 100,
                      ),
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              kCreateAcc,
                              style: style.kTitle,
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 20.0),
                              child: Text(
                                kFillDetails,
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
                          key: _signupKey,
                          child: Column(
                            children: <Widget>[
                              CustomTextField(
                                onChanged: (_input) => _nameController = _input,
                                hint: kName,
                                isPassword: false,
                                isText: true,
                              ),
                              SizedBox(height: 5 * SizeConfig.heightMultiplier),
                              CustomTextField(
                                onChanged: (_input) =>
                                    _emailController = _input,
                                hint: kMail,
                                isPassword: false,
                              ),
                              SizedBox(height: 5 * SizeConfig.heightMultiplier),
                              CustomTextField(
                                onChanged: (_input) =>
                                    _locationController = _input,
                                hint: kLocation,
                                isPassword: false,
                                isText: true,
                              ),
                              SizedBox(height: 5 * SizeConfig.heightMultiplier),
                              CustomTextField(
                                onChanged: (_input) =>
                                    _phoneController = _input,
                                hint: kPhone,
                                isPassword: false,
                                onDigit: true,
                              ),
                              SizedBox(height: 5 * SizeConfig.heightMultiplier),
                              CustomTextField(
                                onChanged: (_input) =>
                                    _passwordController = _input,
                                hint: kPassword,
                                isPassword: true,
                                isText: true,
                                validatePassword: validatePassword,
                              ),
                              SizedBox(height: 5 * SizeConfig.heightMultiplier),
                              Container(
                                height: 50.0,
                                width: 200,
                                decoration: BoxDecoration(
                                  color: Color(0xFF3F51B5),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: FlatButton(
                                  onPressed: () {
                                    // if (_passwordController.length > 7) {
                                    //   setState(() {
                                    //     validatePassword = true;
                                    //   });
                                    // } else if (!emailValidator(
                                    //     _emailController)) {
                                    //   _emailController = "Invalid email";
                                    // } else {
                                    //   registerUser();
                                    // }
                                    registerUserChecker();
                                  },
                                  child: Center(
                                    child: FittedBox(
                                      child: Text(
                                        kSignup.toUpperCase(),
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
                              SizedBox(height: 25.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    kHaveAcc,
                                    style: GoogleFonts.montserrat(
                                      fontSize:
                                          2.5 * SizeConfig.heightMultiplier,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(width: 5.0),
                                  InkWell(
                                    onTap: () => Navigator.pop(context),
                                    child: Text(
                                      kLogin,
                                      style: GoogleFonts.montserrat(
                                        fontSize:
                                            2.5 * SizeConfig.heightMultiplier,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFFFFA084),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: 200.0),
                            ],
                          ),
                        ),
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

  void signup() {
    print('$_emailController \n' +
        '$_passwordController \n' +
        '$_nameController \n' +
        '$_phoneController \n' +
        '$_locationController \n');
  }
}
