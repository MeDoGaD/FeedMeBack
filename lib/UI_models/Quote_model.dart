import 'dart:async';
import 'package:feedme/NewIcons/my_flutter_app_icons.dart' as dislike ;
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
  StreamSubscription _onQuoteAddedSubscribtion;
  bool Followed;
  bool liked;
  bool deslike;
  bool stared;
  Map<dynamic, dynamic> following,likes,deslikes,stares;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Followed = false;
    liked = false;
    deslike = false;
    stared = false;
//    _onFollowingAddedSubscribtion = FirebaseDatabase.instance
//        .reference()
//        .child('user')
//        .child(widget._currentUser.id)
//        .child('following')
//        .onChildAdded
//        .listen(onFollowingAdded);
    _onQuoteAddedSubscribtion = FirebaseDatabase.instance
    .reference()
    .child('user')
    .child(widget._currentUser.id)
    .onChildAdded
    .listen(onQuoteAdded);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _onQuoteAddedSubscribtion.cancel();
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
          Row(children: [
            IconButton(
              onPressed: (){
                setState(() {
                  liked = !liked;
                  if(deslike){
                    deslike = false;
                    widget._currentQuote.numberOfDeslikes--;
                    _dataBaseMethods.deslikeQuote(widget._currentQuote,deslike);
                  }
                  liked? widget._currentQuote.numberOfLikes++ : widget._currentQuote.numberOfLikes--;
                  _dataBaseMethods.likeQuote(widget._currentQuote, liked);
                });
              },
              padding: EdgeInsets.only(left: scwidth / 1.7),
              icon: Icon(
                liked? Icons.favorite : Icons.favorite_border,
                color: liked?  Colors.red : Color.fromRGBO(255, 150, 140, 0.7),
                size: 35,
              ),
            ),

            IconButton(
              onPressed: (){
                setState(() {
                  deslike = !deslike;
                  if(liked){
                    liked = false;
                    widget._currentQuote.numberOfLikes--;
                    _dataBaseMethods.likeQuote(widget._currentQuote, liked);
                  }
                  deslike?
                    widget._currentQuote.numberOfDeslikes++: widget._currentQuote.numberOfDeslikes--;
                  _dataBaseMethods.deslikeQuote(widget._currentQuote,deslike);
                });
              },
              padding: EdgeInsets.only(left: scwidth /30),
              icon: Icon(
                deslike?dislike.MyFlutterApp.thumbs_down_alt : dislike.MyFlutterApp.thumbs_down,
                color: deslike?  Colors.blue : Color.fromRGBO(255, 150, 140, 0.7),
                size: 35,
              ),
            ),

            IconButton(
              onPressed: (){
                setState(() {
                  stared = !stared;
                  _dataBaseMethods.starQuote(widget._currentQuote,stared);
                });
              },
              padding: EdgeInsets.only(left: scwidth /30),
              icon: Icon(
                stared? Icons.star : Icons.star_border,
                color: stared?  Colors.yellow : Color.fromRGBO(255, 150, 140, 0.7),
                size: 35,
              ),
            ),
          ],),

        ],
      ),
    );
  }
  void onQuoteAdded(Event event) {
    setState(() {
      if(following==null||likes==null||deslikes==null||stares==null) {
        try {
          if (event.snapshot.key == "following") {
            following = event.snapshot.value;
            if (following.containsKey(widget._currentQuote.authorID))
              Followed = true;
          }
          if (event.snapshot.key == "likedQuotes") {
            likes = event.snapshot.value;
            if (likes.containsKey(widget._currentQuote.quotID))
              liked = true;
          }
          if (event.snapshot.key == "deslikedQuotes") {
            deslikes = event.snapshot.value;
            if (deslikes.containsKey(widget._currentQuote.quotID))
              deslike = true;
          }
          if (event.snapshot.key == "staredQuotes") {
            stares = event.snapshot.value;
            if (stares.containsKey(widget._currentQuote.quotID))
              stared = true;
          }
        }
        catch (e) {
          print(e.toString());
        }
      }
    });


  }
}
