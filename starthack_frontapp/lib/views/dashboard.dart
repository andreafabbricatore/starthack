import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:starthack_frontapp/service/http_service.dart';
import 'package:starthack_frontapp/views/match.dart';
import 'package:starthack_frontapp/views/recommendations.dart';
import 'package:starthack_frontapp/views/shorts.dart';
import 'package:starthack_frontapp/views/trailers.dart';
import 'package:swipe_cards/draggable_card.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'package:flutter/cupertino.dart';

import 'detailpage.dart';
import 'package:http/http.dart' as http;

class Content {
  final String? text;
  
  Content({this.text});
}

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool isLoading = true;
  late List usersData;
  final List<SwipeItem> _swipeItems = <SwipeItem>[];
  MatchEngine? _matchEngine;
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  late String response;

  Future getData() async {
    return await HttpService().getnextcards();
  } // getData

  void createCards(response, data) {
    if (jsonDecode(response)['match'] == true) {
      Navigator.of(context).pushReplacement(_createRoute(data));
    } else {
      setState(() {
        usersData = data;

        if (usersData.isNotEmpty) {
          for (int i = 0; i < usersData.length; i++) {
            _swipeItems.add(SwipeItem(
                // content: Content(text: _names[i], color: _colors[i]),
                content: Content(text: usersData[i]['title']),
                likeAction: () async {
                  await HttpService.sendop(usersData[i]['movie_id'], 'right');
                  _scaffoldKey.currentState?.showSnackBar(const SnackBar(
                    content: Text("Liked "),
                    //  content: Text("Liked ${_names[i]}"),
                    duration: Duration(milliseconds: 500),
                  ));
                },
                nopeAction: () async {
                  await HttpService.sendop(usersData[i]['movie_id'], 'left');
                  _scaffoldKey.currentState?.showSnackBar(SnackBar(
                    content: Text("Nope ${usersData[i]['title']}"),
                    duration: const Duration(milliseconds: 500),
                  ));
                },
                superlikeAction: () async {
                  await HttpService.sendop(usersData[i]['movie_id'], 'up');
                  _scaffoldKey.currentState?.showSnackBar(SnackBar(
                    content: Text("Superliked ${usersData[i]['title']}"),
                    duration: const Duration(milliseconds: 500),
                  ));
                },
                onSlideUpdate: (SlideRegion? region) async {
                  print("Region $region");
                }));
          } //for loop
          _matchEngine = MatchEngine(swipeItems: _swipeItems);
          isLoading = false;
        } //if
      });
    } // setState
  }

  void initCards() async {
    response = await getData();
    createCards(response, jsonDecode(response)['results']);
  }

  @override
  void initState() {
    initCards();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp
    ]);
    return Scaffold(
      extendBody: false,
      backgroundColor: Color.fromARGB(255, 26, 0, 70),
      key: _scaffoldKey,
      appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Color.fromARGB(255, 26, 0, 70)),
          elevation: 0.0,
          backgroundColor: Color.fromARGB(255, 26, 0, 70),
          toolbarHeight: 50.0,
          titleSpacing: 36.0,
          title: const Text(
            'Discover',
            style: TextStyle(
                fontSize: 30.0,
                color: Colors.deepPurple,
                fontWeight: FontWeight.bold),
          )),
      body: Container(
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : Stack(
                children: <Widget>[
                  Positioned(
                    child: Container(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: SwipeCards(
                          matchEngine: _matchEngine!,
                          itemBuilder: (BuildContext context, int index) {
                            return Stack(
                              fit: StackFit.expand,
                              children: <Widget>[
                                Card(
                                  margin: const EdgeInsets.all(16.0),
                                  shadowColor: Colors.deepPurple,
                                  elevation: 12.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24.0),
                                  ),
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  child: FittedBox(
                                    fit: BoxFit.fill,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(24.0),
                                      child: Image.network(
                                          usersData[index]['poster_url']),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  left: MediaQuery.of(context).size.width / 2,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                              pageBuilder: ((context, animation,
                                                      secondaryAnimation) =>
                                                  ShortsPage(
                                                    shortslist: usersData[index]
                                                        ['shorts_urls'],
                                                    color: Color.fromARGB(
                                                        255, 26, 0, 70),
                                                  )),
                                              transitionDuration: Duration.zero,
                                              reverseTransitionDuration:
                                                  Duration.zero));
                                    },
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height,
                                      width:
                                          MediaQuery.of(context).size.width / 2,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  left: 0,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                              pageBuilder: ((context, animation,
                                                      secondaryAnimation) =>
                                                  TrailerPage(
                                                      trailerurl:
                                                          usersData[index]
                                                              ['trailer_url'],
                                                      color: Color.fromARGB(
                                                          255, 26, 0, 70))),
                                              transitionDuration: Duration.zero,
                                              reverseTransitionDuration:
                                                  Duration.zero));
                                    },
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height,
                                      width:
                                          MediaQuery.of(context).size.width / 2,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 430,
                                  child: Container(
                                    // alignment: Alignment.bottomCenter,
                                    height: 50.0,
                                    width: MediaQuery.of(context).size.width *
                                        0.87,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        color: Color.fromARGB(204, 2, 0, 0)),
                                    margin: const EdgeInsets.fromLTRB(
                                        24.0, 40.0, 24.0, 24.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Flexible(
                                          child: Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: FittedBox(
                                              fit: BoxFit.fitWidth,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: TextButton.icon(
                                                  onPressed: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: ((context) => DetailsPage(
                                                                title: usersData[index]
                                                                    ['title'],
                                                                releasedate:
                                                                    usersData[index]['release_date']
                                                                        .toString(),
                                                                posterurl: usersData[index][
                                                                    'poster_url'],
                                                                plot: usersData[index]
                                                                    ['plot'],
                                                                genres: usersData[index]
                                                                    ['genres'],
                                                                rating: usersData[index]
                                                                    ['rating'],
                                                                top3cast: usersData[index][
                                                                    'top3_cast'],
                                                                color: Color.fromARGB(
                                                                    255,
                                                                    26,
                                                                    0,
                                                                    70)))));
                                                  },
                                                  icon: Icon(
                                                    CupertinoIcons.info,
                                                    color: Colors.white,
                                                    size: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.1,
                                                  ),
                                                  label: Text(
                                                    usersData[index]["title"] +
                                                        ", " +
                                                        usersData[index]
                                                                ["release_date"]
                                                            .toString(),
                                                    maxLines: 1,
                                                    softWrap: false,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 25,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      overflow:
                                                          TextOverflow.visible,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                          onStackFinished: () {
                            _scaffoldKey.currentState!
                                .showSnackBar(const SnackBar(
                              content: Text("Stack Finished"),
                              duration: Duration(milliseconds: 500),
                            ));
                          },
                          itemChanged: (SwipeItem item, int index) async {
                            print(
                                "item: ${usersData[index]['title']}, index: ${usersData[index]['movie_id']}");
                            if (index == usersData.length - 2) {
                              print("need to req again");
                              setState(() async {
                                response = await getData();
                              });
                            }
                            if (index == usersData.length - 1) {
                              print("assigning new reg");
                              setState(() {
                                createCards(
                                    response, jsonDecode(response)['results']);
                              });
                            }
                          },
                          upSwipeAllowed: true,
                          fillSpace: true,
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 10,
                                      color: Colors.black,
                                      spreadRadius: 2)
                                ],
                              ),
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                child: IconButton(
                                  icon: const Icon(
                                    CupertinoIcons.clear,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    _matchEngine!.currentItem?.nope();
                                  },
                                  // child: const Text("Nope"),
                                ),
                              ),
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 10,
                                      color: Colors.black,
                                      spreadRadius: 2)
                                ],
                              ),
                              child: CircleAvatar(
                                radius: 36.0,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  radius: 32.0,
                                  backgroundColor: Colors.deepPurple,
                                  child: IconButton(
                                    padding: EdgeInsets.zero,
                                    icon: Icon(
                                      Icons.star,
                                      color: Colors.white,
                                      size: 40.0,
                                    ),
                                    onPressed: () {
                                      _matchEngine!.currentItem?.superLike();
                                    },
                                    //child: const Text("Superlike"),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 10,
                                      color: Colors.black,
                                      spreadRadius: 2)
                                ],
                              ),
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                child: IconButton(
                                  icon: const Icon(
                                    CupertinoIcons.heart_fill,
                                    color: Colors.lightGreen,
                                  ),
                                  onPressed: () {
                                    _matchEngine!.currentItem?.like();
                                  },
                                  //  child: const Text("Like"),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Color.fromARGB(255, 26, 0, 70),
            showSelectedLabels: false,
            showUnselectedLabels: false,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white,
            iconSize: 24.0,
            enableFeedback: true,
            mouseCursor: MouseCursor.uncontrolled,
            elevation: 16.0,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.home),
                label: 'home',
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.search),
                label: 'search',
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.play_arrow),
                label: 'shorts',
              ),
              BottomNavigationBarItem(
                  icon: IconButton(
                    icon: Icon(CupertinoIcons.bookmark),
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                              pageBuilder:
                                  ((context, animation, secondaryAnimation) =>
                                      RecommendationsPage()),
                              transitionDuration: Duration.zero,
                              reverseTransitionDuration: Duration.zero));
                    },
                  ),
                  label: 'recommendations'),
              BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.profile_circled), label: "profile")
            ],
          ),
        ),
      ),
    );
  }
}

Route _createRoute(data) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => MatchPage(
      content: data,
    ),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
