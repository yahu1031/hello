import 'package:beirut/Components/Responsive/size_config.dart';
import 'package:beirut/Components/Services/auth_services.dart';
import 'package:beirut/Components/Widgets/customTextfield.dart';
import 'package:beirut/Components/dialogs.dart';
import 'package:beirut/Components/dialogs.dart' as dialogs;
import 'package:google_fonts/google_fonts.dart';
import 'package:beirut/constants.dart';
import 'package:beirut/styles.dart' as style;
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  static const id = '/forgotpass';
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  String _email;
  bool _validate = false;

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final AuthServices _auth = AuthServices();

    void forgotPassword() async {
      if (formKey.currentState.validate()) {
        dialogs.showLoadingDialog(context);
        await _auth.resetPassword(_email.trim());
        Navigator.pop(context, true);
        if (_email == null) {
          Dialogs.yesAbortDialog(context, kSorry, kEmptyCredString);
        } else if (!_email.contains('@')) {
          Dialogs.yesAbortDialog(context, kSorry, kEmailDomainMissingString);
        } else {
          Dialogs.yesAbortDialog(context, kSent, kSentContent);
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
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              kForgotPass,
                              style: style.kTitle,
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
                                    forgotPassword();
                                    print('Sent');
                                  },
                                  child: Center(
                                    child: FittedBox(
                                      child: Text(
                                        kForgotPassword.toUpperCase(),
                                        style: GoogleFonts.montserrat(
                                          fontSize:
                                              4 * SizeConfig.widthMultiplier,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            kFPLogin,
                            style: GoogleFonts.montserrat(
                              fontSize: 2.5 * SizeConfig.heightMultiplier,
                              fontWeight: FontWeight.w300,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(width: 5.0),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              kLogin,
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
    print('$_email \n');
  }
}
