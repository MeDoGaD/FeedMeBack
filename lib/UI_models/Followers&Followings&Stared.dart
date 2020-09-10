import 'package:feedme/model/quot_model.dart';
import 'package:feedme/services/database.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:feedme/NewIcons/my_flutter_app_icons.dart' as dislike;

class Followers_Followings extends StatelessWidget {
  final String username, id;
  bool followed = true;
  Followers_Followings(this.username, this.id);
  @override
  Widget build(BuildContext context) {
    double scwidth = MediaQuery.of(context).size.width;
    double scheight = MediaQuery.of(context).size.height;
    DataBaseMethods _databaseMethods = new DataBaseMethods();
    return Container(
      width: scwidth / 2,
      child: Row(
        children: [
          Container(
            width: scwidth * 1 / 8,
            height: scheight * 1 / 16,
            decoration: BoxDecoration(
                color: Colors.blueAccent,
                image: DecorationImage(image: AssetImage('assets/feed1.png')),
                shape: BoxShape.circle),
          ),
          SizedBox(
            width: scwidth * 1 / 15,
          ),
          Text(
            username,
            style: TextStyle(color: Colors.black, fontSize: 25),
          ),
          SizedBox(
            width: scwidth * 1 / 8,
          ),
          RaisedButton(
            color: Colors.blue,
            onPressed: () {
              _databaseMethods.followUser(id, username, true);
            },
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
            child: Text(
              followed? "UnFollow":"Follow",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}

class StaredMsgs extends StatefulWidget {
  final Quot quote;
  bool liked, desliked, stared=true;

  StaredMsgs(this.quote, this.liked, this.desliked);
  @override
  State<StatefulWidget> createState() {
    return new _StaredMsgsState();
  }
}

class _StaredMsgsState extends State<StaredMsgs> {
  var _dataBaseMethods = new DataBaseMethods();

  @override
  Widget build(BuildContext context) {
    double scwidth = MediaQuery.of(context).size.width;
    double scheight = MediaQuery.of(context).size.height;
    return  Container(
      child: Column(
        children: [
          Container(
            child: Text(
              widget.quote.text,
              style: TextStyle(
                  fontWeight: FontWeight.w600, fontStyle: FontStyle.italic),
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  //TODO
                  setState(() {
                    widget.liked = !widget.liked;

                    if (widget.desliked) {
                      widget.desliked = false;
                      widget.quote.numberOfDeslikes--;
                      _dataBaseMethods.deslikeQuote(
                          widget.quote, widget.desliked);
                    }
                  });

                  widget.liked
                      ? widget.quote.numberOfLikes++
                      : widget.quote.numberOfLikes--;
                  _dataBaseMethods.likeQuote(widget.quote, widget.liked);
                },
                icon: Icon(
                  widget.liked ? Icons.favorite : Icons.favorite_border,
                  color: widget.liked
                      ? Colors.red
                      : Color.fromRGBO(255, 150, 140, 0.7),
                  size: 35,
                ),
              ),
              IconButton(
                onPressed: () {
                  //TODO
                  setState(() {
                    widget.desliked = !widget.desliked;
                    if (widget.liked) {
                      widget.liked = false;
                      widget.quote.numberOfLikes--;
                      _dataBaseMethods.likeQuote(widget.quote, widget.liked);
                    }
                    widget.desliked
                        ? widget.quote.numberOfDeslikes++
                        : widget.quote.numberOfDeslikes--;
                    _dataBaseMethods.deslikeQuote(
                        widget.quote, widget.desliked);
                  });
                },
                padding: EdgeInsets.only(left: scwidth / 50),
                icon: Icon(
                  widget.desliked
                      ? dislike.MyFlutterApp.thumbs_down_alt
                      : dislike.MyFlutterApp.thumbs_down,
                  color: widget.desliked
                      ? Colors.blue
                      : Color.fromRGBO(255, 150, 140, 0.7),
                  size: 35,
                ),
              ),
              IconButton(
                onPressed: () {
                  //TODO
                  _dataBaseMethods.starQuote(widget.quote, false);
                  setState(() {
                    widget.stared = !widget.stared;
                  });
                },
                padding: EdgeInsets.only(left: scwidth / 50),
                icon: Icon(
                  widget.stared? Icons.star : Icons.star_border,
                  color: widget.stared? Colors.yellow : Color.fromRGBO(255, 150, 140, 0.7),
                  size: 35,
                ),
              ),
              SizedBox(
                width: scwidth * 1 / 3,
              ),
              Text(
                widget.quote.authorName,
                style: TextStyle(color: Colors.blueAccent),
              ),
            ],
          ),
        ],
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(bottomRight: Radius.circular(30)),
          gradient: LinearGradient(colors: [Colors.grey, Colors.white])),
    );
  }
}
