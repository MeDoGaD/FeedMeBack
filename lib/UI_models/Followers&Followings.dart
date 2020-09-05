import 'package:flutter/material.dart';

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