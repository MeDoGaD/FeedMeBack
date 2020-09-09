import 'dart:async';
import 'package:feedme/NewIcons/my_flutter_app_icons.dart' as dislike ;
import 'package:feedme/UI_models/Comment_model.dart';
import 'package:feedme/model/quot_model.dart';
import 'package:feedme/model/user_model.dart';
import 'package:feedme/pages/quotes.dart';
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

  void showBottomSheet() {
    double scheight = MediaQuery.of(context).size.height;
    double scwidth = MediaQuery.of(context).size.width;
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              Text("Quote Comments",style: TextStyle(color: Colors.blueAccent,fontSize: 22,fontWeight: FontWeight.w600),),
              SizedBox(height: scheight*1/70,),
              Expanded(child: ListView.separated(itemBuilder: (context,index){
                return Comment("MeDo GaD","this is very fantastic quote cuz you are fa4y5 gdnnnnnnnnnnnnnnnnnnnnnnnnnnn ");
              }, separatorBuilder: (context,index)=>SizedBox(height: scheight*1/50,), itemCount: 20),),
              Row(children: [
                Container(
                  width: scwidth * 1 / 8,
                  height: scheight * 1 / 16,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/feed1.png'),
                          fit: BoxFit.fill),
                      shape: BoxShape.circle),
                ),
                Container(width: scwidth*0.66,child: TextField(decoration: InputDecoration(hintText: "Comment ... "),)),
                IconButton(icon:Icon(Icons.send,color: Colors.blue,),onPressed: (){

                },),
              ],),
            ],),
          );
        });
  }


  @override
  Widget build(BuildContext context) {
    double scwidth = MediaQuery.of(context).size.width;
    double scheight = MediaQuery.of(context).size.height;

    return Padding(
      padding:  EdgeInsets.all(scwidth*1/40),
      child: Container(
        width: scwidth * 0.8,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(30),bottomRight: Radius.circular(30),bottomLeft:Radius.circular(10) ,topRight:Radius.circular(10) ),
            border:
                Border.all(color: Color.fromRGBO(251, 212, 237, 1), width: 1)),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: scwidth * 0.17, top: 10),
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
            Padding(
              padding:  EdgeInsets.only(left: 4,right: 4),
              child: Text(
                widget._currentQuote.title,
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),
            ),
            Padding(
              padding:  EdgeInsets.only(left:4 ,right: 4),
              child: Text(
                widget._currentQuote.text,
                style: TextStyle(color: Colors.white70, fontSize: 18),
              ),
            ),
            SizedBox(height: scheight / 40),
            Row(children: [
              SizedBox(width: scwidth*1/60,),
              Text("150 "+"Like",style: TextStyle(color: Colors.red),),
              Text("   100 "+"Dislike",style: TextStyle(color: Colors.white),),
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
                padding: EdgeInsets.only(left: scwidth / 11),
                icon: Icon(
                  liked? Icons.favorite : Icons.favorite_border,
                  color: liked?  Colors.red : Color.fromRGBO(255, 150, 140, 0.7),
                  size: 25,
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
                icon: Icon(
                  deslike?dislike.MyFlutterApp.thumbs_down_alt : dislike.MyFlutterApp.thumbs_down,
                  color: deslike?  Colors.blue : Color.fromRGBO(255, 150, 140, 0.7),
                  size: 25,
                ),
              ),

              IconButton(
                onPressed: (){
                //TODO commenting
                  showBottomSheet();
                },
                padding: EdgeInsets.only(left: scwidth /30),
                icon: Icon(
                   Icons.comment ,
                  color: Color.fromRGBO(255, 150, 140, 0.7),
                  size: 25,
                ),
              ),

              IconButton(
                onPressed: (){
                  setState(() {
                    stared = !stared;
                    _dataBaseMethods.starQuote(widget._currentQuote,stared);
                  });
                },
                icon: Icon(
                  stared? Icons.star : Icons.star_border,
                  color: stared?  Colors.yellow : Color.fromRGBO(255, 150, 140, 0.7),
                  size: 25,
                ),
              ),
            ],),

          ],
        ),
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
