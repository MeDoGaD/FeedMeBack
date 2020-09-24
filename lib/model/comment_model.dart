
class Comment {
  String commentID;
  String authorID;
  String authorName;
  String text;
  int date;
//  int commentIndex;
  Comment(this.authorID,this.authorName,this.text,{this.commentID, this.date});
}