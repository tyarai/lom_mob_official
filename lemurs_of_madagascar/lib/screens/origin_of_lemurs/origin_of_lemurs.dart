import 'package:flutter/material.dart';
import 'package:lemurs_of_madagascar/database/database_helper.dart';
import 'package:lemurs_of_madagascar/database/menu_database_helper.dart';
import 'package:lemurs_of_madagascar/models/menu.dart';
import 'package:lemurs_of_madagascar/utils/constants.dart';
import 'package:sqflite/sqlite_api.dart';


class OriginOfLemursPage extends StatefulWidget {

  final String title;

  OriginOfLemursPage({this.title});

  @override
  State<StatefulWidget> createState() {
    return OriginOfLemursPageState(title: title);
  }
}

class OriginOfLemursPageState extends State<OriginOfLemursPage> {

  final String title;
  MenuDatabaseHelper _menuDatabaseHandler = MenuDatabaseHelper();
  String _originMenuName = "origin";
  List<Menu> menuList;
  Menu origin;

  OriginOfLemursPageState({this.title});

  _buildTitle(){
    return Container(child:Text(this.title));
  }

  _updateUI() async {

    Database database = await DatabaseHelper.instance.database;

    Future<List<Menu>> futureList = _menuDatabaseHandler.getMenuList(
        database: database, menuName: this._originMenuName);

    futureList.then((menuList) {
      setState(() {
        origin = menuList[0];
      });
    });

  }


  @override
  Widget build(BuildContext context) {

    if (menuList == null) {
      menuList = List<Menu>();
      _updateUI();
    }

    Widget futureWidget = Scaffold(
        appBar: AppBar(
          centerTitle: true,

          title: _buildTitle(),
        ),
        //backgroundColor: Constants.mainColor,
        body: _buildBody();

      );

    return futureWidget;
  }

  _buildBody(){
    return Padding(
      padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
      child: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[

              Container(height: 20,),
              Text(
                origin != null ? origin.content : "",
                style: Constants.defaultTextStyle,
                textAlign: TextAlign.justify,
              )
            ],
          )
        ],
      ),
    )
  }

}
