import 'package:firebase_database/firebase_database.dart';
import 'package:feedme/model/user_model.dart';
class Quot{
  String quotID;
  String title;
  String text;
  User author;
  int numberOfLikes;
  int numberOfDeslikes;
  List<String> comments;

  Quot(this.title,this.text,this.author,this.numberOfLikes,this.numberOfDeslikes,this.comments);

  Quot.map(dynamic obj){
    this.title = obj["title"];
    this.text = obj["text"];
    this.author = obj["author"];
    this.numberOfLikes = obj["likes"];
    this.numberOfDeslikes = obj["deslikes"];
    this.comments = obj["comments"];
  }
  String get _title => title;
  String get _text => text;
  User get _author => author;
  int get _likes => numberOfLikes;
  int get _deslikes => numberOfDeslikes;
  List<String> get _comments => comments;

  Quot.fromSnapShot(DataSnapshot snapshot){
    quotID = snapshot.key;
    title = snapshot.value["title"];
    text = snapshot.value["text"];
    author = snapshot.value["author"];
    numberOfLikes = snapshot.value["likes"];
    numberOfDeslikes = snapshot.value["deslikes"];
    comments = snapshot.value["comments"];
  }
}