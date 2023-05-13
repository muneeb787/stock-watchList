import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stocks/screens/main_bottom_bar.dart';
import 'package:stocks/utils.dart';
import 'signup_screen.dart';

class LoginApp extends StatelessWidget {
  const LoginApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: const MyStatefulWidget(),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  final _formkey = GlobalKey<FormState>();
  bool loading = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  void login() {
    _auth
        .signInWithEmailAndPassword(
      email: nameController.text.toString(),
      password: passwordController.text.toString(),
    )
        .then((value) {
      Future.delayed(Duration(seconds: 2)).then((_) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MainBottomBar()),
        );
        setState(() {
          loading = false;
        });

        utils().toastMessage(value.user!.email.toString());
      }).catchError((error) {
        utils().toastMessage(error.toString());
      });
    }).catchError((error) {
      utils().toastMessage(error.toString());
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'Log in',
                  style: TextStyle(fontSize: 30, color: Colors.white),
                )),
            SizedBox(
              width: 50,
            ),
            Row(
              children: <Widget>[
                Text(
                  'or',
                  style: TextStyle(color: Colors.white70),
                ),
                TextButton(
                  child: const Text(
                    'create an account',
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return MyRegister();
                        },
                      ),
                    );

                    //signup screen
                  },
                )
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: Form(
                key: _formkey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 3, color: Colors.white70),
                        ),
                        labelText: 'Name or Email',
                        labelStyle: TextStyle(color: Colors.grey),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter name or email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 3, color: Colors.white70),
                        ),
                        labelText: 'Password',
                        labelStyle: TextStyle(color: Colors.grey),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter password';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 60,
            ),
            Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ElevatedButton(
                  child: loading
                      ? CircularProgressIndicator(
                          strokeWidth: 5,
                          color: Colors.white,
                        )
                      : Text(
                          'Log In',
                          style: TextStyle(fontSize: 30),
                        ),
                  onPressed: () {
                    if (_formkey.currentState!.validate()) {
                      login();
                      setState(() {
                        loading = true;
                      });
                    }
                  },
                )),
            SizedBox(
              height: 30,
            ),
            // Container(
            //     height: 50,
            //     padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            //     child: ElevatedButton(
            //       style: ElevatedButton.styleFrom(primary: Colors.white60),
            //       child: const Text(
            //         'Sign in with Google',
            //         style: TextStyle(color: Colors.black, fontSize: 20),
            //       ),
            //       onPressed: () {
            //         _auth
            //             .signInWithProvider(GoogleAuthProvider())
            //             .then((value) {
            //           Navigator.push(
            //             context,
            //             MaterialPageRoute(
            //                 builder: (context) => MainBottomBar()),
            //           );
            //         }).catchError((error) {
            //           utils().toastMessage(error.toString());
            //         });
            //       },
            //     )),
            SizedBox(
              height: 30,
            ),
            // Container(
            //   alignment: Alignment.centerLeft,
            //   padding: const EdgeInsets.all(10),
            //   child: TextButton(
            //     onPressed: () {
            //       //forgot password screen
            //     },
            //     child: Text(
            //       'Forgotten your password?',
            //     ),
            //   ),
            // )
          ],
        ));
  }
}
