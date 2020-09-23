import 'dart:async';
import 'package:feedme/UI_models/Followers&Followings&Stared.dart';
import 'package:feedme/UI_models/Quote_model.dart';
import 'package:feedme/model/quot_model.dart';
import 'package:feedme/model/user_model.dart';
import 'package:feedme/pages/InsertQuote.dart';
import 'package:feedme/pages/quotes.dart';
import 'package:feedme/pages/search.dart';
import 'package:feedme/services/database.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  final User _currentUser = DataBaseMethods.currentUser;
  List<Quot> _quotes;

  Profile(this._quotes);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String BottomSheetState;
  DataBaseMethods _dataBaseMethods = new DataBaseMethods();
  StreamSubscription _onQuoteAddedSubscribtion;
  StreamSubscription _onUserAddedSubscribtion;
  List<Quot> _quotes;

  Map<dynamic, dynamic> _followers, _following, _stars, _likes, _deslikes;
  ScrollController _scrollController;

  List<Quot> _staredQuotes;
  int _staredQuotesIndex;
  bool _isOnTop = true;

  Query _Quotes;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _Quotes = FirebaseDatabase.instance
        .reference()
        .child('user')
        .child(widget._currentUser.id)
        .child('staredQuotes');
    _scrollController = new ScrollController();
    _quotes = widget._quotes;
    _staredQuotes = new List<Quot>();
//    _dataBaseMethods.getQuotes();
    _onQuoteAddedSubscribtion = FirebaseDatabase.instance
        .reference()
        .child('quot')
        .onChildAdded
        .listen(onQuoteAdded);
    _onUserAddedSubscribtion = FirebaseDatabase.instance
        .reference()
        .child('user')
        .child(widget._currentUser.id)
        .onChildAdded
        .listen(onUserAdded);
//    _quotes = new List<Quot>();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _onQuoteAddedSubscribtion.cancel();
    _onUserAddedSubscribtion.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  _scrollToBottom() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 1000), curve: Curves.easeOut);
    setState(() {
      _isOnTop = false;
    });
  }

  _scrollToTop() {
    _scrollController.animateTo(_scrollController.position.minScrollExtent,
        duration: Duration(milliseconds: 1000), curve: Curves.easeIn);
    setState(() => _isOnTop = true);
  }

  void showBottomSheet(int length) {
    double scheight = MediaQuery.of(context).size.height;
    double scwidth = MediaQuery.of(context).size.width;
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        BottomSheetState,
                        style: TextStyle(color: Colors.blue, fontSize: 30),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: StreamBuilder(
                          stream: _Quotes.onValue,
                          builder: (context, snapshot) {
                            if (!snapshot.hasData || snapshot.data.snapshot.value == null) return Text("No Data");

                            _stars = snapshot.data.snapshot.value;
                            length = _stars.length;
                            _staredQuotes = new List<Quot>();
                            for (int i = 0; i < _stars.length; i++) {
                              for (int j = 0; j < _quotes.length; j++) {
                                if (_stars.keys.elementAt(i) ==
                                    _quotes[j].quotID) {
                                  _staredQuotes.add(_quotes[j]);
                                }
                              }
                            }

                            return ListView.separated(
                                itemBuilder: (context, index) {
                                  if (BottomSheetState == "Followers") {
                                    if (length == 0)
                                      return Text("you have no followers yet!");

                                    return Followers_Followings(
                                        0,
                                        (_following.containsKey(
                                            _followers.keys.elementAt(index))),
                                        _followers.values.elementAt(index),
                                        _followers.keys.elementAt(index));
                                  } else if (BottomSheetState == "Followings") {
                                    if (length == 0)
                                      return Text(
                                          "you have not followed any one!");
                                    return Followers_Followings(
                                        1,
                                        true,
                                        _following.values.elementAt(index),
                                        _following.keys.elementAt(index));
                                  } else {
                                    String staredQuote =
                                    _stars.keys.elementAt(index);
                                    if (length == 0)
                                      return Text("you have no stared Quotes!");
                                    return StaredMsgs(
                                        _staredQuotes[index],
                                        _likes == null
                                            ? false
                                            : _likes.keys.contains(staredQuote),
                                        _deslikes == null
                                            ? false
                                            : _deslikes.keys
                                            .contains(staredQuote));
                                  }
                                },
                                separatorBuilder: (context, index) => SizedBox(
                                  height: scheight / 40,
                                ),
                                itemCount: length == 0 ? 1 : length);
                          })),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    double scwidth = MediaQuery.of(context).size.width;
    double scheight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Colors.blue[900],
              Colors.blue[700],
              Colors.blue[900],
              //Color.fromRGBO(143, 148, 251, 1),
              //Color.fromRGBO(143, 148, 251, .7),
            ])),
        child: Padding(
          padding: EdgeInsets.only(top: scheight * 1 / 15),
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Container(
                    width: scwidth * 1 / 8,
                    height: scheight * 1 / 16,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/notes.png'),
                            fit: BoxFit.fill),
                        shape: BoxShape.circle),
                  ),
                  SizedBox(width: scwidth * 1 / 15),

                    Container(
                        width: scwidth * 1 / 4,
                        child: TextField(onTap: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => new Search()));
                        },
                          decoration: InputDecoration(
                            hintText: 'Search',
                            hintStyle: TextStyle(color: Colors.white70),
                          ),
                          style: TextStyle(color: Colors.white),
                        )),

                  IconButton(
                    icon: Icon(
                      Icons.search,
                      color: Colors.white70,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => new Search()));
                    },
                  ),
                  SizedBox(width: scwidth * 1 / 17),
                  GestureDetector(
                      onTap: () {},
                      child: Text(
                        widget._currentUser == null
                            ? ""
                            : widget._currentUser.username,
                        style: TextStyle(color: Colors.white70),
                      )),
                  SizedBox(width: scwidth * 1 / 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => new AllQuotes()));
                    },
                    child: Text(
                      'Home',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    BottomSheetState = "Followers";
                    _followers != null
                        ? showBottomSheet(_followers.length)
                        : showBottomSheet(0);
                  },
                  child: Text(
                    "Followers",
                    style: TextStyle(
                        color: Colors.white70,
                        decoration: TextDecoration.underline),
                  ),
                ),
                GestureDetector(
                    onTap: () {
                      BottomSheetState = "Followings";
                      _following != null
                          ? showBottomSheet(_following.length)
                          : showBottomSheet(0);
                    },
                    child: Text(
                      "Followings",
                      style: TextStyle(
                          color: Colors.white70,
                          decoration: TextDecoration.underline),
                    )),
                GestureDetector(
                    onTap: () {
                      BottomSheetState = "Stared";
                      _stars != null
                          ? showBottomSheet(_stars.length)
                          : showBottomSheet(0);
                    },
                    child: Text(
                      "Stared Quotes",
                      style: TextStyle(
                          color: Colors.white70,
                          decoration: TextDecoration.underline),
                    )),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: scheight / 30,
                  left: scheight / 40,
                  right: scheight / 30),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => new InsertQuote()));
                },
                child: Container(
                  width: scwidth,
                  height: scheight / 8,
                  decoration: BoxDecoration(
                      color: Colors.white70,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(30),
                          topLeft: Radius.circular(30))),
                  child: Center(
                    child: Text(
                      'Type a Quote here ... ',
                      style: TextStyle(fontSize: 22, color: Colors.grey[500]),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                itemCount: _quotes.length,
                itemBuilder: (context, index) {
                  if (_quotes[(_quotes.length - 1) - index].authorName ==
                      widget._currentUser.username) {
                    return Quote(widget._currentUser,
                        _quotes[(_quotes.length - 1) - index]);
                  } else {
                    return Container();
                  }
                },
                separatorBuilder: (context, index) => SizedBox(
                  height: _quotes[(_quotes.length - 1) - index].authorName ==
                      widget._currentUser.username
                      ? scheight * 1 / 70
                      : 0,
                ),
              ),


            ),
          ]),
        ),
      ),
    );
  }

  void onQuoteAdded(Event event) {
    setState(() {
//      _quotes.add(new Quot.fromSnapShot(event.snapshot));
    });
  }

  void onUserAdded(Event event) {
    setState(() {
      Map<dynamic, dynamic> followers, following, stars;
      if (following == null || followers == null || stars == null) {
        try {
          if (event.snapshot.key == "followers") {
            _followers = event.snapshot.value;
          }
          if (event.snapshot.key == "following") {
            _following = event.snapshot.value;
          }
          if (event.snapshot.key == "likedQuotes") {
            _likes = event.snapshot.value;
          }
          if (event.snapshot.key == "deslikedQuotes") {
            _deslikes = event.snapshot.value;
          }
          if (event.snapshot.key == "staredQuotes") {
//            _stars = event.snapshot.value;
//            for (int i = 0; i < _stars.length; i++) {
//              for (int j = 0; j < _quotes.length; j++) {
//                if (_stars.keys.elementAt(i) == _quotes[j].quotID) {
//                  _staredQuotes.add(_quotes[j]);
//                }
//              }
//            }
          }
        } catch (e) {
          print(e.toString());
        }
      }
    });
  }
}
