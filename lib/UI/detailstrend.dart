import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DetailsTrend extends StatefulWidget {
 final String detailspost,imageurl;

  const DetailsTrend({ this.detailspost,this.imageurl}) ;

  @override
  _DetailsTrendState createState() => _DetailsTrendState();
}

class _DetailsTrendState extends State<DetailsTrend> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xFF000000),
        title: AutoSizeText(
          "TREND NEWS",style: TextStyle(fontFamily: 'Source Serif Pro',color: Colors.white,fontSize: 35),
          maxLines: 2,
        ),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height/3.4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20.0),bottomRight: Radius.circular(20.0)),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(widget.imageurl)
              )
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: AutoSizeText(
                widget.detailspost,style: TextStyle(color: Colors.black,fontSize: 22,fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }
}
