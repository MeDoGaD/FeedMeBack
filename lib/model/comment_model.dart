
class Comment {
  String commentID;
  String authorID;
  String authorName;
  String text;
  String date;
//  int commentIndex;
  Comment(this.authorID,this.authorName,this.text,{this.commentID, this.date});
}