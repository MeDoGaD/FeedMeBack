import 'dart:async';
import 'package:feedme/UI_models/Followers&Followings&Stared.dart';
import 'package:feedme/UI_models/Quote_model.dart';
import 'package:feedme/model/quot_model.dart';
import 'package:feedme/model/user_model.dart';
import 'package:feedme/pages/InsertQuote.dart';
import 'package:feedme/pages/quotes.dart';
import 'package:feedme/services/database.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {

  final User _currentUser = DataBaseMethods.currentUser;
//  Profile(this._currentUser);
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String BottomSheetState;
  DataBaseMethods _dataBaseMethods = new DataBaseMethods();
  StreamSubscription _onQuoteAddedSubscribtion;
  List<Quot> _quotes;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    _dataBaseMethods.getQuotes();
    _onQuoteAddedSubscribtion = FirebaseDatabase.instance.reference().child('quot').onChildAdded.listen(onQuoteAdded);
    _quotes = new List<Quot>();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _onQuoteAddedSubscribtion.cancel();
  }

  void showBottomSheet(){
    double scheight = MediaQuery
        .of(context)
        .size
        .height;
    double scwidth = MediaQuery
        .of(context)
        .size
        .width;
    showModalBottomSheet(context: context, builder: (BuildContext context){
      return Column(children: [
         Padding(
           padding: const EdgeInsets.all(5.0),
           child: Row(mainAxisAlignment: MainAxisAlignment.center,children: [
             Text(BottomSheetState,style: TextStyle(color: Colors.blue,fontSize: 30),)
           ],),
         ),
        Expanded(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: ListView.separated (itemBuilder: (context,index){
            if(BottomSheetState!="Stared")
              {
                return Followers_Followings("Medo Gad");
              }
            else
              {
                return StaredMsgs("Medo Gad", "this is a test quote",true);
              }
          }, separatorBuilder:(context,index)=>SizedBox(height: scheight/40,) , itemCount: 20),
        ),
      ),
      ],);
    });
  }


  @override
  Widget build(BuildContext context) {
    double scwidth = MediaQuery.of(context).size.width;
    double scheight = MediaQuery.of(context).size.height;
    return Scaffold(
        //backgroundColor:Color.fromRGBO(30, 73, 117, 80),
        body: Container(decoration: BoxDecoration(gradient: LinearGradient(colors: [Color.fromRGBO(30, 73, 117, 80),Colors.deepPurple[700]])),
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
                      SizedBox(width: scwidth * 1 / 17),
                      GestureDetector(
                          onTap: () {

                          },
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
                                  builder: (context) =>
                                      new AllQuotes()));
                        },
                        child: Text(
                          'Home',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(mainAxisAlignment: MainAxisAlignment.spaceAround,children: [
                  GestureDetector(onTap: (){
                    BottomSheetState="Followers";
                    showBottomSheet();
                  },child: Text("Followers",style: TextStyle(color: Colors.white70,decoration: TextDecoration.underline),)),
                  GestureDetector(onTap: (){
                    BottomSheetState="Followings";
                    showBottomSheet();
                  },child: Text("Followings",style: TextStyle(color: Colors.white70,decoration: TextDecoration.underline),)),
                  GestureDetector(onTap: (){
                    BottomSheetState="Stared";
                    showBottomSheet();
                  },child: Text("Stared Messages",style: TextStyle(color: Colors.white70,decoration: TextDecoration.underline),)),
                ],),
                Padding(
                  padding: EdgeInsets.only(
                      top: scheight / 30,
                      left: scheight / 40,
                      right: scheight / 30),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                              new InsertQuote()));
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
                    reverse: false,
                    itemCount: _quotes.length,
                    itemBuilder: (context, index) {
                    if(_quotes[index].authorName==widget._currentUser.username) {
                      return Quote(widget._currentUser,_quotes[index]);
                    }
                    else
                      {
                        return Container();
                      }
                    },
                    separatorBuilder: (context, index) => SizedBox(height:_quotes[index].authorName==widget._currentUser.username?scheight * 1 / 30:0,),
                  ),
                ),
              ]),
          ),
        ),

    );

  }
  void onQuoteAdded(Event event) {
    setState(() {
      _quotes.add(new Quot.fromSnapShot(event.snapshot));
    });
  }
}



//
//class Quote extends StatelessWidget {
//  final String username;
//  final String title;
//  final String quote;
//  DataBaseMethods _dataBaseMethods = new DataBaseMethods();
//
//  Quote(this.username, this.title, this.quote);
//  @override
//  Widget build(BuildContext context) {
//    double scwidth = MediaQuery.of(context).size.width;
//    double scheight = MediaQuery.of(context).size.height;
//    return Container(
//      width: scwidth * 0.8,
//      decoration: BoxDecoration(
//          borderRadius: BorderRadius.circular(30),
//          border:
//          Border.all(color: Color.fromRGBO(251, 212, 237, 1), width: 1)),
//      child: Column(
//        children: [
//          Padding(
//
//            padding: EdgeInsets.only(left: scwidth * 0.17, top: 20 ),
//            child: Row(
//              children: [
//                Text(
//                  username,
//                  style: TextStyle(color: Colors.white, fontSize: username.length>6?18:24),
//                ),
//                SizedBox(
//                  width: scwidth * 0.1,
//                ),
//                RaisedButton(
//                    onPressed: () async {
//                      List<Quot> quotes = await _dataBaseMethods.getQuotes();
//                      print(quotes[0].title);
//                    },
//                    child: Text('Follow'),
//                    shape: RoundedRectangleBorder(
//                        borderRadius: BorderRadius.circular(40))),
//              ],
//            ),
//          ),
//          Text(
//            '___________________________',
//            style: TextStyle(
//                color: Color.fromRGBO(251, 212, 237, 1), fontSize: 20),
//          ),
//          Text(
//            title,
//            style: TextStyle(color: Colors.white, fontSize: 22),
//          ),
//          Text(
//            quote,
//            style: TextStyle(color: Colors.white70, fontSize: 18),
//          ),
//          SizedBox(height:scheight/40),
//          IconButton(padding: EdgeInsets.only(left: scwidth/1.5),icon:Icon(Icons.favorite,color: Colors.red,size:35 ,),)
//        ],
//      ),
//    );
//  }
//}