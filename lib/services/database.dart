import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedme/UI_models/Followers&Followings&Stared.dart';
import 'package:feedme/model/quot_model.dart';
import 'package:feedme/model/user_model.dart';
import 'package:firebase_database/firebase_database.dart';
//import 'package:intl/intl.dart';

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
    _userReference.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, values) {
        if (values['email'] == useremail) {
          currentUser = new User(
              password: values['password'],
              email: values['email'],
              username: values['username']);
        }
      });
    });
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
      if (followed) {
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
      } else {
        _userReference
            .child(id)
            .child('followers')
            .child(currentUser.id)
            .remove();
        _userReference
            .child(currentUser.id)
            .child('following')
            .child(id)
            .remove();
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
      'numberOfComments': quot.numberOfComments
    });
  }

  Future<User> getUser(String username)async {
    _userReference.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> data = snapshot.value;
      data.forEach((key, value) {
        if(value['username'] == username)
          return Future(()=> User(username: username, email: value['email'],id: key));
//        print(value['username']);
      });
    });
  }

  get(String quotID)async {
    return await _quotReference
        .child(quotID)
        .child('textsOfComments')
        .orderByChild('date')
        .limitToFirst(15)
        .onValue;

  }
  
  updateQuote(Quot quot) {
    _quotReference.child(quot.quotID).set({
      'title': quot.title,
      'text': quot.text,
      'author': quot.authorName,
      'authorID': quot.authorID,
      'likes': quot.numberOfLikes,
      'deslikes': quot.numberOfDeslikes,
      'numberOfComments': quot.numberOfComments
    });
  }

  void likeQuote(Quot quote, bool liked) {
    _quotReference.child(quote.quotID).child('likes').set(quote.numberOfLikes);
    liked
        ? _userReference
            .child(currentUser.id)
            .child('likedQuotes')
            .child(quote.quotID)
            .set(quote.title)
        : _userReference
            .child(currentUser.id)
            .child('likedQuotes')
            .child(quote.quotID)
            .remove();
  }

  void deslikeQuote(Quot quote, bool deslike) {
    _quotReference
        .child(quote.quotID)
        .child('deslikes')
        .set(quote.numberOfDeslikes);
    deslike
        ? _userReference
            .child(currentUser.id)
            .child('deslikedQuotes')
            .child(quote.quotID)
            .set(quote.title)
        : _userReference
            .child(currentUser.id)
            .child('deslikedQuotes')
            .child(quote.quotID)
            .remove();
  }

  void starQuote(Quot quote, bool stared) {
    stared
        ? _userReference
            .child(currentUser.id)
            .child('staredQuotes')
            .child(quote.quotID)
            .set(quote.title)
        : _userReference
            .child(currentUser.id)
            .child('staredQuotes')
            .child(quote.quotID)
            .remove();
  }

  void addComment(String commentText, Quot quot) {
    String key = (DateTime.now().year.toString() +
            DateTime.now().month.toString() +
            DateTime.now().day.toString() +
            DateTime.now().minute.toString() +
            DateTime.now().second.toString()+
            DateTime.now().millisecond.toString());
        _quotReference
        .child(quot.quotID)
        .child('numberOfComments')
        .set(quot.numberOfComments);
    _quotReference.child(quot.quotID).child('textsOfComments').child(key).set({
      'authorID': currentUser.id,
      'username': currentUser.username,
      'commentText': commentText,
      'date': DateTime.now().millisecondsSinceEpoch.toString()
    });
  }

  getComments(String quotID)async {
    return await _quotReference
        .child(quotID)
        .child('textsOfComments')
        .orderByChild('date')
        .limitToFirst(15)
        .onValue;

  }
}
