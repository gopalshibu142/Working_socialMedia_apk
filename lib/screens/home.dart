import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:water_drop_nav_bar/water_drop_nav_bar.dart';
import 'package:loginapp/global.dart';

import 'package:shimmer/shimmer.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart' hide Query;
import 'dart:async';

class homepage extends StatefulWidget {
  homepage({Key? key}) : super(key: key);

  @override
  _homepageState createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    changeWid();
    pageController = PageController(initialPage: selectedIndex);
  }

  Future? changeWid() {
    setState(() {
      some = loadingShimmer(context);
    });
    
    reLoad().then((value) => setState(() {
                stateChange();
          some = postField(context);
        }));
  }

  int selectedIndex = 0;
  //PageController pageController= PageController();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Home page",
      home: Scaffold(
        appBar: AppBar(backgroundColor: Color(0xFF0E0F26), actions: [
          IconButton(
            onPressed: () async {},
            icon: CircleAvatar(
              backgroundImage: FileImage(ImgChoose),
            ),
          ),
          Spacer(),
          TextButton(
            onPressed: () async {
              changeWid();

              
            },
            child: const GlowText(
              "VazhaThopp",
              glowColor: Colors.blue,
              blurRadius: 5,
              style: TextStyle(color: Colors.black, fontSize: 28),
            ),
          ),
          Spacer(),
        ]),
        bottomNavigationBar: WaterDropNavBar(
          waterDropColor: Color(0xFF36D1DC),
          backgroundColor: Color(0xFF0E0F26),
          barItems: [
            BarItem(
                filledIcon: Icons.home_filled,
                outlinedIcon: Icons.home_outlined),
            BarItem(
                filledIcon: Icons.favorite,
                outlinedIcon: Icons.favorite_outline_outlined),
            BarItem(
                filledIcon: Icons.person, outlinedIcon: Icons.person_outline),
          ],
          selectedIndex: selectedIndex,
          onItemSelected: (index) {
            setState(() {
              selectedIndex = index;
            });
            pageController.animateToPage(selectedIndex,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutQuad);
          },
        ),
        body: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: pageController,
          children: [
            feed(),
            notifications(),
            profile(),
          ],
        ),
      ),
    );
  }

  Widget DrawerContents(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF36D1DC), Color(0xFF5B86E5)])),
        ),
      ],
    );
  }
}

Widget postField(context) {
  return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: bpid.length,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: [
            SizedBox(),
            GlowContainer(
              glowColor: Color.fromARGB(255, 124, 54, 244),
              blurRadius: 10,
              child: Container(
                height: 150,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF3023996), Color(0xFF0E0F26)])),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Container(
                              padding: EdgeInsets.all(5),
                              child: Text(busers[index])),
                          Spacer(),
                          Container(
                              padding: EdgeInsets.all(5),
                              child: Text(btimes[index]))
                        ],
                      ),
                      Container(
                          alignment: Alignment.center,
                          width: 350,
                          child: Text('${bcontent[index]}')),
                      Row(
                        children: [
                          SizedBox(
                            width: 50,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.all(5),
                            child: LikeButton(
                              mainAxisAlignment: MainAxisAlignment.start,
                              size: 25,
                              circleColor: CircleColor(
                                  start: Color(0xFF5f23a5),
                                  end: Color(0xFF5f23a5)),
                              bubblesColor: BubblesColor(
                                dotPrimaryColor: Colors.red,
                                dotSecondaryColor: Color(0xFF5f23a5),
                              ),
                              likeCount: int.parse(bplikes[index]),
                            ),
                          ),
                        ],
                      )
                    ]),
              ),
            ),
            SizedBox(
              height: 10,
            )
          ],
        );
      });
}

class profile extends StatelessWidget {
  const profile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF36D1DC), Color(0xFF5B86E5)])),
        ),
        FloatingActionButton(
          onPressed: () {},
          child: Icon(Icons.play_arrow),
        )
      ],
    );
  }
}

class notifications extends StatelessWidget {
  const notifications({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                Color.fromARGB(255, 122, 42, 42),
                Color(0xFF5B86E5)
              ])),
        ),
      ],
    );
  }
}

class feed extends StatefulWidget {
  feed({Key? key}) : super(key: key);

  @override
  State<feed> createState() => _feedState();
}

class _feedState extends State<feed> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          decoration: const BoxDecoration(color: Color(0xFF0E0F26)),
          child: Container(
            child: some,
          ),
        ),
        FloatingActionButton(
          backgroundColor: Color(0xFF0E0F26),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) => _buildPopupDialog(context),
            );
          },
          hoverColor: Colors.red,
          child: Icon(Icons.edit),
          enableFeedback: true,
        )
      ],
    );
  }

  Widget _buildPopupDialog(context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              width: 350,
              height: 150,
              child: TextField(
                onChanged: (value) => postcont = value,
              )),
          ElevatedButton(
              onPressed: () async {
                DateTime dt = DateTime.now();
                var id = dt
                    .toString()
                    .replaceAll(".", "")
                    .replaceAll(" ", "")
                    .replaceAll("-", "")
                    .replaceAll(":", "");

                DatabaseReference dref = FirebaseDatabase.instance.ref("posts");
                DatabaseEvent ps1 = await dref.once();
                int i = 0;
                dref.child(id).child("user").set(user);
                dref.child(id).child("content").set(postcont);
                dref.child(id).child("time").set("${dt.hour}:${dt.minute}");
                dref.child(id).child("likes").set("0");
                Navigator.pop(context);
                setState(() {
      some = loadingShimmer(context);
    });
    
    reLoad().then((value) => setState(() {
                stateChange();
          some = postField(context);
        }));
               
              },
              child: Text("post"))
        ],
      ),
    );
  }
}
