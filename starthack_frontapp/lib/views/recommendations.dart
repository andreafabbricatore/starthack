import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:starthack_frontapp/views/dashboard.dart';
import 'package:starthack_frontapp/views/detailpage.dart';

import '../service/http_service.dart';
import 'dart:math' as math;

class RecommendationsPage extends StatefulWidget {
  RecommendationsPage({Key? key}) : super(key: key);

  @override
  State<RecommendationsPage> createState() => _RecommendationsPageState();
}

class _RecommendationsPageState extends State<RecommendationsPage> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  List superliked = [];
  Future getSuperLiked() async {
    String response = await HttpService().getfavoritecards();
    print("dashboard!");
    print(jsonDecode(response)['results']);
    setState(() {
      superliked = jsonDecode(response)['results'];
    });
  }

  @override
  void initState() {
    super.initState();
    getSuperLiked();
  }

  @override
  Widget build(BuildContext context) {
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
            'Favorites',
            style: TextStyle(
                fontSize: 30.0,
                color: Colors.deepPurple,
                fontWeight: FontWeight.bold),
          )),
      body: ListView.builder(
        itemCount: superliked.length,
        itemBuilder: (context, index) {
          return index % 2 == 0
              ? FadeInLeft(
                  child: Dismissible(
                    background: Container(color: Colors.red),
                    child: BuildItem(
                        posterurl: superliked[index]['poster_url'],
                        title: superliked[index]['title'],
                        releasedate: superliked[index]['release_date'],
                        genres: superliked[index]['genres'],
                        rating: superliked[index]['rating'],
                        top3cast: superliked[index]['top3_cast'],
                        plot: superliked[index]['plot'],
                        context: context),
                    key: UniqueKey(),
                    direction: DismissDirection.endToStart,
                    onDismissed: (DismissDirection direction) {
                      setState(() async {
                        await HttpService.remfav(superliked[index]['movie_id']);
                        superliked.removeAt(index);
                      });
                    },
                  ),
                  duration: const Duration(milliseconds: 600),
                  from: 400,
                )
              : FadeInRight(
                  child: Dismissible(
                    background: Container(color: Colors.red),
                    child: BuildItem(
                        posterurl: superliked[index]['poster_url'],
                        title: superliked[index]['title'],
                        releasedate: superliked[index]['release_date'],
                        genres: superliked[index]['genres'],
                        rating: superliked[index]['rating'],
                        top3cast: superliked[index]['top3_cast'],
                        plot: superliked[index]['plot'],
                        context: context),
                    key: UniqueKey(),
                    direction: DismissDirection.endToStart,
                    onDismissed: (DismissDirection direction) {
                      setState(() async {
                        await HttpService.remfav(superliked[index]['movie_id']);
                        superliked.removeAt(index);
                      });
                    },
                  ),
                  duration: const Duration(milliseconds: 600),
                  from: 400,
                );
        },
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
                icon: IconButton(
                  icon: Icon(CupertinoIcons.play_arrow),
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                            pageBuilder:
                                ((context, animation, secondaryAnimation) =>
                                    Dashboard()),
                            transitionDuration: Duration.zero,
                            reverseTransitionDuration: Duration.zero));
                  },
                ),
                label: 'shorts',
              ),
              BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.bookmark),
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

Widget BuildItem(
    {required posterurl,
    required title,
    required releasedate,
    required genres,
    required rating,
    required plot,
    required top3cast,
    required context}) {
  return Hero(
    tag: 'G',
    child: InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: ((context) => DetailsPage(
                      title: title,
                      releasedate: releasedate.toString(),
                      posterurl: posterurl,
                      plot: plot,
                      genres: genres,
                      rating: rating,
                      top3cast: top3cast,
                      color: Color.fromARGB(255, 26, 0, 70),
                    ))));
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 10,
        child: Container(
          padding: const EdgeInsets.only(top: 10, bottom: 10, left: 12),
          //height: Get.height * 0.307,
          //width: Get.width * 0.8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Color.fromARGB(255, 153, 0, 133),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 200,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                              overflow: TextOverflow.visible,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(releasedate.toString(),
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15)),
                        SizedBox(height: 10),
                        Text("Genres",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15)),
                        Container(
                          height: 100,
                          width: 200,
                          child: ListView.builder(
                              itemCount: genres.length,
                              itemBuilder: (context, index) {
                                return Text(
                                  genres[index],
                                  style: TextStyle(
                                      color: Colors.white,
                                      overflow: TextOverflow.visible),
                                );
                              }),
                        ),
                        Container(
                          width: 150,
                          child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Text(
                                '${(rating * 10).toInt().toString()}% of people like it',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    overflow: TextOverflow.visible),
                              )),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 150,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        posterurl,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
