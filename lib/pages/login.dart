import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedme/Animation/FadeAnimation.dart';
import 'package:feedme/model/user_model.dart';
import 'package:feedme/pages/quotes.dart';
import 'package:feedme/services/database.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:feedme/pages/register.dart';
import 'package:feedme/Widgets/widget.dart' as wid;
import 'package:flutter/services.dart';
import 'package:feedme/services/AuthMethods.dart';
import 'package:feedme/helper/helperfunctions.dart';
import 'package:feedme/widgets/widget.dart';

class Login extends StatefulWidget {
  final Function toggle;
  Login(this.toggle);

  @override
  _loginState createState() => _loginState();
}

class _loginState extends State<Login> {
  TextEditingController _password = new TextEditingController();
  TextEditingController _useremail = new TextEditingController();
  AuthMethods authMethods = new AuthMethods();
  DataBaseMethods dataBaseMethods = new DataBaseMethods();
  bool isloading = false;
  QuerySnapshot snapshotUserInfo;
  StreamSubscription _onUserAddedSubscribtion;
  User _currentUser;
  @override
  void initState() {
    super.initState();
  }

  signIn() {
    setState(() {
      isloading = true;
    });
    _onUserAddedSubscribtion = FirebaseDatabase.instance
        .reference()
        .child('user')
        .onChildAdded
        .listen(onUserAdded);

    if (_currentUser != null) {
      authMethods
          .signInWithEmailAndPassword(_useremail.text.trim(), _password.text)
          .then((value) {
        if (value != null) {
          // TODO login success
          HelperFunctions.saveUserEmail(_useremail.text.trim());
          HelperFunctions.saveUserLoggedIN(true);
          HelperFunctions.saveUsername(_currentUser.username.trim());
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AllQuotes()));
        } else {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(
                    'Login failed :( ',
                    style: TextStyle(color: Colors.deepPurple),
                  ),
                  content:
                      Text('The username or password isn' + "'" + 't correct'),
                  actions: <Widget>[
                    FlatButton(
                        child: Text(
                          'Ok',
                          style: TextStyle(color: Colors.deepPurple),
                        ),
                        onPressed: () {
                          HapticFeedback.vibrate();
                          Navigator.of(context).pop();
                        }),
                  ],
                );
              });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double scheight = MediaQuery.of(context).size.height;
    double scwidth = MediaQuery.of(context).size.width;
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.white,
        body: Container(
          child: Column(
            children: [
              Container(
                height: scheight*0.35,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/background.png"),
                        fit: BoxFit.fill)),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      left: 30,
                      width: 80,
                      height: 200,
                      child:FadeAnimation(1.0, Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/light-1.png'))),
                      )),
                    ),
                    Positioned(
                      left: 140,
                      width: 80,
                      height: 150,
                      child:FadeAnimation(1.3,Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/light-2.png'))),
                      )),
                    ),
                    Positioned(
                      right: 40,
                      width: 80,
                      height: 150,
                      child:FadeAnimation(1.5, Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/clock.png'))),
                      )),
                    ),
                    Positioned(
                      child:FadeAnimation(1.6, Container(
                          margin: EdgeInsets.only(top: 50),
                          child: Center(
                            child: Text(
                              "Login",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold),
                            ),
                          ))),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(30.0),
                child: Column(
                  children: [
                FadeAnimation(1.8, Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                color: Color.fromRGBO(143, 148, 251, .2),
                                blurRadius: 20.0,
                                offset: Offset(0, 10))
                          ]),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom:
                                        BorderSide(color: Colors.grey[100]))),
                            child: TextField(
                              controller: _useremail,
                              decoration: textfield("Email"),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(8.0),
                            child: TextField(
                              obscureText: true,
                              controller: _password,
                              decoration: textfield("Password"),
                            ),
                          ),
                        ],
                      ),
                    )),
                    SizedBox(
                      height: 30,
                    ),
                FadeAnimation(2.0, GestureDetector(onTap: (){signIn();
                Navigator.push(context, MaterialPageRoute(builder:(context)=>AllQuotes()));},
                  child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                          Color.fromRGBO(143, 148, 251, 1),
                          Color.fromRGBO(143, 148, 251, .6),
                        ])),
                        child: Center(
                          child: Text(
                            "Login",
                            style: TextStyle(
                                color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                )),
                    SizedBox(
                      height: 10,
                    ),
                Row(mainAxisAlignment: MainAxisAlignment.end,children: [
                  FadeAnimation(1.5, Text("Forgot Password?",style: TextStyle(fontSize: 12,color: Color.fromRGBO(143, 148, 251, 1) ),)),
                ],),
                SizedBox(
                      height: scheight*1/50,
                    ),
                    FadeAnimation(2.0, GestureDetector(onTap: (){
                      widget.toggle();
                    },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              Color.fromRGBO(143, 148, 251, 1),
                              Color.fromRGBO(143, 148, 251, .6),
                            ])),
                        child: Center(
                          child: Text(
                            "SignUp",
                            style: TextStyle(
                                color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    )),

                  ],
                ),
              )
            ],
          ),
        ));
  }

  void onUserAdded(Event event) {
    setState(() {
      if (event.snapshot.value['email'] == _useremail.text) {
        _currentUser = new User.fromSnapShot(event.snapshot);
        DataBaseMethods.currentUser = _currentUser;
      }
    });
  }
}
