import 'package:flutter/material.dart';
import 'package:lemurs_of_madagascar/models/species.dart';
import 'package:lemurs_of_madagascar/utils/constants.dart';

class SpeciesDetailsPage extends StatefulWidget {
  Species species;

  SpeciesDetailsPage({this.species});

  @override
  State<StatefulWidget> createState() {
    return SpeciesDetailsPageState(species: this.species);
  }
}

class SpeciesDetailsPageState extends State<SpeciesDetailsPage> {
  Species species;
  int _bottomNavIndex = 0;
  List<String> _menuName = [
    "Name",
    "Identification",
    "Natural history",
    "Geographic range",
    "Conservation status",
    "Sites"
  ];

  String _title = "";

  SpeciesDetailsPageState({this.species}) {
    _title = _menuName[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.mainColor,
      appBar: _buildAppBar(),
      body: ListView(children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
          child: Material(
              elevation: 5.0,
              borderRadius:
                  BorderRadius.circular(Constants.speciesImageBorderRadius),
              shadowColor: Colors.blueGrey,
              child: Column(
                children: <Widget>[
                  Container(height: 20),
                  _buildBody(),
                ],
              )),
        )
      ]),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0.0,
      /*actions: <Widget>[

        PopupMenuButton(
          itemBuilder: (BuildContext context){
            List<PopupMenuItem> menus = List();

            menus.add(

              PopupMenuItem(
                  child: ListTile(
                    title: Text("Map"),
                  ),
              ),

            );

            return menus;

          },
        ),
      ],*/
      backgroundColor: Constants.mainColor,
      title: Text(_title), // Text(species.title),
    );
  }

  Theme _buildBottomNavBar() {
    return Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Constants.mainColor,
          primaryColor: Colors.red,
        ),
        child: BottomNavigationBar(
          fixedColor: Colors.greenAccent,
          type: BottomNavigationBarType.shifting,
          currentIndex: _bottomNavIndex,
          onTap: (int index) {
            setState(() {
              _bottomNavIndex = index;
              _title = _menuName[_bottomNavIndex];
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.assistant_photo),
              title: Text(""),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.info),
              title: Text(""),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              title: Text(""),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.place),
              title: Text(""),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.show_chart),
              title: Text(""),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map),
              title: Text(""),
            ),
          ],
        ));
  }

  Widget _buildBody() {
    return Padding(
        padding: EdgeInsets.all(20),
        child: Container(
          child: _buildTabs(),
        ));
  }

  Widget _buildTabs() {
    switch (_bottomNavIndex) {
      case 0:
        return _nameTab();
      case 1:
        return _showTab(Species.buildInfo(species.identification,
            crossAlignment: CrossAxisAlignment.center));
      case 2:
        return _showTab(Species.buildInfo(species.history,
            crossAlignment: CrossAxisAlignment.center));
      case 3:
        return _showTab(
            Species.buildInfo(species.range,
                crossAlignment: CrossAxisAlignment.center),
            secondaryWidget: species.getMap());
      case 4:
        return _showTab(Species.buildInfo(species.status,
            crossAlignment: CrossAxisAlignment.center));
      case 5:
        return _showTab(Species.buildInfo(species.sites,
            crossAlignment: CrossAxisAlignment.center));
    }
  }

  Widget _showTab(Widget widget, {Widget secondaryWidget}) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Species.buildLemurPhoto(species,
              imageClipper: SpeciesImageClipperType.rectangular,
              width: 100,
              height: 100),
          Container(height: 10),
          Row(children: <Widget>[
            Species.buildTextInfo(species,
                crossAlignment: CrossAxisAlignment.center),
          ]),
          Container(height: 30),
          Row(children: <Widget>[
            widget,
          ]),
          Container(height: 20),
          secondaryWidget != null
              ? Column(children: <Widget>[
                  secondaryWidget,
                ])
              : Container(),
        ]);
  }

  Widget _nameTab() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Species.buildLemurPhoto(species,
              imageClipper: SpeciesImageClipperType.rectangular,
              width: 100,
              height: 100),
          Container(height: 10),
          Row(children: <Widget>[
            Species.buildTextInfo(species,
                crossAlignment: CrossAxisAlignment.center, showMalagasy: false),
          ]),
          Container(height: 20),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
            Image.asset(
              "assets/images/icons/btn_malagasy_on.png",
              width: Constants.iconSize,
              height: Constants.iconSize,
            ),
            Container(width: 10),
            Species.buildInfo(species.malagasy),
          ]),
          Container(height: 20),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
            Image.asset(
              "assets/images/icons/btn_english_on.png",
              width: Constants.iconSize,
              height: Constants.iconSize,
            ),
            Container(width: 10),
            Species.buildInfo(species.english),
          ]),
          Container(height: 20),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
            Image.asset(
              "assets/images/icons/btn_german_on.png",
              width: Constants.iconSize,
              height: Constants.iconSize,
            ),
            Container(width: 10),
            Species.buildInfo(species.german),
          ]),
          Container(height: 20),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
            Image.asset(
              "assets/images/icons/btn_french_on.png",
              width: Constants.iconSize,
              height: Constants.iconSize,
            ),
            Container(width: 10),
            Species.buildInfo(species.french),
          ]),
        ]);
  }
}
