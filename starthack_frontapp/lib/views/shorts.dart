import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class ShortsPage extends StatefulWidget {
  final List shortslist;
  final Color color;
  const ShortsPage({Key? key, required this.shortslist, required this.color})
      : super(key: key);

  @override
  State<ShortsPage> createState() => _ShortsPageState();
}

class _ShortsPageState extends State<ShortsPage> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  String videourl = "";

  //final videoPlayerController = VideoPlayerController.network(
  //'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4');

  int index = 0;

  ChewieController createChewieController(videourl) {
    return ChewieController(
        videoPlayerController: VideoPlayerController.network(videourl),
        autoInitialize: true,
        looping: false,
        autoPlay: true,
        showControls: false,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(
              errorMessage,
              style: TextStyle(color: Colors.white),
            ),
          );
        });
  }

  late ChewieController _chewieController;
  @override
  void initState() {
    index = 0;
    videourl = widget.shortslist[index];
    //_chewielistitem = ChewieListItem(
    //  videoPlayerController: VideoPlayerController.network(shortslist[index]),
    //  looping: false,
    //  autoplay: true,
    //);
    _chewieController = createChewieController(videourl);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: false,
        backgroundColor: widget.color,
        key: _scaffoldKey,
        appBar: AppBar(
            automaticallyImplyLeading: false,
            systemOverlayStyle:
                SystemUiOverlayStyle(statusBarColor: widget.color),
            elevation: 0.0,
            backgroundColor: widget.color,
            toolbarHeight: 50.0,
            titleSpacing: 36.0,
            title: const Text(
              'Shorts',
              style: TextStyle(
                  fontSize: 30.0,
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold),
            )),
        body: Stack(fit: StackFit.expand, children: [
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
                  child: Chewie(
                    controller: _chewieController,
                  )),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: InkWell(
              onTap: () {
                print("left");
                _chewieController.dispose();
                _chewieController.videoPlayerController.dispose();
                Navigator.pop(context);
              },
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width / 2,
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: MediaQuery.of(context).size.width / 2,
            child: InkWell(
              onTap: () {
                setState(() {
                  if (index + 1 < widget.shortslist.length) {
                    _chewieController.dispose();
                    _chewieController.videoPlayerController.dispose();
                    index++;
                    print(index);
                    videourl = widget.shortslist[index];
                    print(videourl);
                    _chewieController = createChewieController(videourl);
                  }
                });
              },
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width / 2,
              ),
            ),
          ),
        ]),
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
                      icon: Icon(CupertinoIcons.bookmark_fill),
                      label: 'recommendations'),
                  BottomNavigationBarItem(
                      icon: Icon(CupertinoIcons.profile_circled),
                      label: "profile")
                ],
              ),
            )));
  }
}
