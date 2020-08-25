import 'package:feedme/helper/helperfunctions.dart';
import 'package:feedme/pages/InsertQuote.dart';
import 'package:feedme/pages/quotes.dart';
import 'package:flutter/material.dart';
import 'package:feedme/helper/authentication.dart';
import 'package:feedme/pages/startpage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoggedIn=false;
  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }
  getLoggedInState()async{
    await HelperFunctions.getUserLoggedIN().then((value) {
      setState(() {
        isLoggedIn=value;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
   /* if(isLoggedIn==null)
    {
      return MaterialApp(
        home: Authenticate(),
      );
    }
    else {
      return MaterialApp(
        home: isLoggedIn ? Authenticate() : Authenticate(),
      );
    }*/
    return MaterialApp(
      home: InsertQuote(),
    );

  }
}

