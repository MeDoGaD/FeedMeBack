import 'dart:async';

import 'package:feedme/model/quot_model.dart';
import 'package:feedme/model/user_model.dart';
import 'package:feedme/services/database.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Quote extends StatefulWidget {
  final User _currentUser;
  final Quot _currentQuote;

  const Quote(this._currentUser, this._currentQuote);


  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _QuoteState();
  }
}

class _QuoteState extends State<Quote> {
  DataBaseMethods _dataBaseMethods = new DataBaseMethods();
  StreamSubscription _onFollowingAddedSubscribtion;
  StreamSubscription _onLikedgAddedSubscribtion;
  bool Followed;
  bool Liked;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Followed = false;
    Liked = false;
    _onFollowingAddedSubscribtion = FirebaseDatabase.instance
        .reference()
        .child('user')
        .child(widget._currentUser.id)
        .child('following')
        .onChildAdded
        .listen(onFollowingAdded);
    _onLikedgAddedSubscribtion = FirebaseDatabase.instance
    .reference()
    .child('user')
    .child(widget._currentUser.id)
    .child('likedQuotes')
    .onChildAdded
    .listen(onLikedAdded);
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
                  widget._currentQuote.authorName,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: widget._currentQuote.authorName.length > 6 ? 18 : 24),
                ),
                SizedBox(
                  width: scwidth * 0.1,
                ),
                RaisedButton(
                    onPressed: () async {
                      _dataBaseMethods.followUser(
                          widget._currentQuote.authorID, widget._currentQuote.authorName,Followed);
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
            widget._currentQuote.title,
            style: TextStyle(color: Colors.white, fontSize: 22),
          ),
          Text(
            widget._currentQuote.text,
            style: TextStyle(color: Colors.white70, fontSize: 18),
          ),
          SizedBox(height: scheight / 40),
          IconButton(
            onPressed: (){
              setState(() {
                Liked = !Liked;
                Liked? widget._currentQuote.numberOfLikes++ : widget._currentQuote.numberOfLikes--;
                _dataBaseMethods.likeQuote(widget._currentQuote, Liked);
              });
            },
            padding: EdgeInsets.only(left: scwidth / 1.5),
            icon: Icon(
              Liked? Icons.favorite : Icons.favorite_border,
              color: Liked?  Colors.red : Color.fromRGBO(255, 150, 140, 0.7),
              size: 35,
            ),
          )
        ],
      ),
    );
  }

  void onFollowingAdded(Event event) {
    setState(() {
      if(widget._currentQuote.authorID == event.snapshot.value['id'])
        Followed=true;
    });
  }

  void onLikedAdded(Event event) {
    setState(() {
      if(event.snapshot.key == widget._currentQuote.quotID)
        Liked = true;
    });
  }
}
