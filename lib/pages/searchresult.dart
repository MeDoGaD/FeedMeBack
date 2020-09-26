import 'package:feedme/helper/helperfunctions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedme/model/quot_model.dart';
import 'package:feedme/model/user_model.dart';
import 'package:feedme/pages/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:feedme/services/database.dart';
import 'package:feedme/Widgets/widget.dart';

class SearchResult extends StatefulWidget {
  String searchUsername;
  User searchUser, _currentUser = DataBaseMethods.currentUser;
  List<Quot> quotes;
  SearchResult({this.searchUsername, this.quotes});
  @override
  _SearchResultState createState() => _SearchResultState();
}

String _myName;

class _SearchResultState extends State<SearchResult> {
  TextEditingController _searchResult = new TextEditingController();
  DataBaseMethods _dataBaseMethods;
  bool Followed = false;
  initialSearch() {}

  Widget searchList() {
    return Container();
  }

  @override
  void initState() {
    super.initState();
    _dataBaseMethods = DataBaseMethods();
  }

  Widget searchTile(String username, String useremail) {
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
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [],
          ),
          Spacer(
            flex: 10,
          ),
          GestureDetector(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: LinearGradient(colors: [
                    Color.fromRGBO(143, 148, 251, 1),
                    Color.fromRGBO(143, 148, 251, .6),
                  ])),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Text(
                "Profile",
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
            onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => new Profile(widget.quotes,
                        searchedUser: widget.searchUser))),
          ),
          Spacer(),
          followButton()
        ],
      ),
    );
  }

  followButton() {
    if (widget.searchUser.id != widget._currentUser.id)
      return GestureDetector(
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              gradient: !Followed
                  ? LinearGradient(colors: [
                      Color.fromRGBO(143, 148, 251, 1),
                      Color.fromRGBO(143, 148, 251, .6),
                    ])
                  : LinearGradient(colors: [
                      Colors.green
                    ])),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Text(Followed ? "Followed" : "Follow",
                  style: TextStyle(color: Colors.white,fontSize: 12),),
        ),
        onTap: () async {
          setState(() {
            Followed = !Followed;
          });
          _dataBaseMethods.followUser(
              widget.searchUser.id, widget.searchUser.id, Followed);
        },
      );
    else
      return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(143, 148, 251, 1),
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
            else {
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
              return found
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        searchTile(widget.searchUser.username,
                            widget.searchUser.email),
                      ],
                    )
                  : Center(
                      child: Text(
                      "Couldn't find user ${widget.searchUsername}",
                      style: TextStyle(color: Colors.white),
                    ));
            }
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
