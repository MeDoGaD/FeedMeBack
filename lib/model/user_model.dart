import 'package:firebase_database/firebase_database.dart';

class User{
  String id;
  String username;
  String email;
  String password;
  User({this.username, this.email, this.password});

  User.map(dynamic obj){
    this.username = obj["username"];
    this.email = obj["email"];
    this.password = obj["password"];
  }

  String get _id => id;
  String get _username => username;
  String get _email => email;
  String get _password => password;

  User.fromSnapShot(DataSnapshot snapshot ){
    id = snapshot.key;
    username = snapshot.value["username"];
    email = snapshot.value["email"];
    password = snapshot.value["password"];
  }

}
