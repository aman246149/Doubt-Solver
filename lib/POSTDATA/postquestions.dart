import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/UI/mainpage.dart';
import 'package:flutter_app/authentication/sign.dart';
import 'package:flutter_app/constant.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:uuid/uuid.dart';

class PostQuestion extends StatefulWidget {
  @override
  _PostQuestionState createState() => _PostQuestionState();
}

class _PostQuestionState extends State<PostQuestion>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  List<String> _class = [
    'Java',
    'c++',
    'python',
    'C',
    'dart',
    'Other',
  ]; // Option 2
  String _selectedClass;

  File _image;
  final picker = ImagePicker();
  bool _saving = false;
  String askquestionbyUser;
  String postId=Uuid().v4();

  selectImage(parentContext) {
    return showDialog(
      context: parentContext,
      builder: (context) {
        return SimpleDialog(
          title: Text("Create Post"),
          children: <Widget>[
            SimpleDialogOption(
              child: Text("Photo with Camera"),
              onPressed: () async {
                Navigator.pop(context);
                PickedFile image = await picker.getImage(
                    source: ImageSource.camera,
                    maxHeight: 675,
                    maxWidth: 960,
                    imageQuality: 25);
                setState(() {
                  _image = File(image.path);
                });
              },
            ),
            SimpleDialogOption(
              child: Text("Image from Gallery"),
              onPressed: () async {
                Navigator.pop(context);
                PickedFile image = await picker.getImage(
                    maxHeight: 675,
                    maxWidth: 960,
                    source: ImageSource.gallery, imageQuality: 25);
                setState(() {
                  _image = File(image.path);
                });
              },
            ),
            SimpleDialogOption(
              child: Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            )
          ],
        );
      },
    );
  }

  final _formKey = GlobalKey<FormState>();

  TextEditingController askQuestion = TextEditingController();

  Future<void> storeDataInFireStore() async {
    setState(() {
      _saving = true;
    });
    StorageUploadTask uploadTask = storageRef
        .child("doubt_images")
        .child("my_image_" + Timestamp.now().seconds.toString())
        .putFile(_image);
    StorageTaskSnapshot storagesnap = await uploadTask.onComplete;
    String imageDownloadUrl = await storagesnap.ref.getDownloadURL();

    postsRef.document(postId).setData({
      "imageurl": imageDownloadUrl,
      "askquestion": askquestionbyUser,
      "programlanguage": _selectedClass,
      "username": currentUser.username,
      "timestamp": timestamp,
      "postId":postId
    });

    setState(() {
      _saving = false;
    });
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => MainScreen()),
        (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _saving,
      color: Colors.green,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF000000),
          centerTitle: true,
          title: KAppBarDoubtAskQuestions,
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(28.0),
            child: ListView(
              children: <Widget>[
                Center(
                  child: _image == null
                      ? GestureDetector(
                          onTap: () {
                            selectImage(context);
                          },
                          child: Row(
                            children: <Widget>[
                              Icon(
                                CupertinoIcons.photo_camera,
                                size: 35,
                                color: Colors.black87,
                              ),
                              AutoSizeText(
                                "Choose an Image",
                                style: TextStyle(
                                    fontSize: 35, color: Colors.green),
                                maxLines: 2,
                              ),
                            ],
                          ))
                      : Image.file(_image),
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 28.0, right: 28.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      askquestionbyUser = value;
                    },
                    decoration: InputDecoration(
                        labelStyle:
                            TextStyle(color: Colors.green, fontSize: 15),
                        hoverColor: Colors.green,
                        focusColor: Colors.green,
                        fillColor: Colors.green,
                        prefixIcon: Icon(
                          CupertinoIcons.bookmark,
                          color: Colors.green,
                        ),
                        labelText: "Ask Your Question"),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 28.0, left: 28.0),
                  child: DropdownButton(
                    style: TextStyle(color: Colors.black87),
                    elevation: 15,
                    focusColor: Colors.green,
                    hint: Text("Choose Your Language"),
                    value: _selectedClass,
                    onChanged: (value) {
                      setState(() {
                        _selectedClass = value;
                      });
                    },
                    items: _class.map((type) {
                      return DropdownMenuItem(
                        child: Text(type),
                        value: type,
                      );
                    }).toList(),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 58.0, right: 58.0, top: 58.0),
                  child: RaisedButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        storeDataInFireStore();
                      }
                    },
                    color: Colors.black87,
                    elevation: 25,
                    focusElevation: 25,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    hoverElevation: 25,
                    child: Text(
                      "Submit",
                      style: TextStyle(
                          color: Colors.white, letterSpacing: 2, fontSize: 20),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
