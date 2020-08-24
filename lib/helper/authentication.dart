import 'package:feedme/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:feedme/pages/register.dart';


class Authenticate extends StatefulWidget{
  @override
  _AuthenticateState createState()=>_AuthenticateState();
}
class _AuthenticateState extends State<Authenticate>{
  bool showSignIn=true;

  void toggleView(){
    setState(() {
      showSignIn=!showSignIn;
    });
  }
  @override
  Widget build(BuildContext context) {
    if(showSignIn)
    {
      return Login(toggleView);
    }
    else
    {
      return Register(toggleView);
    }
  }
}

