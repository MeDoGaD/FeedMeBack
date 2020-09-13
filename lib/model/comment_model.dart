
class Comment {
  String commentID;
  String authorID;
  String authorName;
  String text;
  String date;
  Comment(this.authorID,this.authorName,this.text,{this.commentID, this.date});
}