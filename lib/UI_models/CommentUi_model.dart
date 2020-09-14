import 'package:feedme/model/comment_model.dart';
import 'package:flutter/material.dart';

class CommentUi extends StatefulWidget{
//  final String Username;
//  final String Quote_Comment;
  Comment _currentComment;
  CommentUi(this._currentComment);

  @override
  _CommentUiState createState() => _CommentUiState();
}

class _CommentUiState extends State<CommentUi> {
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
          Text(widget._currentComment.authorID,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18)),
          Text(widget._currentComment.text,style: TextStyle(color: Colors.white,fontSize: 16),)
        ],),
      ) ,);
  }
}