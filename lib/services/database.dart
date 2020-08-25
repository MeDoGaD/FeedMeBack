import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedme/model/quot_model.dart';
import 'package:feedme/model/user_model.dart';
import 'package:firebase_database/firebase_database.dart';

class DataBaseMethods {
  final _userReference = FirebaseDatabase.instance.reference().child('user');
  UsernameFound(String username) async {
    return await Firestore.instance
        .collection("Users")
        .where("name", isEqualTo: username)
        .getDocuments();
  }

  UseremailFound(String useremail) async {
    return await Firestore.instance
        .collection("Users")
        .where("email", isEqualTo: useremail)
        .snapshots();
  }

  getUserByUsername(String username) async {
    return await Firestore.instance
        .collection("Users")
        .where("name", isEqualTo: username)
        .getDocuments();
  }
  static User currentUser;
   getUserByUseremail(String useremail) {
//    return await Firestore.instance
//        .collection("Users")
//        .where("email", isEqualTo: useremail)
//        .getDocuments();
     _userReference.once().then((DataSnapshot snapshot) {
//          return new User.map(snapShot.value);
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, values) {
        if (values['email'] == useremail)
          {
            currentUser=new User(
                password: values['password'],
                email: values['email'],
                username: values['username']);
          // return user.username;
          }

      });
    });
//      return _userReference.child(useremail);
//      Map<dynamic, dynamic> map =
  }

  uploadUserInfo(User user) {
//    Firestore.instance.collection("Users").add(userMap);
    _userReference.push().set({
      'email': user.email,
      'password': user.password,
      'username': user.username
    });
  }

//  User

//  Quot
  DatabaseReference getQuotReference() {
    FirebaseDatabase.instance.reference().child("Quot");
  }

  addQuote(Quot quot) {
    getQuotReference().push().set({
      'text': quot.text,
      'author': quot.author,
      'likes': quot.numberOfLikes,
      'deslikes': quot.numberOfDeslikes,
      'comments': quot.comments
    });
  }

  updateQuote(Quot quot) {
    getQuotReference().child(quot.quotID).set({
      'text': quot.text,
      'author': quot.author,
      'likes': quot.numberOfLikes,
      'deslikes': quot.numberOfDeslikes,
      'comments': quot.comments
    });
  }
}
