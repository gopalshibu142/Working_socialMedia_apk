// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart' hide Query;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';
import 'dart:io';
import 'screens/home.dart';
import 'package:page_transition/page_transition.dart';
import 'package:loginapp/global.dart';
import 'dart:async';
//import 'package:permission_handler/permission_handler.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  //WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final emulatorHost =
      (!kIsWeb && defaultTargetPlatform == TargetPlatform.android)
          ? '10.0.2.2'
          : 'localhost';

  await FirebaseStorage.instance.useStorageEmulator(emulatorHost, 9199);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with TickerProviderStateMixin {
  bool sign = false;
  bool log = true;
  bool visibilecheck = true;
  var textlabel = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    textlabel.dispose();
    super.dispose();
  }

  Future<String> uploadImage(file) async {
    try {
      TaskSnapshot upload = await FirebaseStorage.instance
          .ref(
              'Profiles/${file.path}-${DateTime.now().toIso8601String()}.${file.extension}')
          .putData(
            file.bytes,
            SettableMetadata(contentType: 'image/${file.extension}'),
          );

      String url = await upload.ref.getDownloadURL();
      return url;
    } catch (e) {
      print('error in uploading image for : ${e.toString()}');
      return '';
    }
  }

  late final AnimationController _controller;
  late PageController pg1;
  int page = 0;
  void initState() {
    super.initState();
    pg1 = PageController(initialPage: page);
    _controller = AnimationController(vsync: this);
  }

  bool signupview = false;
  void signupFN(BuildContext con) async {
    alertFn("title", "msg", context);
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // FirebaseDatabase.instance.goOnline();
    DatabaseReference ds = FirebaseDatabase.instance.ref("Users");

    DatabaseEvent ds1 = await ds.once();

    //ds.child(sname).child("name").set("testname");
    //Stream<DatabaseEvent> stream = ds.onValue;
// Subscribe to the stream!
    sid = sid.toLowerCase();
    if (ds1.snapshot.hasChild(sid)) {
      alertFn("Error", "ID Already exist", context);
      setState(() {
        txt = "UserID Already exist try another";
      });
    } else {
      //uploadImage(ImgChoose);
      ds.child(sid).child("name").set(sname);
      ds.child(sid).child("email").set(semail);
      ds.child(sid).child("password").set(spass);
      ds.child(sid).child("phone").set(sphone);
      ds.child(sid).child("age").set(sage);
      ds.child(sid).child("gender").set(dropdownvalue);
      uploadImagedb();

      setState(() {
        page = 0;
        pg1.animateToPage(page,
            duration: Duration(milliseconds: 200), curve: Curves.easeOutQuad);
      });
      AlertDialog(
        title: Text("Success"),
        content: Text("Registered"),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(con);
              },
              child: Text("ok"))
        ],
      );
      setState(() {
        signupview = false;
      });

      ScaffoldMessenger.of(con)
          .showSnackBar(SnackBar(content: Text("Registered Successfully")));
    }

    snackBar("Text", "ok", ContentType.success, context.owner);
  }

  Future getImage(bool gallery) async {
    ImagePicker picker = ImagePicker();
    PickedFile? pickedFile;
    // Let user select photo from gallery
    if (gallery) {
      pickedFile = await picker.getImage(
        source: ImageSource.gallery,
      );
    }
    // Otherwise open camera to get new photo
    else {
      pickedFile = await picker.getImage(
        source: ImageSource.camera,
      );
    }
    setState(() {
      if (pickedFile != null) {
        //setState() {
        ImgChoose = File(pickedFile.path);
        imgpro = Image.file(ImgChoose).image;
        // Use if you only need a single picture
      } else {
        print('No image selected.');
      }
    });
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'app with login',
      home: Scaffold(
        body: PageView(
          controller: pg1,
          children: [
            Stack(
              children: [
                Container(
                    decoration:
                        const BoxDecoration(color: Color(0xffFF0E0F26))),
                SafeArea(
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                    decoration:
                                        BoxDecoration(color: Color(0xFF0E0F26)),
                                    width: 40,
                                    height: 40,
                                    child: Image.asset("assets/logo.png")),
                                Row(
                                  children: const [
                                    Text(
                                      "login",
                                      style: TextStyle(
                                          color: Color(0xFF36D1DC),
                                          fontSize: 18),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    )
                                  ],
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const WelcomeText(),
                            const SizedBox(height: 20),
                            Container(
                              width: 350,
                              child: Column(
                                children: [
                                  TextField(
                                    style: TextStyle(color: Colors.white38),
                                    keyboardType: TextInputType.emailAddress,
                                    onChanged: (temp) {
                                      user = temp.toLowerCase();
                                    },
                                    decoration: const InputDecoration(
                                        hintText: "Enter your UserID",
                                        hintStyle:
                                            TextStyle(color: Colors.white38),
                                        labelText: "userID",
                                        labelStyle: TextStyle(
                                            color: Color(0xff5f23a5))),
                                    controller: textlabel,
                                  ),
                                  password(),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      TextButton(
                                          onPressed: () {
                                            print("hello");
                                            alertFn("reg", "msg", context);
                                            setState(() {
                                              page = 1;
                                              pg1.animateToPage(page,
                                                  duration: const Duration(
                                                      milliseconds: 400),
                                                  curve: Curves.easeOutQuad);
                                            });
                                          },
                                          child: Text(
                                            "sign up",
                                            style: TextStyle(
                                                color: Color(0xFF6CC1FA)),
                                          )),
                                      signinbutton(),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _controller.forward();
                                      });
                                    },
                                    child: Container(
                                        height: 250,
                                        child: Lottie.asset(
                                          "assets/hi.json",
                                          controller: _controller,
                                          onLoaded: (composition) {
                                            // Configure the AnimationController with the duration of the
                                            // Lottie file and start the animation.
                                            _controller
                                              ..duration = composition.duration
                                              ..repeat();

                                            //..forward(from: 0.0)
                                          },
                                        )),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(color: Color(0xFF0E0F26)),
                ),
                WidgetSignup(context)
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget WidgetSignup(BuildContext context1) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(color: Color(0xFF0E0F26)),
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Text(
              "Create an account",
              style: TextStyle(color: Color(0xFF36D1DC)),
            ),
            SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                alertOptions(context1);
                getImage(true);
              },
              child: Container(
                  width: 80,
                  height: 80,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Color(0xFF36D1DC),
                    child: CircleAvatar(
                      radius: 39,
                      backgroundImage: imgpro,
                      backgroundColor: Color(0xFF5f23a5),
                    ),
                  )),
            ),
            Text(txt, style: TextStyle(color: Color.fromARGB(255, 244, 3, 3))),
            SizedBox(
              height: 10,
            ),
            Container(
              width: 250,
              child: TextField(
                keyboardType: TextInputType.name,
                onChanged: (temp) {
                  sid = temp;
                },
                decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    hintText: "Enter your Username",
                    labelText: "userID",
                    labelStyle: TextStyle(color: Color(0xFF5f23a5))),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              width: 250,
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                onChanged: (temp) {
                  semail = temp;
                },
                decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    hintText: "Enter your Email",
                    labelText: "Email",
                    labelStyle: TextStyle(color: Color(0xFF5f23a5))),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              width: 250,
              child: TextField(
                obscureText: visibilecheck,
                onChanged: (temp) {
                  spass = temp;
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    hintText: "Enter your Password",
                    labelText: "Password",
                    suffixIcon: IconButton(
                        color: Color(0xFF5f23a5),
                        onPressed: () {
                          setState(() {
                            visibilecheck = !visibilecheck;
                          });
                        },
                        icon: visibilecheck
                            ? Icon(Icons.visibility)
                            : Icon(Icons.visibility_off)),
                    labelStyle: TextStyle(color: Color(0xFF5f23a5))),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              width: 250,
              child: TextField(
                keyboardType: TextInputType.name,
                onChanged: (temp) {
                  sname = temp;
                },
                decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    hintText: "Enter your Full Name",
                    labelText: "Name",
                    labelStyle: TextStyle(color: Color(0xFF5f23a5))),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              width: 250,
              child: TextField(
                keyboardType: TextInputType.phone,
                onChanged: (temp) {
                  sphone = temp;
                },
                decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    hintText: "Enter your Phone",
                    labelText: "Phone no",
                    labelStyle: TextStyle(color: Color(0xFF5f23a5))),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              width: 250,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Age :", style: TextStyle(color: Color(0xFF5f23a5))),
                  Container(
                    width: 55,
                    child: TextField(
                        onChanged: (temp) {
                          sage = temp;
                        },
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          labelText: "age",
                          labelStyle: TextStyle(color: Colors.white38),
                        )),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              width: 250,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Gender",
                    style: TextStyle(color: Color(0xFF5f23a5)),
                  ),
                  DropdownButton(
                    dropdownColor: Color(0xFF0E0F26),
                    // Initial Value
                    value: dropdownvalue,

                    // Down Arrow Icon
                    icon: const Icon(Icons.keyboard_arrow_down),

                    // Array list of items
                    items: items.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(
                          items,
                          style: TextStyle(color: Colors.white38),
                        ),
                      );
                    }).toList(),
                    // After selecting the desired option,it will
                    // change button value to selected value
                    onChanged: (newValue) {
                      setState(() {
                        dropdownvalue = newValue.toString();
                      });
                    },
                  ),
                ],
              ),
            ),
            Container(
              width: 268,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        onPressed: () {
                          setState(() {
                            ImgChoose = File("assets/addprofile1.png");
                            imgpro = Image.asset(ImgChoose.path).image;
                            page = 0;
                            pg1.animateToPage(page,
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.easeOutCirc);
                          });
                          page = 0;
                        },
                        child: Text(
                          "Cancel",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Color(0xFF36D1DC),
                          ),
                        )),
                    Container(
                      height: 35,
                      width: 80,
                      child: DecoratedBox(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: const <BoxShadow>[
                                BoxShadow(
                                    color: Color.fromRGBO(
                                        0, 0, 0, 0.57), //shadow for button
                                    blurRadius: 5) //blur radius of shadow
                              ],
                              gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Color(0xFF302399),
                                    Color(0xFF5f23a5)
                                  ])),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.transparent,
                                onSurface: Colors.transparent,
                                shadowColor: Colors.transparent,
                                //make color or elevated button transparent
                              ),
                              onPressed: () {
                                signupFN(context1);
                              },
                              child: Padding(
                                padding: EdgeInsets.only(
                                  top: 0,
                                  bottom: 0,
                                ),
                                child: Text(
                                  "Signup",
                                  style: TextStyle(color: Color(0xFF36D1DC)),
                                ),
                              ))),
                    )
                  ]),
            )
          ]),
        ),
      ),
    );
  }

  TextField password() {
    return TextField(
      style: TextStyle(color: Colors.white38),
      obscureText: visibilecheck,
      onChanged: (temp) {
        pass = temp;
      },
      decoration: InputDecoration(
          hintText: "Enter your password",
          hintStyle: TextStyle(color: Colors.white),
          labelText: 'password',
          labelStyle: TextStyle(color: Color(0xFF5f23a5)),
          suffixIcon: IconButton(
              color: Color(0xff5f23a5),
              onPressed: () {
                setState(() {
                  visibilecheck = !visibilecheck;
                });
              },
              icon: visibilecheck
                  ? Icon(Icons.visibility)
                  : Icon(Icons.visibility_off))),
    );
  }
}

class Variables {
  bool loading = false;
}

class signinbutton extends StatefulWidget {
  const signinbutton({
    Key? key,
  }) : super(key: key);

  @override
  State<signinbutton> createState() => _signinbuttonState();
}

class _signinbuttonState extends State<signinbutton> {
  void loginFn() async {
    DateTime dt = DateTime.now();
    Map a;
    String inpass, inuser, name;
    DatabaseReference ds = FirebaseDatabase.instance.ref("Users");

    DatabaseEvent ds1 = await ds.once();

    //ds.child(sname).child("name").set("testname");
    Stream<DatabaseEvent> stream = ds.onValue;
    DatabaseReference ps = FirebaseDatabase.instance.ref("posts");
    DatabaseEvent ps1 = await ps.once();
    //ds.child(sname).child("name").set("testname"

    reLoad();
    setState(() {
      stateChange();
    });
    // print(event);
    // Map ab = event.value as Map;

    // users = [];
    // content = [];
    // setState(() {

    //   });
    // });
// Subscribe to the stream!
    stream.listen((DatabaseEvent event) {
      if (user == "" || user == null) {
        alertFn("Error", "Enter Username", context);
      } else {
        inuser = ds1.snapshot.child(user).child("mail").value.toString();
        name = ds1.snapshot.child(user).child("name").value.toString();
        inpass = ds1.snapshot.child(user).child("password").value.toString();

        if (ds1.snapshot.hasChild(user)) {
          if (inpass == pass) {
            setState(() {
              stateChange();
            });
            Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.size,
                  alignment: Alignment.bottomCenter,
                  child: homepage(),
                  inheritTheme: true,
                  ctx: context),
            );
          } else
            alertFn("Error", "Incorrect password", context);
        } else
          alertFn("Error", "Incorrect username", context);

        // DatabaseEventType.value;
      }
    });
  }

  Future sleep1() async =>
      Future.delayed(const Duration(seconds: 4), () => "1");
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      child: DecoratedBox(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: const <BoxShadow>[
                BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.57), //shadow for button
                    blurRadius: 5) //blur radius of shadow
              ],
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Color(0xFF302399), Color(0xFF5f23a5)])),
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.transparent,
                onSurface: Colors.transparent,
                shadowColor: Colors.transparent,
                //make color or elevated button transparent
              ),
              onPressed: () {
                loginFn();
              },
              child: Padding(
                padding: EdgeInsets.only(
                  top: 0,
                  bottom: 0,
                ),
                child: Text(
                  "Login",
                  style: TextStyle(color: Color(0xFF36D1DC)),
                ),
              ))),
    );
  }
}

class WelcomeText extends StatelessWidget {
  const WelcomeText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: const TextSpan(
        text: 'Welcome Back,',
        style: TextStyle(
          color: Colors.white54,
          fontSize: 36,
        ),
        children: [
          TextSpan(
            text: '\nUser',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 38,
              color: Colors.white60,
            ),
          )
        ],
      ),
    );
  }
}
