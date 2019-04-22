import 'package:flutter/material.dart';
import 'package:lemurs_of_madagascar/screens/Introduction.dart';

void main() => runApp(LOMApp());

class LOMApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: IntroductionPage(title: 'Lemurs of madagascar'),
    );
  }
}

