import 'package:flutter/material.dart';
import 'package:lemurs_of_madagascar/database/menu_database_helper.dart';
import 'package:lemurs_of_madagascar/database/database_helper.dart';
import 'package:lemurs_of_madagascar/database/photograph_database_helper.dart';
import 'package:lemurs_of_madagascar/models/menu.dart';
import 'package:lemurs_of_madagascar/models/photograph.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
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
  DatabaseHelper _databaseHandler = DatabaseHelper();
  MenuDatabaseHelper _menuDatabaseHandler = MenuDatabaseHelper();

  String _introductionMenuName = "introduction";
  List<Menu> menuList;
  Menu introduction;

  @override
  Widget build(BuildContext context) {
    if (menuList == null) {
      menuList = List<Menu>();
      _updateUI();
    }

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Padding(
          padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
          child: ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage(
                                "assets/images/ram-everglades(resized).jpg"),
                            fit: BoxFit.fill,
                          ))),
                  Text(
                    introduction != null ? introduction.content : "",
                    style: TextStyle(fontSize: 20.0),
                  )
                ],
              )
            ],
          )),
    );
  }

  _updateUI() {
    final Future<Database> database = _databaseHandler.initializeDatabase();

    database.then((database) {
      Future<List<Menu>> futureList = _menuDatabaseHandler.getMenuList(
          database: database, menuName: this._introductionMenuName);

      futureList.then((menuList) {
        setState(() {
          introduction = menuList[0];
        });
      });
    });
  }
}
