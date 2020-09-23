import 'package:feedme/Animation/FadeAnimation.dart';
import 'package:feedme/model/user_model.dart';
import 'package:feedme/pages/quotes.dart';
import 'package:feedme/services/AuthMethods.dart';
import 'package:flutter/material.dart';
import 'package:feedme/widgets/widget.dart';
import 'package:feedme/helper/authentication.dart';
import 'package:feedme/services/database.dart';
import 'login.dart';
import 'package:flutter/services.dart';
import 'package:feedme/helper/helperfunctions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Register extends StatefulWidget {
  final Function toggle;
  Register(this.toggle);
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Register> {
  AuthMethods authMethods=new AuthMethods();
  DataBaseMethods dataBaseMethods=new DataBaseMethods();
  bool isloading=false;
  final formkey=GlobalKey<FormState>();
  TextEditingController _username = new TextEditingController();
  TextEditingController _password = new TextEditingController();
  TextEditingController _email = new TextEditingController();

  User newUser;

  signMeUp(){


      setState(() {isloading=true;});

      authMethods.signUpwithEmailAndPassword(_email.text, _password.text).then((value) {
        newUser = new User(email: _email.text, password: _password.text,username: _username.text);
        if(AuthMethods.found==true) {
          HelperFunctions.saveUserLoggedIN(true);
          HelperFunctions.saveUsername(_username.text);
          HelperFunctions.saveUserEmail(_email.text);
          dataBaseMethods.uploadUserInfo(newUser);
          DataBaseMethods.currentUser = newUser;
          //TODO register successfully
//          Navigator.push(context, MaterialPageRoute(builder: (context)=>AllQuotes()));
          widget.toggle();
        }
        else
        {
          showDialog(context: context,
              builder: (BuildContext context) {
                return AlertDialog(title: Text('Registered failed :( ',
                  style: TextStyle(color: Colors.deepPurple),),
                  content: Text('The username or email isn'+"'"+'t available'),
                  actions: <Widget>[
                    FlatButton(child: Text('Ok',
                      style: TextStyle(
                          color: Colors.deepPurple),),
                        onPressed: () {
                          HapticFeedback.vibrate();
                          Navigator.of(context).pop();
                        }),
                  ],);
              });
          setState(() {
            isloading=false;
          });
        }});

  }
  @override
  Widget build(BuildContext context) {
    double scheight = MediaQuery.of(context).size.height;
    double scwidth = MediaQuery.of(context).size.width;
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.white,
        body:isloading?Container(child:Center(child: CircularProgressIndicator()) ,): Container(
          child: Column(
            children: [
              Container(
                height: scheight*0.5,
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
                              "SignUp",
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
                              controller: _username,
                              decoration: textfield("Username"),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom:
                                    BorderSide(color: Colors.grey[100]))),
                            child: TextField(
                              controller: _email,
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
                    FadeAnimation(2.0, GestureDetector(onTap: (){
                      signMeUp();
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
                    SizedBox(
                      height: 10,
                    ),
                    FadeAnimation(1.5, Row(mainAxisAlignment: MainAxisAlignment.end,children: [
                      Text("Already have account? ",style: TextStyle(fontSize: 12,color: Color.fromRGBO(143, 148, 251, 1) ),),
                      GestureDetector(onTap: (){
                        widget.toggle();
                      },child: Text("SignIn Now?",style: TextStyle(fontSize: 12,color: Color.fromRGBO(143, 148, 251, 1),decoration:TextDecoration.underline))),
                    ],)),

                  ],
                ),
              )
            ],
          ),
        ));
  }
}
