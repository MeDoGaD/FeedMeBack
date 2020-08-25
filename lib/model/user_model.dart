import 'package:firebase_database/firebase_database.dart';

class User{
  String username;
  String email;
  String password;
  User({this.username, this.email, this.password});

  User.map(dynamic obj){
    this.username = obj["username"];
    this.email = obj["email"];
    this.password = obj["password"];
  }

  String get _username => username;
  String get _email => email;
  String get _password => password;

  User.fromSnapShot(DataSnapshot snapShot ){
    username = snapShot.value["username"];
    email = snapShot.value["email"];
    password = snapShot.value["password"];
  }

}
