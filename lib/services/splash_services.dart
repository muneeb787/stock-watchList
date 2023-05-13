import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import '../screens/login_screen.dart';
import '../screens/main_bottom_bar.dart';

class splashservices {
  void ishome(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final User = auth.currentUser;
    if (User != null) {
      Timer(
          const Duration(seconds: 3),
          () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => MainBottomBar())));
    } else {
      Timer(
          const Duration(seconds: 3),
          () => Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => LoginApp())));
    }
  }
}
