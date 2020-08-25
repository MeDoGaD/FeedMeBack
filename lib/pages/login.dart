import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedme/pages/quotes.dart';
import 'package:feedme/services/database.dart';
import 'package:flutter/material.dart';
import 'package:feedme/pages/register.dart';
import 'package:feedme/Widgets/widget.dart' as wid;
import 'package:flutter/services.dart';
import 'package:feedme/services/AuthMethods.dart';
import 'package:feedme/helper/helperfunctions.dart';
import 'package:feedme/widgets/widget.dart';


class Login extends StatefulWidget{
  final Function toggle;
  Login(this.toggle);


  @override
  _loginState createState()=>_loginState();
}
class _loginState extends State<Login>{
  TextEditingController _password=new TextEditingController();
  TextEditingController _useremail=new TextEditingController();
  AuthMethods authMethods=new AuthMethods();
  DataBaseMethods dataBaseMethods=new DataBaseMethods();
  bool isloading=false;
  QuerySnapshot snapshotUserInfo;
  signIn()
  {
    HelperFunctions.saveUserEmail(_useremail.text);
    HelperFunctions.saveUserLoggedIN(true);
    dataBaseMethods.getUserByUseremail(_useremail.text).then((val){
      snapshotUserInfo=val;
      HelperFunctions.saveUsername(snapshotUserInfo.documents[0].data["name"]);
    });
    setState(() {
      isloading=true;
    });
    authMethods.signInWithEmailAndPassword(_useremail.text, _password.text).then((value){
      if(value!=null){
        // TODO login success
      }
      else
      {
        showDialog(context: context,
            builder: (BuildContext context) {
              return AlertDialog(title: Text('Login failed :( ',
                style: TextStyle(color: Colors.deepPurple),),
                content: Text('The username or password isn'+"'"+'t correct'),
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
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.black,appBar: AppBar(title: Text('Login',style: TextStyle(color: Colors.black54),),backgroundColor: Colors.yellow[200],),
      body:Center(
        child: SingleChildScrollView(
          child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center,children: [
            TextField(controller: _useremail,style: simpleTextFieldStyle(),
              decoration:textfield("Email"),),
            TextField(controller: _password,style: simpleTextFieldStyle(),obscureText: true,
                decoration:textfield("Password")),
            SizedBox(height: 8,),
            Container(alignment: Alignment.centerRight,child:  Container(padding: EdgeInsets.symmetric(horizontal:16,vertical: 8),
              child: Text("Forget Password?",style: simpleTextFieldStyle(),),),),
            SizedBox(height: 8,),
            Container(child: RaisedButton(child:Text('Login'),onPressed: (){
              //signIn();
              //TODO Login
              Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=>AllQuotes()));
            },
              shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0)) ,),),
            Container(child: RaisedButton(child:Text('Sign in with Google'),onPressed: (){
            },
              shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0)) ,),),
            SizedBox(height: 8,),
            GestureDetector(onTap: (){
              widget.toggle();
            },
              child: Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                Text("Don't have account? ",style: mediumTextStyle(),),
                Text("Register Now",style: TextStyle(color: Colors.white,fontSize:16,decoration:TextDecoration.underline ),),

              ],),
            )
          ],),),
        ),
      ) ,);
  }
}