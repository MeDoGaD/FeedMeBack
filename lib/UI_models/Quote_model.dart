import 'dart:async';
import 'package:feedme/NewIcons/my_flutter_app_icons.dart' as dislike;
import 'package:feedme/UI_models/CommentUi_model.dart';
import 'package:feedme/model/comment_model.dart';
import 'package:feedme/model/quot_model.dart';
import 'package:feedme/model/user_model.dart';
import 'package:feedme/pages/quotes.dart';
import 'package:feedme/services/database.dart';
import 'package:feedme/services/quicksort.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

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

class Notification {
  String title;
  String body;
  String message;
  Notification(this.title, this.body, this.message);
}

class _QuoteState extends State<Quote> {
  DataBaseMethods _dataBaseMethods = new DataBaseMethods();
  StreamSubscription _onUserAddedSubscribtion;
  StreamSubscription _onCommentAddedSubscribtion;
  StreamSubscription _onQuoteAddedSubscribtion;
  bool Followed;
  bool liked;
  bool deslike;
  bool stared;
  Map<dynamic, dynamic> following, likes, deslikes, stares;
  List<Comment> _comments = new List();
//  List<CommentUi> _comments = new List();
  Stream _commentStream;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  List<Notification> _notifications = List<Notification>();

  Widget BuildNotification(Notification notification) {
    return ListTile(
      title: Text(notification.title),
      subtitle: Text(notification.body),
    );
  }

  _setNotification(Map<String, dynamic> message, int event) {
    if (event == 0) {
      final notification = message['notification'];
      final data = message['data'];
      String title = notification['title'];
      String body = notification['body'];
      String msg = data['message'];
      Notification N = Notification(title, body, msg);
      setState(() {
        _notifications.add(N);
      });
    } else if (event == 2) {
      final notification = message['notification'];
      setState(() {
        _notifications.add(Notification('onLaunch: ${notification['title']}',
            'onLaunch: ${notification['body']}', 'message'));
      });
    }
  }

  _getToken() {
    _firebaseMessaging.getToken().then((deviceToken) {
      print("device token : $deviceToken");
    });
  }

  _configureFirebaseListeners() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        _setNotification(message, 0);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        _setNotification(message, 1);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        _setNotification(message, 2);
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    Followed = false;
    liked = false;
    deslike = false;
    stared = false;
    _dataBaseMethods.getComments(widget._currentQuote.quotID).then((value) {
      setState(() {
        _commentStream = value;
      });
    });
    _onQuoteAddedSubscribtion = FirebaseDatabase.instance
        .reference()
        .child('quot')
        .child(widget._currentQuote.quotID)
        .onValue
        .listen(onQuoteAdded);
    _onUserAddedSubscribtion = FirebaseDatabase.instance
        .reference()
        .child('user')
        .child(widget._currentUser.id)
        .onChildAdded
        .listen(onUserAdded);
    super.initState();
//    _getToken();
//    _configureFirebaseListeners();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _onUserAddedSubscribtion.cancel();
    super.dispose();
  }

  Widget showBottomSheet() {
    double scheight = MediaQuery.of(context).size.height;
    double scwidth = MediaQuery.of(context).size.width;
    TextEditingController _commentTextController = new TextEditingController();
    _comments.sort((a, b) => a.date.compareTo(b.date));
//    List<Comment> x = _comments;
//    QuickSort.sort(_comments);
//    _comments.forEach((element) {print(element.text);});
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return StreamBuilder(
            stream: _commentStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return Text("NO DATA");

              bool hasComments = snapshot.data.snapshot.value != null;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      "Quote Comments",
                      style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 22,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: scheight * 1 / 70,
                    ),
                    Expanded(
                      child: !hasComments
                          ? Text("No Comments Founded")
                          : ListView.separated(
//                    reverse: true,
                              itemBuilder: (context, index) {
                                Map tmp = snapshot.data.snapshot.value;
                                tmp.forEach((key, value) {
                                  _comments.add(new Comment(value['authorID'],
                                      value['username'], value['commentText'],
                                      date: value['date'], commentID: key));
                                });
                                return CommentUi(
                                    _comments[(_comments.length - 1) - index]);
//                        return _comments[index];
                              },
                              separatorBuilder: (context, index) => SizedBox(
                                    height: scheight * 1 / 50,
                                  ),
                              itemCount: hasComments
                                  ? snapshot.data.snapshot.value.length
                                  : 0),
                    ),
                    Row(
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
                        Container(
                            width: scwidth * 0.66,
                            child: TextField(
                              controller: _commentTextController,
                              decoration:
                                  InputDecoration(hintText: "Comment ... "),
                            )),
                        IconButton(
                          icon: Icon(
                            Icons.send,
                            color: Colors.blue,
                          ),
                          onPressed: () {
                            setState(() {
                              widget._currentQuote.numberOfComments++;
                              _dataBaseMethods.addComment(
                                  _commentTextController.text,
                                  widget._currentQuote);
                              _commentTextController.clear();
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    double scwidth = MediaQuery.of(context).size.width;
    double scheight = MediaQuery.of(context).size.height;
//    return Scaffold(
//      body: ListView(
//        children: _notifications.map(BuildNotification).toList(),
//      ),
//    );

    return GestureDetector(
      onLongPress: () {
        //TODO remove quote
        showDialog(
          context: context,
          builder: (_)=>AlertDialog(
            content: FlatButton(
              color: Colors.black26,
              child: Text("Delete Quote"),
              onPressed: (){
                _dataBaseMethods.deleteQuote(widget._currentQuote);
                Navigator.of(context).pop();
              },
            ),
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.all(scwidth * 1 / 40),
        child: Container(
          width: scwidth * 0.8,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                  bottomLeft: Radius.circular(10),
                  topRight: Radius.circular(10)),
              border: Border.all(
                  color: Color.fromRGBO(251, 212, 237, 1), width: 1)),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left:
                        widget._currentQuote.authorID != widget._currentUser.id
                            ? scwidth * 0.17
                            : scwidth * 0.1,
                    top: 10),
                child: Row(
                  mainAxisAlignment:
                      widget._currentQuote.authorID == widget._currentUser.id
                          ? MainAxisAlignment.center
                          : MainAxisAlignment.start,
                  children: [
                    Text(
                      widget._currentQuote.authorName,
                      style: TextStyle(
//                          color: Colors.white,
                          fontSize: widget._currentQuote.authorName.length > 6
                              ? 18
                              : 24),
                    ),
                    SizedBox(
                      width: scwidth * 0.1,
                    ),
                    followButton()
                  ],
                ),
              ),
              Text(
                '___________________________',
                style: TextStyle(
                    color: Color.fromRGBO(251, 212, 237, 1), fontSize: 20),
              ),
              Padding(
                padding: EdgeInsets.only(left: 4, right: 4),
                child: Text(
                  widget._currentQuote.title,
                  style: TextStyle(fontSize: 22),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 4, right: 4),
                child: Text(
                  widget._currentQuote.text,
                  style: TextStyle(color: Colors.black54, fontSize: 18),
                ),
              ),
              SizedBox(height: scheight / 40),
              Row(
                children: [
                  SizedBox(
                    width: scwidth * 1 / 60,
                  ),
                  Text(
                    widget._currentQuote.numberOfLikes.toString(),
                    style: TextStyle(color: Colors.red),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        liked = !liked;
                        if (deslike) {
                          deslike = false;
                          widget._currentQuote.numberOfDeslikes--;
                          _dataBaseMethods.deslikeQuote(
                              widget._currentQuote, deslike);
                        }
                        liked
                            ? widget._currentQuote.numberOfLikes++
                            : widget._currentQuote.numberOfLikes--;
                        _dataBaseMethods.likeQuote(widget._currentQuote, liked);
                      });
                    },
                    padding: EdgeInsets.only(left: scwidth / 100),
                    icon: Icon(
                      liked ? Icons.favorite : Icons.favorite_border,
                      color: liked
                          ? Colors.red
                          : Color.fromRGBO(255, 150, 140, 0.7),
                      size: 25,
                    ),
                  ),
                  Text(
                    widget._currentQuote.numberOfDeslikes.toString(),
                    style: TextStyle(color: Colors.black54),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        deslike = !deslike;
                        if (liked) {
                          liked = false;
                          widget._currentQuote.numberOfLikes--;
                          _dataBaseMethods.likeQuote(
                              widget._currentQuote, liked);
                        }
                        deslike
                            ? widget._currentQuote.numberOfDeslikes++
                            : widget._currentQuote.numberOfDeslikes--;
                        _dataBaseMethods.deslikeQuote(
                            widget._currentQuote, deslike);
                      });
                    },
                    icon: Icon(
                      deslike
                          ? dislike.MyFlutterApp.thumbs_down_alt
                          : dislike.MyFlutterApp.thumbs_down,
                      color: deslike
                          ? Colors.blue
                          : Color.fromRGBO(255, 150, 140, 0.7),
                      size: 25,
                    ),
                  ),
                  SizedBox(
                    width: scwidth * 1 / 4,
                  ),
                  Text(
                    widget._currentQuote.numberOfComments.toString(),
                    style: TextStyle(color: Colors.black54),
                  ),
                  IconButton(
                    onPressed: () {
                      //TODO commenting
                      showBottomSheet();
                    },
//                    padding:
//                        EdgeInsets.only(left: scwidth / 5, right: scwidth / 25),
                    icon: Icon(
                      Icons.comment,
                      color: Color.fromRGBO(255, 150, 140, 0.7),
                      size: 25,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        stared = !stared;
                        _dataBaseMethods.starQuote(
                            widget._currentQuote, stared);
                      });
                    },
                    icon: Icon(
                      stared ? Icons.star : Icons.star_border,
                      color: stared
                          ? Colors.yellow
                          : Color.fromRGBO(255, 150, 140, 0.7),
                      size: 25,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  followButton() {
    if (widget._currentQuote.authorID != widget._currentUser.id)
      return RaisedButton(
          onPressed: () async {
            setState(() {
              Followed = !Followed;
            });
            _dataBaseMethods.followUser(widget._currentQuote.authorID,
                widget._currentQuote.authorName, Followed);
          },
          child: Text(Followed ? "Followed" : "Follow"),
          color: !Followed ? Colors.white : Colors.green,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)));
    else
      return Container();
  }

  void onUserAdded(Event event) {
    setState(() {
      if (following == null ||
          likes == null ||
          deslikes == null ||
          stares == null) {
        try {
          if (event.snapshot.key == "following") {
            following = event.snapshot.value;
            if (following.containsKey(widget._currentQuote.authorID))
              Followed = true;
          }
          if (event.snapshot.key == "likedQuotes") {
            likes = event.snapshot.value;
            if (likes.containsKey(widget._currentQuote.quotID)) liked = true;
          }
          if (event.snapshot.key == "deslikedQuotes") {
            deslikes = event.snapshot.value;
            if (deslikes.containsKey(widget._currentQuote.quotID))
              deslike = true;
          }
          if (event.snapshot.key == "staredQuotes") {
            stares = event.snapshot.value;
            if (stares.containsKey(widget._currentQuote.quotID)) stared = true;
          }
        } catch (e) {
          print(e.toString());
        }
      }
    });
  }

  void getComments() {
    FirebaseDatabase.instance
        .reference()
        .child('quot')
        .child(widget._currentQuote.quotID)
        .child('textsOfComments')
        .orderByKey()
        .once()
        .then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> tmp2 = snapshot.value;
      tmp2.forEach((key, value) {
        _comments.add(new Comment(
            value['authorID'], value['username'], value['commentText'],
            commentID: key, date: value['date']));
      });
    }).catchError((e) {});
  }

  void onQuoteAdded(Event event) {
    if (mounted)
      setState(() {
       try{
         widget._currentQuote.numberOfComments =
         event.snapshot.value['numberOfComments'];
         widget._currentQuote.numberOfLikes = event.snapshot.value['likes'];
         widget._currentQuote.numberOfDeslikes =
         event.snapshot.value['deslikes'];
       }catch(e){};
      });
  }
}
