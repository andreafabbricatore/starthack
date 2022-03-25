import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:starthack_frontapp/service/http_service.dart';
import 'package:starthack_frontapp/views/dashboard.dart';
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

class MatchPage extends StatefulWidget {
  final List content;
  const MatchPage({Key? key, required this.content}) : super(key: key);

  @override
  _MatchPageState createState() => _MatchPageState();
}

class _MatchPageState extends State<MatchPage> {
  bool isLoading = true;
  late List usersData;
  final List<SwipeItem> _swipeItems = <SwipeItem>[];
  MatchEngine? _matchEngine;
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  Future setData() async {
    setState(() {
      usersData = widget.content;

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
    }); // setState
  } // getData

  @override
  void initState() {
    setData();
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
      backgroundColor: Color.fromARGB(255, 245, 23, 215),
      key: _scaffoldKey,
      appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Color.fromARGB(255, 245, 23, 215)),
          elevation: 0.0,
          backgroundColor: Color.fromARGB(255, 245, 23, 215),
          toolbarHeight: 100.0,
          titleSpacing: 36.0,
          centerTitle: true,
          title: Text(
            'A similar user\nLOVES these 3...',
            style: TextStyle(
              fontSize: 27.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
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
                                  shadowColor: Color.fromARGB(255, 146, 137, 3),
                                  elevation: 12.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24.0),
                                  ),
                                  color: Color.fromARGB(255, 153, 0, 133),
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
                                                        255, 153, 0, 133),
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
                                                    trailerurl: usersData[index]
                                                        ['trailer_url'],
                                                    color: Color.fromARGB(
                                                        255, 153, 0, 133),
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
                                                            builder:
                                                                ((context) =>
                                                                    DetailsPage(
                                                                      title: usersData[
                                                                              index]
                                                                          [
                                                                          'title'],
                                                                      releasedate:
                                                                          usersData[index]['release_date']
                                                                              .toString(),
                                                                      posterurl:
                                                                          usersData[index]
                                                                              [
                                                                              'poster_url'],
                                                                      plot: usersData[
                                                                              index]
                                                                          [
                                                                          'plot'],
                                                                      genres: usersData[
                                                                              index]
                                                                          [
                                                                          'genres'],
                                                                      rating: usersData[
                                                                              index]
                                                                          [
                                                                          'rating'],
                                                                      top3cast:
                                                                          usersData[index]
                                                                              [
                                                                              'top3_cast'],
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          153,
                                                                          0,
                                                                          133),
                                                                    ))));
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
                            Navigator.pushReplacement(
                                context,
                                PageRouteBuilder(
                                    pageBuilder: ((context, animation,
                                            secondaryAnimation) =>
                                        Dashboard()),
                                    transitionDuration: Duration.zero,
                                    reverseTransitionDuration: Duration.zero));
                            _scaffoldKey.currentState!
                                .showSnackBar(const SnackBar(
                              content: Text("Stack Finished"),
                              duration: Duration(milliseconds: 500),
                            ));
                          },
                          itemChanged: (SwipeItem item, int index) async {
                            print(
                                "item: ${usersData[index]['title']}, index: ${usersData[index]['movie_id']}");
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
            backgroundColor: Color.fromARGB(255, 245, 23, 215),
            showSelectedLabels: false,
            showUnselectedLabels: false,
            selectedItemColor: Color.fromARGB(0, 255, 255, 255),
            unselectedItemColor: Color.fromARGB(0, 255, 255, 255),
            iconSize: 24.0,
            enableFeedback: true,
            mouseCursor: MouseCursor.uncontrolled,
            elevation: 0.0,
            onTap: null,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.star),
                label: 'home',
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.star),
                label: 'search',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
