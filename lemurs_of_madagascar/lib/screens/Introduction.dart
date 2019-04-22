import 'package:flutter/material.dart';
import 'package:lemurs_of_madagascar/database/menu_database_helper.dart';
import 'package:lemurs_of_madagascar/models/menu.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'dart:core';


class IntroductionPage extends StatefulWidget {

  IntroductionPage({Key key, this.title}) : super(key: key);

  // It is stateful, meaning it has a State object (defined below) that contains fields that affect
  // how it looks.

  final String title;

  @override
  _IntroductionPageState createState() => _IntroductionPageState();
}

class _IntroductionPageState extends State<IntroductionPage> {

  MenuDatabaseHelper menuHelper = MenuDatabaseHelper();
  String _introductionMenuName = "introduction";
  List<Menu> menuList;
  Menu introduction;



  @override
  Widget build(BuildContext context) {

    if(menuList == null) {
      menuList = List<Menu>();
      _updateUI();
    }

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              introduction.content,
            ),
          ],
        ),
      ),

      /*floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),*/ // This trailing comma makes auto-formatting nicer for build methods.

    );
  }

  _updateUI(){

    final Future<Database> database = menuHelper.initializeDatabase();

    database.then((database){

        Future<List<Menu>> futureList = menuHelper.getMenuList(menuName:this._introductionMenuName);

        futureList.then((menuList){

            setState(() {

              introduction = menuList[0];

            });

        });
      }
    );


  }
}

