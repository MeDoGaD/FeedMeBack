import 'package:feedme/helper/helperfunctions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedme/model/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:feedme/services/database.dart';
import 'package:feedme/Widgets/widget.dart';

class SearchResult extends StatefulWidget {
  String searchUsername;
  User searchUser;
  SearchResult({this.searchUsername});
  @override
  _SearchResultState createState() => _SearchResultState();
}

String _myName;

class _SearchResultState extends State<SearchResult> {
  TextEditingController _searchResult = new TextEditingController();
  DataBaseMethods _dataBaseMethods;

  initialSearch() {}

  Widget searchList() {
    return Container();
  }

  @override
  void initState() {
    super.initState();
    _dataBaseMethods = DataBaseMethods();
  }

  Widget searchTile({String username, String useremail}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                username,
                style: mediumTextStyle(),
              ),
              Text(
                useremail,
                style: mediumTextStyle(),
              ),
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {},
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(30)),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Text(
                "Show Profile",
                style: mediumTextStyle(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text("Search"),
        ),
        body: FutureBuilder(
          future: _dataBaseMethods.getUser(widget.searchUsername),
          builder: (BuildContext context, AsyncSnapshot snap) {
            if (snap.connectionState == ConnectionState.waiting)
              return Center(
                child: Text(
                  "waiting...",
                  style: TextStyle(color: Colors.white),
                ),
              );
            if (!snap.hasData)
              return Center(
                child: Text(
                  "No Data Found!",
                  style: TextStyle(color: Colors.white),
                ),
              );
            Map tmp = snap.data.value;
            bool found = false;
            tmp.forEach((key, value) {
              if (value['username'] == widget.searchUsername.trim()) {
                widget.searchUser = new User(
                    username: value['username'],
                    email: value['email'],
                    password: value['password'],
                    id: key);
                found = true;
              }
            });
            return Container(
              child: Center(
                  child: Text(
                found
                    ? "userID: ${widget.searchUser.id}\nusername: ${widget.searchUser.username}\nemail: ${widget.searchUser.email}"
                    : "Couldn't find user ${widget.searchUsername}",
                style: TextStyle(color: Colors.white),
              )),
            );
          },
        ));
  }
}

class searchTile extends StatelessWidget {
  final String username;
  final String useremail;
  searchTile({this.username, this.useremail});
  @override
  Widget build(BuildContext context) {
    return searchTile();
  }
}
