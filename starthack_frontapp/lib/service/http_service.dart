import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:starthack_frontapp/views/dashboard.dart';

class HttpService {
  static final _client = http.Client();

  static var _getMovie =
      Uri.parse('https://main-starthack-backend.herokuapp.com/get_next_movies');

  static var _sendSwipe =
      Uri.parse('https://main-starthack-backend.herokuapp.com/swipe');

  static var _getFavorites =
      Uri.parse('https://main-starthack-backend.herokuapp.com/get_favorites');

  static var _remFavorites =
      Uri.parse('https://main-starthack-backend.herokuapp.com/remove_favorite');
  static sendop(movieid, swipe) async {
    http.Response response = await _client.post(_sendSwipe,
        body: {'movie_id': movieid.toString(), 'swipe': swipe});
    if (response.statusCode == 200) {
      print("sent preference: $movieid, $swipe");
    } else {
      print("error");
    }
  }

  Future<String> getnextcards() async {
    final response = await http.get(_getMovie);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      //print(response.body);
      return response.body;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load');
    }
  }

  Future<String> getfavoritecards() async {
    final response = await http.get(_getFavorites);
  
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      //print(response.body);
      return response.body;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load');
    }
  }

  static remfav(movieid) async {
    http.Response response = await _client
        .post(_remFavorites, body: {'movie_id': movieid.toString()});
    if (response.statusCode == 200) {
      print("removed preference: $movieid");
    } else {
      print("error");
    }
  }
}
