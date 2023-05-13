import 'dart:async';
import 'package:flutter/material.dart';
import 'package:stocks/services/splash_services.dart';

class SplashScreen extends StatefulWidget {
  static const String id = 'splashScreenid';
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  splashservices splashScreen = splashservices();
  void initState() {
    // TODO: implement initState
    super.initState();
    splashScreen.ishome(context);
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
              ),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: CircleAvatar(
                  backgroundImage: AssetImage('assets/A.jpg'),
                  backgroundColor: Colors.black,
                  radius: 100,
                ),
              ),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: Text(
                  'AASTOCK',
                  style: TextStyle(
                    decoration: TextDecoration.none,
                    color: Colors.white70,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: Text(
                  'International stock',
                  style: TextStyle(
                    decoration: TextDecoration.none,
                    color: Colors.white70,
                    fontSize: 30,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: Text(
                  'trading in Pakistan',
                  style: TextStyle(
                    decoration: TextDecoration.none,
                    color: Colors.white70,
                    fontSize: 30,
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
            ],
          ),
        ));
  }
}
