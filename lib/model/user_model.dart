import 'package:firebase_database/firebase_database.dart';

class User{
  String userId;
  String email;
  String password;
  User({this.userId, this.email, this.password});

  User.map(dynamic obj){
    this.userId = obj["ID"];
    this.email = obj["email"];
    this.password = obj["password"];
  }

  String get _userId => userId;
  String get _email => email;
  String get _password => password;

  User.fromSnapShot(DataSnapshot snapShot ){
    userId = snapShot.key;
    email = snapShot.value["email"];
    password = snapShot.value["password"];
  }

}
