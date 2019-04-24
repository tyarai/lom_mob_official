import 'package:flutter/material.dart';
import 'package:lemurs_of_madagascar/database/menu_database_helper.dart';
import 'package:lemurs_of_madagascar/database/database_helper.dart';
import 'package:lemurs_of_madagascar/models/menu.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:core';


//@TODO : 2018-04-24 : Adjust code to prevent navigating to the same page again.

class IntroductionPage extends StatefulWidget {
  IntroductionPage({Key key, this.title}) : super(key: key);

  // It is stateful, meaning it has a State object (defined below) that contains fields that affect
  // how it looks.

  final String title;

  @override
  _IntroductionPageState createState() => _IntroductionPageState();
}

class _IntroductionPageState extends State<IntroductionPage> {
  var _menuItemFontSize = 18.0;
  var _iconSize = 24.0;

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
      drawer: Drawer(
        child: ListView(
          children: _getDrawerMenu(),
        ),
      ),
      body: Padding(
          padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
          child: ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                      width: 150,
                      height: 150,
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

  List<Widget> _getDrawerMenu() {
    List<Widget> menuItems = List<Widget>();

    menuItems.add(ListTile(
      title:
          Text("Introduction", style: TextStyle(fontSize: _menuItemFontSize)),
      leading: Image.asset("assets/images/icons/ico_infos.png",
          width: _iconSize, height: _iconSize),
      onTap: () {
        Navigator.pop(context); // Close the drawer
        _showIntroduction();

      },
    ));

    menuItems.add(ListTile(
      title: Text("Sightings", style: TextStyle(fontSize: _menuItemFontSize)),
      leading: Image.asset("assets/images/icons/binocular.png",
          width: _iconSize, height: _iconSize),
    ));

    menuItems.add(ListTile(
      title: Text("Primate watching",
          style: TextStyle(fontSize: _menuItemFontSize)),
      leading: Image.asset("assets/images/icons/ico_eye.png",
          width: _iconSize, height: _iconSize),
    ));

    menuItems.add(ListTile(
      title: Text("Origin of lemurs",
          style: TextStyle(fontSize: _menuItemFontSize)),
      leading: Image.asset("assets/images/icons/origin.png",
          width: _iconSize, height: _iconSize),
    ));

    menuItems.add(ListTile(
      title:
          Text("Extinct lemurs", style: TextStyle(fontSize: _menuItemFontSize)),
      leading: Image.asset("assets/images/icons/extinct.png",
          width: _iconSize, height: _iconSize),
    ));

    menuItems.add(ListTile(
      title: Text("About the authors",
          style: TextStyle(fontSize: _menuItemFontSize)),
      leading: Image.asset("assets/images/icons/author.png",
          width: _iconSize, height: _iconSize),
    ));

    menuItems.add(ListTile(
      title: Text("Species", style: TextStyle(fontSize: _menuItemFontSize)),
      leading: Image.asset("assets/images/icons/ico_specy.png",
          width: _iconSize, height: _iconSize),
      onTap: (){
        Navigator.pop(context); // Close the drawer
        _showSpeciesListPage();

      },
    ));

    menuItems.add(ListTile(
      title: Text("Families", style: TextStyle(fontSize: _menuItemFontSize)),
      leading: Image.asset("assets/images/icons/ico_families.png",
          width: _iconSize, height: _iconSize),
    ));

    menuItems.add(ListTile(
      title:
          Text("Watching sites", style: TextStyle(fontSize: _menuItemFontSize)),
      leading: Image.asset("assets/images/icons/ico_map.png",
          width: _iconSize, height: _iconSize),
    ));

    menuItems.add(ListTile(
      title:
          Text("Our partners", style: TextStyle(fontSize: _menuItemFontSize)),
      leading: Image.asset("assets/images/icons/ico_partners.png",
          width: _iconSize, height: _iconSize),
    ));

    menuItems.add(ListTile(
      title: Text("Settings", style: TextStyle(fontSize: _menuItemFontSize)),
      leading: Image.asset("assets/images/icons/settings_icon.png",
          width: _iconSize, height: _iconSize),
    ));

    menuItems.add(ListTile(
      title: Text("Report illegal activities",
          style: TextStyle(fontSize: _menuItemFontSize)),
      leading: Image.asset("assets/images/icons/sign_forbidden.png",
          width: _iconSize, height: _iconSize),
    ));

    menuItems.add(ListTile(
      title: Text("App instructions",
          style: TextStyle(fontSize: _menuItemFontSize)),
      leading: Image.asset("assets/images/icons/about.png",
          width: _iconSize, height: _iconSize),
    ));

    return menuItems;
  }

  _showIntroduction() {
    Navigator.pushNamed(context, '/introduction');
    /*Navigator.of(context).push(
      MaterialPageRoute(builder: (context) {
        return IntroductionPage(title: "Introduction",);
      }),
    );*/
  }

  _showSpeciesListPage() {
    Navigator.pushNamed(context, '/species_list');
    /*Navigator.of(context).push(
      MaterialPageRoute(builder: (context) {
        //Navigator.pop(context);
        return SpeciesListPage(title: "Species list",);
      }),
    );*/
  }

}
