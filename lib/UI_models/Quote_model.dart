import 'dart:async';

import 'package:feedme/model/user_model.dart';
import 'package:feedme/services/database.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Quote extends StatefulWidget {
  final User _currentUser;
  final String username;
  final String title;
  final String quote;
  final String authorID;
  Quote(
      this.authorID, this.username, this.title, this.quote, this._currentUser);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _QuoteState();
  }
}

class _QuoteState extends State<Quote> {
  DataBaseMethods _dataBaseMethods = new DataBaseMethods();
  StreamSubscription _onFollowingAddedSubscribtion;
  bool Followed;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Followed = false;
    _onFollowingAddedSubscribtion = FirebaseDatabase.instance
        .reference()
        .child('user')
        .child(widget._currentUser.id)
        .child('following')
        .onChildAdded
        .listen(onFollowingAdded);
  }

  @override
  Widget build(BuildContext context) {
    double scwidth = MediaQuery.of(context).size.width;
    double scheight = MediaQuery.of(context).size.height;

    return Container(
      width: scwidth * 0.8,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border:
              Border.all(color: Color.fromRGBO(251, 212, 237, 1), width: 1)),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: scwidth * 0.17, top: 20),
            child: Row(
              children: [
                Text(
                  widget.username,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: widget.username.length > 6 ? 18 : 24),
                ),
                SizedBox(
                  width: scwidth * 0.1,
                ),
                RaisedButton(
                    onPressed: () async {
                      _dataBaseMethods.followUser(
                          widget.authorID, widget.username,Followed);
                      setState(() {
                        Followed = !Followed;
                      });
                    },
                    child: Text(Followed? "Followed":"Follow"),
                    color: !Followed ? Colors.white : Colors.green,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40))),
              ],
            ),
          ),
          Text(
            '___________________________',
            style: TextStyle(
                color: Color.fromRGBO(251, 212, 237, 1), fontSize: 20),
          ),
          Text(
            widget.title,
            style: TextStyle(color: Colors.white, fontSize: 22),
          ),
          Text(
            widget.quote,
            style: TextStyle(color: Colors.white70, fontSize: 18),
          ),
          SizedBox(height: scheight / 40),
          IconButton(
            padding: EdgeInsets.only(left: scwidth / 1.5),
            icon: Icon(
              Icons.favorite,
              color: Colors.red,
              size: 35,
            ),
          )
        ],
      ),
    );
  }

  void onFollowingAdded(Event event) {
    setState(() {
      if(widget.authorID == event.snapshot.value['id'])
        Followed=true;
    });
  }
}
