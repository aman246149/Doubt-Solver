import 'package:cloud_firestore/cloud_firestore.dart';

class DoubtPost
{
  String askquestion;
  String imageurl;
  String programlanguage;
  Timestamp timestamp;
  String username;
  String postId;

  DoubtPost({this.askquestion, this.imageurl, this.programlanguage,
      this.timestamp, this.username,this.postId});

  factory DoubtPost.fromDocument(DocumentSnapshot doc)
  {
    return DoubtPost(
      askquestion: doc['askquestion'],
      imageurl: doc['imageurl'],
      programlanguage: doc['programlanguage'],
      timestamp: doc['timestamp'],
      username: doc['username'],
        postId:doc['postId']
    );
  }
}