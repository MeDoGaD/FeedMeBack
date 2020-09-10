import 'package:flutter/material.dart';

class Comment extends StatefulWidget{
  final String Username;
  final String Quote_Comment;
  Comment(this.Username,this.Quote_Comment);

  @override
  _CommentState createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  @override
  Widget build(BuildContext context) {
    double scwidth = MediaQuery.of(context).size.width;
    double scheight = MediaQuery.of(context).size.height;
    return Container(decoration: BoxDecoration(gradient: LinearGradient(colors: [
      Colors.deepPurple,Colors.blue
    ]),borderRadius: BorderRadius.circular(30)),
      child:Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          Text(widget.Username,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18)),
          Text(widget.Quote_Comment,style: TextStyle(color: Colors.white,fontSize: 16),)
        ],),
      ) ,);
  }
}