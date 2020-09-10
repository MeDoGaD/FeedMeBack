import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedme/UI_models/Followers&Followings&Stared.dart';
import 'package:feedme/model/quot_model.dart';
import 'package:feedme/model/user_model.dart';
import 'package:firebase_database/firebase_database.dart';

class DataBaseMethods {
  final _userReference = FirebaseDatabase.instance.reference().child('user');
  final _quotReference = FirebaseDatabase.instance.reference().child('quot');
  static User currentUser;
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

  getUserByUseremail(String useremail) {
//    return await Firestore.instance
//        .collection("Users")
//        .where("email", isEqualTo: useremail)
//        .getDocuments();
    _userReference.once().then((DataSnapshot snapshot) {
//          return new User.map(snapShot.value);
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, values) {
        if (values['email'] == useremail) {
          currentUser = new User(
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
  followUser(String id, String username, bool followed) {
    try {
      if (!followed) {
        _userReference
            .child(id)
            .child('followers')
            .child(currentUser.id)
            .set(currentUser.username);
        _userReference
            .child(currentUser.id)
            .child('following')
            .child(id)
            .set(username);
      }
      else{
        _userReference.child(id).child('followers').child(currentUser.id).remove();
        _userReference.child(currentUser.id).child('following').child(id).remove();
      }
    } catch (e) {
      print("ERROR->${e.toString()}");
    }
    ;
  }

//  Quot
  addQuote(Quot quot) {
    _quotReference.push().set({
      'title': quot.title,
      'text': quot.text,
      'author': quot.authorName,
      'authorID': quot.authorID,
      'likes': quot.numberOfLikes,
      'deslikes': quot.numberOfDeslikes,
      'comments': quot.comments
    });
  }

//  List<Quot> getQuotes() {
//    _quotReference.once().then((DataSnapshot snapshot) {
//      Map<dynamic, dynamic> values = snapshot.value;
//      List<Quot> quotes = new List<Quot>();
//      values.forEach((key, value) {
//        quotes.add(new Quot(
//            title: value['title'],
//            text: value['text'],
//            authorName: value['author'],
//            authorID: value['authorID'],
//            numberOfLikes: value['likes'],
//            numberOfDeslikes: value['deslikes'],
//            comments: value['comments']));
//      });
//      return quotes;
//    });
//  }

  updateQuote(Quot quot) {
    _quotReference.child(quot.quotID).set({
      'title': quot.title,
      'text': quot.text,
      'author': quot.authorName,
      'authorID': quot.authorID,
      'likes': quot.numberOfLikes,
      'deslikes': quot.numberOfDeslikes,
      'comments': quot.comments
    });
  }

  void likeQuote(Quot quote, bool liked) {
    _quotReference.child(quote.quotID).child('likes').set(quote.numberOfLikes);
    liked?
      _userReference.child(currentUser.id).child('likedQuotes').child(quote.quotID).set(quote.title):
      _userReference.child(currentUser.id).child('likedQuotes').child(quote.quotID).remove();
  }

  void deslikeQuote(Quot quote, bool deslike) {
    _quotReference.child(quote.quotID).child('deslikes').set(quote.numberOfDeslikes);
    deslike?
        _userReference.child(currentUser.id).child('deslikedQuotes').child(quote.quotID).set(quote.title):
        _userReference.child(currentUser.id).child('deslikedQuotes').child(quote.quotID).remove();

  }

  void starQuote(Quot quote, bool stared) {
    stared?
      _userReference.child(currentUser.id).child('staredQuotes').child(quote.quotID).set(quote.title):
      _userReference.child(currentUser.id).child('staredQuotes').child(quote.quotID).remove();
  }

}
