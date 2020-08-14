import 'package:beirut/Components/Responsive/size_config.dart';
import 'package:beirut/constants.dart';
import 'package:flutter/material.dart';

///----------Orange Text Style----------///
TextStyle kOrangeText = TextStyle(color: Color(0xFF3F51B5));

///----------Title Text Style----------///

TextStyle kTitle = TextStyle(
  fontSize: 4 * SizeConfig.heightMultiplier,
  color: Color(0xFF3F51B5),
  fontWeight: FontWeight.w900,
);

///----------Input Fields decoration----------///

InputDecoration kTextField = InputDecoration(
  hintText: kEnterPassword,
  prefixIcon: Icon(
    Icons.vpn_key,
  ),
  hintStyle: TextStyle(
    color: Colors.grey,
  ),
  filled: true,
  fillColor: Colors.white70,
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(0),
    ),
    borderSide: BorderSide(
      color: Colors.black,
      width: 1,
    ),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(10.0),
    ),
    borderSide: BorderSide(
      color: Colors.black,
      width: 2,
    ),
  ),
);
