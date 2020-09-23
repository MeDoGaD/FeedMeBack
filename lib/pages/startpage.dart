import 'package:feedme/helper/helperfunctions.dart';
import 'package:feedme/pages/quotes.dart';
import 'package:feedme/services/database.dart';
import 'package:flutter/material.dart';
import 'package:feedme/helper/authentication.dart';

class Start_Page extends StatefulWidget {
  _Start_PageState createState() => _Start_PageState();
}

class _Start_PageState extends State<Start_Page> {
  bool isLoggedIn=false;

  void initState() {
    getLoggedInState();
    super.initState();
  }
  getLoggedInState()async{
    await HelperFunctions.getUserLoggedIN().then((value) {
      setState(() {
        isLoggedIn=value;
      });
    });
  }
  DataBaseMethods dataBaseMethods=new DataBaseMethods();
  HelperFunctions helper=new HelperFunctions();
  @override
  Widget build(BuildContext context) {
    double scwidth=MediaQuery.of(context).size.width;
    double scheight=MediaQuery.of(context).size.height;
    return (Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding:  EdgeInsets.only(top:scheight*1/4 ),
        child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.start,children: [
          Text('FeedMeBack',style: TextStyle(color: Color.fromRGBO(143, 148, 251, 1),fontSize: 42,fontWeight: FontWeight.bold),),
          SizedBox(height: scheight*1/22,),
          Container(width: scwidth*0.4,height: scheight*1/5,decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/notes.png'),fit: BoxFit.fill)),),
          Padding(
            padding:  EdgeInsets.only(top: scheight*0.29),
            child: Container(width: scwidth*1/2,height: scheight*1/17,child: RaisedButton(color: Color.fromRGBO(143, 148, 251,0.8),onPressed: ()async{
             // if(isLoggedIn==null){
              Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=>Authenticate()));//}
             // else
               // {
                // String email=HelperFunctions.getUserEmail().toString();
                // await dataBaseMethods.getUserByUseremail(email);
                // print("***************");
                // print(DataBaseMethods.currentUser.username);
                // Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=>AllQuotes()));
               // }
            },child: Text('Start Now',style: TextStyle(color: Colors.white,fontSize: 20),),shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),)),
          ),
        ],),),
      ),
    ));
  }
}
