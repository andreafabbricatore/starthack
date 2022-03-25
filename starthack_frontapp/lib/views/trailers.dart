import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class TrailerPage extends StatefulWidget {
  final String trailerurl;
  final Color color;

  TrailerPage({Key? key, required this.trailerurl, required this.color})
      : super(key: key);

  @override
  State<TrailerPage> createState() => _TrailerPageState();
}

class _TrailerPageState extends State<TrailerPage> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  late YoutubePlayerController controller;
  @override
  void deactivate() {
    controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    print(widget.trailerurl.substring(widget.trailerurl.length - 11));
    controller = YoutubePlayerController(
        initialVideoId:
            widget.trailerurl.substring(widget.trailerurl.length - 11),
        flags: const YoutubePlayerFlags(
          mute: false,
          loop: false,
          autoPlay: true,
        ));
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp
    ]);
    controller.toggleFullScreenMode();
  }

  @override
  Widget build(BuildContext context) => YoutubePlayerBuilder(
      player: YoutubePlayer(controller: controller),
      builder: (context, player) => Scaffold(
            extendBody: false,
            backgroundColor: widget.color,
            key: _scaffoldKey,
            body: Stack(
              fit: StackFit.expand,
              children: [
                Card(
                    margin: const EdgeInsets.all(16.0),
                    shadowColor: Colors.deepPurple,
                    elevation: 12.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                    color: Color.fromARGB(255, 0, 0, 0),
                    child: player),
                Positioned(
                  top: 0,
                  left: MediaQuery.of(context).size.width / 2,
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width / 2,
                    ),
                  ),
                ),
              ],
            ),
          ));
}
