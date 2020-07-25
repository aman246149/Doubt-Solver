import 'package:cloud_firestore/cloud_firestore.dart';

class Trend
{
  String askquestion;
  String imageurl;
  String programlanguage;
  Timestamp timestamp;
  String username;

  Trend({this.askquestion, this.imageurl, this.programlanguage,
    this.timestamp, this.username});

  factory Trend.fromDocument(DocumentSnapshot doc)
  {
    return Trend(
        askquestion: doc['askquestion'],
        imageurl: doc['imageurl'],
        programlanguage: doc['programlanguage'],
        timestamp: doc['timestamp'],
        username: doc['username']
    );
  }
}