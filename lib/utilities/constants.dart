import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';

Color secondaryColor = Color.fromRGBO(252, 155, 144,1);
Color primaryColor = Color.fromRGBO(228, 110, 96, 1);
Color secondaryTextColor = Colors.black.withAlpha(150);
final dateFormat = new DateFormat('dd-MM-yyyy hh:mm');
String baseUrl = "serene-reaches-30469.herokuapp.com";
String baseUrlTL = "tranquil-shore-67034.herokuapp.com";
final GoogleSignIn gSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/classroom.courses.readonly',
    'https://www.googleapis.com/auth/calendar.events.readonly',
  ],
);
final FirebaseAuth firebaseauth = FirebaseAuth.instance ;
class ScreenSize {
  static Size size;
}
