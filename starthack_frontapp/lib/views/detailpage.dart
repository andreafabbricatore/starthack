import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class DetailsPage extends StatefulWidget {
  final String title, releasedate, posterurl, plot;
  final double rating;
  final List genres, top3cast;
  final Color color;

  DetailsPage(
      {Key? key,
      required this.title,
      required this.releasedate,
      required this.posterurl,
      required this.plot,
      required this.genres,
      required this.rating,
      required this.top3cast,
      required this.color})
      : super(key: key);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.color,
      body: Container(
        margin: const EdgeInsets.only(top: kToolbarHeight - 50),
        color: widget.color,
        child: Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      Container(
                        child: FittedBox(
                          child: Image.network(widget.posterurl),
                          fit: BoxFit.fill,
                        ),
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24.0, 16.0, 0, 0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    widget.title,
                                    style: TextStyle(
                                        color: Colors.white,
                                        overflow: TextOverflow.visible,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(width: 20),
                                Text(widget.releasedate,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold))
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24.0, 0, 0, 0),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        height: 20,
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: widget.genres.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    0.0, 0.0, 12.0, 0.0),
                                child: Container(
                                    padding: EdgeInsets.all(2),
                                    alignment: Alignment.centerLeft,
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.white),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5))),
                                    child: Text(
                                      widget.genres[index],
                                      style: TextStyle(color: Colors.white),
                                    )),
                              );
                            }),
                      )),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24.0, 10, 24.0, 0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Expanded(
                      child: Text(
                        widget.plot,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24.0, 15, 24.0, 0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Cast",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                          child: Container(
                            height: 20,
                            width: MediaQuery.of(context).size.width,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: widget.top3cast.length,
                                itemBuilder: (context, index) {
                                  return Text(widget.top3cast[index] + ' ',
                                      style: TextStyle(color: Colors.white));
                                }),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0.0, 15, 0.0, 0),
                          child: Row(
                            children: [
                              Text(
                                "Rating: ",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),
                              Text(
                                "${(widget.rating * 10).toInt().toString()}% of people like it",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        )
                      ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
