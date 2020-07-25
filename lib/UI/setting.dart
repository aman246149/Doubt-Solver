import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/authentication/sign.dart';
import 'package:flutter_app/constant.dart';
import 'dart:io';

import 'package:url_launcher/url_launcher.dart';

class Setting extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {

  _sendMail() async {
    // Android and iOS
    const uri = 'mailto:amanthapliyal14@gmail.com?subject=Greetings&body=Hello%20Bro';
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF000000),

      appBar: AppBar(centerTitle: true,
        backgroundColor: Color(0xFF000000),

        automaticallyImplyLeading: false,
        title: KAppBarDoubtAskSetting,
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(58.0),
            child: GestureDetector(
              onTap: ()
              {
                try{
                  _sendMail();
                  print("tap");

                }
                catch(e)
                {
                }
              },
              child: Row(children: <Widget>[
                CircleAvatar(
                    backgroundColor: Colors.blue.withOpacity(0.3),
                    child: Text("E",style: TextStyle(fontSize: 25,color: Colors.green),)),
                SizedBox(width: 50,),
                AutoSizeText("Email",style: TextStyle(fontSize: 18,color: Colors.white),),
              ],),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left:48.0),
            child: AutoSizeText("Contact us Email for instant support",style: TextStyle(fontSize: 20,color: Colors.green),maxLines: 2,),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.width/2,
          ),
          
          GestureDetector(
            onTap: ()
            {
              googleSignIn.signOut();
            },
            child: Padding(
              padding: const EdgeInsets.all(48.0),
              child: Center(child: Container(
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.3),
                    borderRadius: BorderRadius.all(Radius.circular(20.0))

                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AutoSizeText("SignOut From App",style: TextStyle(color: Colors.green,fontSize: 30),maxLines: 2,),
                  ))),
            ),
          )

        ],
      ),
    );
  }
}
