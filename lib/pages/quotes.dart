import 'dart:async';
import 'package:feedme/UI_models/Comment_model.dart';
import 'package:feedme/model/quot_model.dart';
import 'package:feedme/model/user_model.dart';
import 'package:feedme/pages/profile.dart';
import 'package:feedme/services/database.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:feedme/helper/authentication.dart';
import 'package:feedme/pages/InsertQuote.dart';
import 'package:feedme/UI_models/Quote_model.dart';

class AllQuotes extends StatefulWidget {
  User currentUser = DataBaseMethods.currentUser;
//  const AllQuotes(this.currentUser);
  _AllQuotesState createState() => _AllQuotesState();
}

class _AllQuotesState extends State<AllQuotes> {
  DataBaseMethods _dataBaseMethods = new DataBaseMethods();
  StreamSubscription _onQuoteAddedSubscribtion;
  StreamSubscription _onUserAddedSubscribtion;

  List<Quot> _quotes;
//  _AllQuotesState(w);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    _dataBaseMethods.getQuotes();
    _onQuoteAddedSubscribtion = FirebaseDatabase.instance
        .reference()
        .child('quot')
        .onChildAdded
        .listen(onQuoteAdded);
//    _onUserAddedSubscribtion = FirebaseDatabase.instance.reference().child('user').onChildAdded.listen(onUserAdded);
    _quotes = new List<Quot>();
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
    return (Scaffold(

      body: Container(decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.blue[900],
         Colors.blue[700],Colors.blue[900],
      ])),
        child: Padding(
            padding: EdgeInsets.only(top: scheight * 1 / 15),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Container(
                        width: scwidth * 1 / 8,
                        height: scheight * 1 / 16,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/feed1.png'),
                                fit: BoxFit.fill),
                            shape: BoxShape.circle),
                      ),
                      SizedBox(width: scwidth * 1 / 15),
                      Container(
                          width: scwidth * 1 / 4,
                          child: TextField(
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
                        onPressed: () {},
                      ),
                      SizedBox(width: scwidth * 1 / 20),
                      GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        new Profile()));
                          },
                          child: Text(
                            widget.currentUser == null ? "" : widget.currentUser.username,
                            style: TextStyle(color: Colors.white70),
                          )),
                      SizedBox(width: scwidth * 1 / 17),
                      GestureDetector(
                        onTap: () {},
                        child: Text(
                          'Home',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ],
                  ),
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
                              builder: (context) => InsertQuote()));
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
                    reverse: true,
                    itemCount: _quotes.length,
                    itemBuilder: (context, index) {
                      return Quote(widget.currentUser,_quotes[index]);
                    },
                    separatorBuilder: (context, index) => SizedBox(
                      height: scheight * 1 / 100,
                    ),
                  ),
                ),
              ],
            )),
      ),
    ));
  }

  void onQuoteAdded(Event event) {
    setState(() {
      _quotes.add(new Quot.fromSnapShot(event.snapshot));
    });
  }
}
