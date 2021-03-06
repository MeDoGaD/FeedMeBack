import 'package:firebase_database/firebase_database.dart';
import 'package:feedme/model/user_model.dart';
class Quot{
  String quotID;
  String title;
  String text;
  String authorName;
  String authorID;
  int numberOfLikes;
  int numberOfDeslikes;
  int numberOfComments;

  Quot({this.title,this.text,this.authorName,this.authorID,this.numberOfLikes,this.numberOfDeslikes,this.numberOfComments});

  Quot.map(dynamic obj){
    this.title = obj["title"];
    this.text = obj["text"];
    this.authorName = obj["author"];
    this.authorID = obj["authorID"];
    this.numberOfLikes = obj["likes"];
    this.numberOfDeslikes = obj["deslikes"];
    this.numberOfComments = obj["comments"];
  }
  String get _title => title;
  String get _text => text;
  String get _authorName => authorName;
  String get _authorID => authorID;
  int get _likes => numberOfLikes;
  int get _deslikes => numberOfDeslikes;
  int get _comments => numberOfComments;

  Quot.fromSnapShot(DataSnapshot snapshot){
    quotID = snapshot.key;
    title = snapshot.value["title"];
    text = snapshot.value["text"];
    authorName = snapshot.value["author"];
    authorID = snapshot.value["authorID"];
    numberOfLikes = snapshot.value["likes"];
    numberOfDeslikes = snapshot.value["deslikes"];
    numberOfComments = snapshot.value["numberOfComments"];
  }
}