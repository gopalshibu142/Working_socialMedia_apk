import 'dart:io';

import 'package:flutter/material.dart';
import "package:image_picker/image_picker.dart";
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:async';
import 'package:shimmer/shimmer.dart';
import 'package:like_button/like_button.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:convert';
import 'package:lottie/lottie.dart';
import 'package:flutter_glow/flutter_glow.dart';

class Global {
  static bool loading = true;
}

uploadImagedb() async {
  final _firebaseStorage = FirebaseStorage.instance;

  if (imgpro != null) {
    var snapshot = await _firebaseStorage
        .ref('profilepics')
        .child(user)
        .putFile(ImgChoose);
    var downloadUrl = await snapshot.ref.getDownloadURL();

    imageUrl = downloadUrl;
  } else {
    print('No Image Path Received');
  }
}

var postcont;
var imageUrl;

late String user = "",
    pass = "",
    sid,
    semail,
    spass,
    sphone,
    sage,
    sgender,
    sname;
String dropdownvalue = 'male', txt = "";
var items = ['male', "female", "transgender"];

Future reLoad() async {
  DatabaseReference ps = FirebaseDatabase.instance.ref("posts");
  DatabaseEvent ps1 = await ps.once();
  //ds.child(sname).child("name").set("testname"

  DataSnapshot event = ps1.snapshot;
  Map mp = event.value as Map;
  Iterable id = mp.keys;
  pid = [];
  users = [];
  content = [];
  times = [];
  plikes = [];

  id.forEach((element) {
    pid.add(element.toString());
  });
  pid.sort();
  pid = List.from(pid.reversed);
  for (int i = 0; i < pid.length; i++) {
    Query qtime = ps.child(pid[i]);
    DataSnapshot snp = await qtime.get();
    Map mp2 = snp.value as Map;

    Iterable t = mp2.values;
    times.insert(i, mp2["time"]);

    users.insert(i, mp2["user"]);

    content.insert(i, mp2["content"]);

    plikes.insert(i, mp2["likes"]);
  }
}

var bpid = [], busers = [], bcontent = [], btimes = [], bplikes = [];

void stateChange() {
  bpid = pid;
  busers = users;
  bcontent = content;
  btimes = times;
  bplikes = plikes;
}

Future<String> getUID(var index) async {
  DatabaseReference ps =
      FirebaseDatabase.instance.ref("posts").child(pid[index]);
  DatabaseEvent ps1 = await ps.once();
  DataSnapshot event = ps1.snapshot;
  Map mp = event.value as Map;
  return mp['user'].toString();
}

Future alertOptions(BuildContext context) async {
  return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text("Choose"),
          children: <Widget>[
            SimpleDialogOption(
              child: TextButton(
                  onPressed: () {},
                  child: Row(
                    children: [Text("Take Picture "), Icon(Icons.camera)],
                  )),
            ),
            SimpleDialogOption(
              child: TextButton(
                  onPressed: () {},
                  child: Row(
                    children: [Text("Choose Image "), Icon(Icons.image)],
                  )),
            )
          ],
        );
      });
}

Future alertFn(String title, msg, context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(msg),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

File ImgChoose = File("assets/addprofile1.png");
File profileImage = File("assets/defaultPerson.png");
ImageProvider imgpro = Image.asset(ImgChoose.path).image;

List users = [];
List content = [];
List pid = [];
List times = [];
List plikes = [];
Image img1 = Image.file(ImgChoose);
var post;
var noofpost;
void snackBar(var text, var msg, var contenttype, context) {
  var content;

  var snackBar = SnackBar(
    /// need to set following properties for best effect of awesome_snackbar_content
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    content: AwesomeSnackbarContent(
      title: text,
      message: 'under developement',

      /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
      contentType: contenttype,
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

 Widget loadingShimmer(context) {
    return Shimmer.fromColors(
        baseColor: Color(0xFF36D1DC),
        highlightColor: Color(0xFF5f23a5),
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: 15,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey,
                ),
                title: Container(
                  height: 25,
                  width: 30,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(4)),
                ),
                subtitle: Container(
                    height: 25,
                    width: 40,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(4))),
              );
            }));
  }
//   DatabaseReference starCountRef =
//         FirebaseDatabase.instance.ref('posts');
// starCountRef.onValue.listen((DatabaseEvent event) {
//     final data = event.snapshot.value;
//     updateStarCount(data);
// });

 
  
  Widget? some;
  