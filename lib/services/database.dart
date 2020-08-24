import 'package:cloud_firestore/cloud_firestore.dart';

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


}
