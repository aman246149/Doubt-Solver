import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/POSTDATA/posttrend.dart';
import 'package:flutter_app/UI/detailstrend.dart';
import 'package:flutter_app/authentication/sign.dart';
import 'package:flutter_app/constant.dart';
import 'package:flutter_app/models/trend.dart';
import 'package:timeago/timeago.dart' as timeago;

class TrendPost extends StatefulWidget {
  @override
  _TrendPostState createState() => _TrendPostState();
}

class _TrendPostState extends State<TrendPost> with SingleTickerProviderStateMixin{
  List<Trend> posts;

  getData()async{
    QuerySnapshot snapshot=await Firestore.instance.collection('trendposts').orderBy('timestamp',descending: false).getDocuments();

    snapshot.documents.forEach((DocumentSnapshot doc){

      setState(() {
        posts=snapshot.documents.map((doc)=>Trend.fromDocument(doc)).toList();
      });
    });

  }

  AnimationController animationController;
  Animation animation;

  @override
  void initState() {
    // TODO: implement initState
    getData();
    animationController=AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    animation=Tween<double>(begin: -1,end: 0).animate(CurvedAnimation(parent: animationController,curve: Curves.elasticInOut));
    animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    animationController.dispose();
    super.dispose();
  }





  @override
  Widget build(BuildContext context) {
    final double width=MediaQuery.of(context).size.width;

    return RefreshIndicator(
      onRefresh:() {
        return  getData();
      },
      child: Scaffold(

        floatingActionButton: Visibility(
         visible: currentUser.username=="aman246149"?true:false,
          child: FloatingActionButton(
            onPressed: ()
            {
              Navigator.push(context, MaterialPageRoute(builder: (context) => PostTrend(),));

            },
            hoverElevation: 25,
            focusColor: Colors.yellowAccent,
            splashColor: Colors.yellowAccent,
            backgroundColor:Colors.blue ,
            child: Icon(Icons.add,size:40 ,color: Colors.white,),
          ),
        ),
        appBar: AppBar(
          backgroundColor: Color(0xFF000000),
          centerTitle: true,
          title: KAppBarDoubtTrend,
        ),
        backgroundColor: Colors.black87,
        body: StreamBuilder<QuerySnapshot>(
            stream: trendposts.orderBy('timestamp',descending: true).snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator(),);
              }
              else {
                return Transform(
                    transform: Matrix4.translationValues(animation.value*width, 0.0, 0.0),

                  child: ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 15, left: 8, right: 8),
                        child: GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailsTrend(detailspost:snapshot.data.documents[index]['askquestion'],imageurl:snapshot.data.documents[index]['imageurl'] ,)));
                          },
                          child: Card(

                            color: Colors.blueGrey,
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(20.0))
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
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

                                    AutoSizeText(
                                      snapshot.data.documents[index]['askquestion'],style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.white),
                                      overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                      minFontSize: 15,
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
                      );
                    },
                  ),
                );
              }
            }
        ),

      ),
    );
  }
}
