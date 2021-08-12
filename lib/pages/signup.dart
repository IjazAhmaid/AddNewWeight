import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'Login.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();
  var email = "";
  var password = "";
  var confirmpassword = "";
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpasswordController = TextEditingController();
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmpasswordController.dispose();
    super.dispose();
  }

  void registration() async {
    if (password == confirmpassword) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        print(userCredential);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(
            "Registerd Successfully loggin",
            style: TextStyle(fontSize: 18.0),
          ),
        ));
        Navigator.pushAndRemoveUntil(
            context,
            PageRouteBuilder(
              pageBuilder: (context, a, b) => Login(),
              transitionDuration: Duration(seconds: 0),
            ),
            (route) => false);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print("password provided is to weak");
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(
              "password provided is to weak",
              style: TextStyle(fontSize: 18.0),
            ),
          ));
        } else if (e.code == 'email already in use') {
          print("This account allready taken");
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(
              "This account allready taken",
              style: TextStyle(fontSize: 18.0),
            ),
          ));
        }
      }
    } else {
      print("passwor and confirm password doesnot match");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text(
          "passwor and confirm password doesnot match",
          style: TextStyle(fontSize: 18.0),
        ),
      ));
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
      ),
      body: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: ListView(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  child: TextFormField(
                    autofocus: false,
                    decoration: InputDecoration(
                      labelText: 'Email:',
                      labelStyle: TextStyle(fontSize: 20.0),
                      border: OutlineInputBorder(),
                      errorStyle: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 15,
                      ),
                    ),
                    controller: emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please enter Email:';
                      } else if (!value.contains('@')) {
                        return 'please enter valid Email:';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  child: TextFormField(
                    autofocus: false,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password:',
                      labelStyle: TextStyle(fontSize: 20.0),
                      border: OutlineInputBorder(),
                      errorStyle: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 15,
                      ),
                    ),
                    controller: passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please enter Password:';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  child: TextFormField(
                    autofocus: false,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password:',
                      labelStyle: TextStyle(fontSize: 20.0),
                      border: OutlineInputBorder(),
                      errorStyle: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 15,
                      ),
                    ),
                    controller: confirmpasswordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please enter confirm Password:';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 60.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                email = emailController.text;
                                password = passwordController.text;
                                confirmpassword =
                                    confirmpasswordController.text;
                              });
                              registration();
                            }
                          },
                          child: Text(
                            'SignUp',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          )),
                      /* TextButton(
                        onPressed: () => {},
                        child: Text("Forgot Password?"),
                      ) */
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      Text("All Ready have an Account?"),
                      TextButton(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, a, b) => Login(),
                                  transitionDuration: Duration(seconds: 0),
                                ),
                                (route) => false);
                          },
                          child: Text("Login"))
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }
}
