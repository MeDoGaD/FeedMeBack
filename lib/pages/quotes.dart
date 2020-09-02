import 'dart:async';

import 'package:feedme/model/quot_model.dart';
import 'package:feedme/model/user_model.dart';
import 'package:feedme/services/database.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:feedme/helper/authentication.dart';
import 'package:feedme/pages/InsertQuote.dart';

class AllQuotes extends StatefulWidget {
  final User currentUser;
  const AllQuotes(this.currentUser);
  _AllQuotesState createState() => _AllQuotesState(currentUser);
}

class _AllQuotesState extends State<AllQuotes> {
  final User _currentUser;
  DataBaseMethods _dataBaseMethods = new DataBaseMethods();
  StreamSubscription _onQuoteAddedSubscribtion;
  List<Quot> _quotes;
  _AllQuotesState(this._currentUser);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _dataBaseMethods.getQuotes();
    _onQuoteAddedSubscribtion = FirebaseDatabase.instance.reference().child('quot').onChildAdded.listen(onQuoteAdded);
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
      backgroundColor: Color.fromRGBO(30, 73, 117, 80),
      body: Padding(
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
                        onTap: () {},
                        child: Text(
                          _currentUser == null ? "":_currentUser.username,
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
                child: GestureDetector(onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder:(context)=>InsertQuote(_currentUser)));
                },
                  child: Container(
                    width: scwidth,
                    height: scheight / 8,
                    decoration: BoxDecoration(
                        color: Colors.white70,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(30),
                            topLeft: Radius.circular(30))),child: Center(child: Text('Type a Quote here ... ',style: TextStyle(fontSize:22,color: Colors.grey[500]),),),
                  ),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  reverse: true,
                  itemCount: _quotes.length,
                  itemBuilder: (context, index) {
                    return Quote(_quotes[index].author, _quotes[index].title,
                        _quotes[index].text);
                  },
                  separatorBuilder: (context, index) => SizedBox(
                    height: scheight * 1 / 30,
                  ),
                ),
              ),
            ],
          )),
    ));
  }

  void onQuoteAdded(Event event) {
    setState(() {
      _quotes.add(new Quot.fromSnapShot(event.snapshot));
    });
  }
}

class Quote extends StatelessWidget {
  final String username;
  final String title;
  final String quote;
  DataBaseMethods _dataBaseMethods = new DataBaseMethods();

  Quote(this.username, this.title, this.quote);
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
            padding: EdgeInsets.only(left: scwidth * 0.1, top: 20 ),
            child: Row(
              children: [
                Text(
                  username,
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
                SizedBox(
                  width: scwidth * 0.15,
                ),
                RaisedButton(
                    onPressed: () async {
                      List<Quot> quotes = await _dataBaseMethods.getQuotes();
                      print(quotes[0].title);
                    },
                    child: Text('Follow'),
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
            title,
            style: TextStyle(color: Colors.white, fontSize: 22),
          ),
          Text(
            quote,
            style: TextStyle(color: Colors.white70, fontSize: 18),
          ),
          SizedBox(height:scheight/40),
          IconButton(padding: EdgeInsets.only(left: scwidth/1.5),icon:Icon(Icons.favorite,color: Colors.red,size:35 ,),)
        ],
      ),
    );
  }
}
