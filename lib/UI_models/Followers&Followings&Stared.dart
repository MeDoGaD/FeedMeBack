import 'package:flutter/material.dart';
import 'package:feedme/NewIcons/my_flutter_app_icons.dart' as dislike ;

class Followers_Followings extends StatelessWidget{
  final String username;
  Followers_Followings(this.username);
  @override
  Widget build(BuildContext context) {
    double scwidth = MediaQuery.of(context).size.width;
    double scheight = MediaQuery.of(context).size.height;
    return Container(width: scwidth/2,child:Row(children: [
      Container(width: scwidth * 1 / 8,
        height: scheight * 1 / 16,decoration: BoxDecoration(color: Colors.blueAccent,image: DecorationImage(image: AssetImage('assets/feed1.png')),shape: BoxShape.circle),),
      SizedBox(width: scwidth*1/15,),
      Text(username,style: TextStyle(color: Colors.black,fontSize: 25),),
      SizedBox(width: scwidth*1/8,),
      RaisedButton(color: Colors.blue,onPressed: (){},shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),child: Text("UnFollow",style: TextStyle(color: Colors.white),),)

    ],) ,);
  }
}



class StaredMsgs extends StatelessWidget{
  final String Username;
  final String Quote;
   bool Liked;
  StaredMsgs(this.Username,this.Quote,this.Liked);
  @override
  Widget build(BuildContext context) {
    double scwidth = MediaQuery.of(context).size.width;
    double scheight = MediaQuery.of(context).size.height;
    return Container(child: Column(children: [
      Container(child: Text(Quote,style: TextStyle(fontWeight: FontWeight.w600,fontStyle: FontStyle.italic),),),
      Row(children: [
        IconButton(
          onPressed: (){
             //TODO
          },
          icon: Icon(
            Liked? Icons.favorite : Icons.favorite_border,
            color: Liked?  Colors.red : Color.fromRGBO(255, 150, 140, 0.7),
            size: 35,
          ),
        ),

        IconButton(
          onPressed: (){
            //TODO
          },
          padding: EdgeInsets.only(left: scwidth /50),
          icon: Icon(
            Liked?dislike.MyFlutterApp.thumbs_down_alt : dislike.MyFlutterApp.thumbs_down,
            color: Liked?  Colors.blue : Color.fromRGBO(255, 150, 140, 0.7),
            size: 35,
          ),
        ),

        IconButton(
          onPressed: (){
           //TODO
          },
          padding: EdgeInsets.only(left: scwidth /50),
          icon: Icon(
            Liked? Icons.star : Icons.star_border,
            color: Liked?  Colors.yellow : Color.fromRGBO(255, 150, 140, 0.7),
            size: 35,
          ),
        ),
        SizedBox(width: scwidth*1/3,),
        Text(Username,style: TextStyle(color: Colors.blueAccent),),
      ],),
    ],),decoration: BoxDecoration(borderRadius: BorderRadius.only(bottomRight: Radius.circular(30)),gradient: LinearGradient(colors: [Colors.grey,Colors.white])),);
  }
}