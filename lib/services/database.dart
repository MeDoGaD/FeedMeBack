import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedme/model/quot_model.dart';
import 'package:firebase_database/firebase_database.dart';
class DataBaseMethods {
  UsernameFound(String username)async{
    return await Firestore.instance.collection("Users").where("name",isEqualTo:username).getDocuments();
  }
  UseremailFound(String useremail)async{
    return await Firestore.instance.collection("Users").where("email",isEqualTo:useremail).snapshots();
  }

  getUserByUsername(String username) async {
    return await Firestore.instance
        .collection("Users")
        .where("name", isEqualTo: username)
        .getDocuments();
  }

  getUserByUseremail(String useremail) async {
    return await Firestore.instance
        .collection("Users")
        .where("email", isEqualTo: useremail)
        .getDocuments();
  }

  uploadUserInfo(userMap) {
    Firestore.instance.collection("Users").add(userMap);
  }

//  User
  DatabaseReference getUserReference(){
    FirebaseDatabase.instance.reference().child("user");
  }

//  Quot
  DatabaseReference getQuotReference(){
    FirebaseDatabase.instance.reference().child("Quot");
  }

  addQuote(Quot quot){
    getQuotReference().push().set({
      'text' : quot.text,
      'author': quot.author,
      'likes': quot.numberOfLikes,
      'deslikes':quot.numberOfDeslikes,
      'comments': quot.comments
    });
  }

  updateQuote(Quot quot){
    getQuotReference().child(quot.quotID).set({
      'text' : quot.text,
      'author': quot.author,
      'likes': quot.numberOfLikes,
      'deslikes':quot.numberOfDeslikes,
      'comments': quot.comments
    });
  }
}
