import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/POSTDATA/postquestions.dart';
import 'package:flutter_app/UI/chatscreen.dart';
import 'package:flutter_app/authentication/sign.dart';
import 'package:flutter_app/constant.dart';
import 'package:flutter_app/models/doubtpost.dart';
import 'package:image_picker/image_picker.dart';
import 'package:timeago/timeago.dart' as timeago;

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>  with SingleTickerProviderStateMixin{

  AnimationController animationController;
  Animation animation;

  List<DoubtPost> posts;

  getData()async{
    QuerySnapshot snapshot=await Firestore.instance.collection('posts').orderBy('timestamp',descending: false).getDocuments();

    snapshot.documents.forEach((DocumentSnapshot doc){

      setState(() {
        posts=snapshot.documents.map((doc)=>DoubtPost.fromDocument(doc)).toList();
      });
    });

  }

  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
    animationController=AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    animation=Tween<double>(begin: -1,end: 0).animate(CurvedAnimation(parent: animationController,curve: Curves.elasticInOut));
//    animationright=Tween<double>(begin: 1,end: 0).animate(CurvedAnimation(parent: animationController,curve: Curves.fastLinearToSlowEaseIn));


    animationController.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width=MediaQuery.of(context).size.width;
    return AnimatedBuilder(
      animation: animationController,

      builder: (context, child) {
        return  RefreshIndicator(
          onRefresh:() {
            return  getData();
          },
          child: Scaffold(
            floatingActionButton: FloatingActionButton(
              elevation: 20,

              foregroundColor: Color(0xFF000000),
              onPressed: ()
              {
                Navigator.push(context, MaterialPageRoute(builder: (context) => PostQuestion(),));

              },
              hoverElevation: 25,
              focusColor: Colors.yellowAccent,
              splashColor: Colors.yellowAccent,
              backgroundColor:Color(0xFF000000) ,
              child: Icon(Icons.add,size:40 ,color: Colors.white,),
            ),
            appBar: AppBar(
              backgroundColor: Color(0xFF000000),
              centerTitle: true,
              title: KAppBarDoubtSolver,
            ),
            backgroundColor: Colors.black87,
            body: StreamBuilder<QuerySnapshot>(
                stream: postsRef.orderBy('timestamp',descending: true).snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator(),);
                  }
                  else {
                    return ListView.builder(
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 15, left: 8, right: 8),
                          child: GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatScreen(postId:snapshot.data.documents[index]['postId'],askquestion:snapshot.data.documents[index]['askquestion'])));
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(bottom:8.0),
                              child: Transform(
                                transform: Matrix4.translationValues(animation.value*width, 0.0, 0.0),
                                child: Card(

                                  color: Colors.blue.withOpacity(0.3),
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(20.0))
                                  ),
                                  child: Container(
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          height: 200,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: NetworkImage(snapshot.data.documents[index]['imageurl'])
                                              )
                                          ),
                                        ),
                                        SizedBox(height: 15,),

                                        Padding(
                                          padding: const EdgeInsets.only(left:8.0,right: 8.0),
                                          child: AutoSizeText(

                                            snapshot.data.documents[index]['askquestion'],style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.white),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            minFontSize: 15,
                                          ),
                                        ),


                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8.0, top: 8, bottom: 8),
                                          child: Row(

                                            children: <Widget>[

                                              SizedBox(width: 30,),
                                              Icon(Icons.comment,color: Colors.white,),
                                              SizedBox(width: 200,),
                                              Text(
                                                timeago.format(snapshot.data.documents[index]['timestamp'].toDate()),style: TextStyle(color: Colors.white),
                                              )
                                            ],
                                          ),
                                        ),


                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                }
            ),

          ),
        );
      },
    );
  }
}
