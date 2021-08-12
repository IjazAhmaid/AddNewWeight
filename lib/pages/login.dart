import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:weighttrackerapp/pages/signup.dart';
import 'package:weighttrackerapp/pages/weighttracker.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  var email = "";
  var password = "";

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  userLogin() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      Navigator.pushAndRemoveUntil(
          context,
          PageRouteBuilder(
            pageBuilder: (context, a, b) => WeightTracker(),
            transitionDuration: Duration(seconds: 0),
          ),
          (route) => false);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print("No user Found for that Email");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(
              "user not found",
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        );
      } else if (e.code == 'worng-password') {
        print('wrong password');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(
            "wrong password",
            style: TextStyle(fontSize: 18.0),
          ),
        ));
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Login"),
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
                  margin: EdgeInsets.only(left: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                email = emailController.text;
                                password = passwordController.text;
                              });
                              userLogin();
                            }
                          },
                          child: Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          )),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      Text("Don't have an Account?"),
                      TextButton(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, a, b) => Signup(),
                                  transitionDuration: Duration(seconds: 0),
                                ),
                                (route) => false);
                          },
                          child: Text("SignUp"))
                    ],
                  ),
                ),
                /*FlatButton(
                    onPressed: () => NotificationApi.showNotification(
                          title: 'ijaz',
                          body: 'hy how are you',
                          payload: 'asddf',
                        ),
                    child: Text("show notification")) */
              ],
            ),
          )),
    );
  }
}
