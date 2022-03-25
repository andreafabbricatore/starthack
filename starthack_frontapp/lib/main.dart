import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:starthack_frontapp/views/dashboard.dart';
import 'package:starthack_frontapp/views/match.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Tinder App",
      home: Dashboard(),
      builder: EasyLoading.init(),
    );
  }
}
