import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lemurs_of_madagascar/models/species.dart';
import 'package:lemurs_of_madagascar/database/species_database_helper.dart';
import 'package:lemurs_of_madagascar/utils/constants.dart';

class SpeciesListPage extends StatefulWidget {
  SpeciesListPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() {
    return SpeciesListPageState();
  }
}

enum CellType {
  ListTiles,
  Column,
  FittedBox,
}

class SpeciesListPageState extends State<SpeciesListPage> {
  List<Species> _speciesList = List<Species>();

  SpeciesListPageState();

  @override
  void initState() {
    super.initState();

    // Only do this one time if the List is empty
    if (_speciesList.length == 0) {
      Future<List<Species>> futureList = _loadData();
      futureList.then((list) {
        setState(() {
          _speciesList = list;
        });
      });
    }
  }

  Future<List<Species>> _loadData() async {
    SpeciesDatabaseHelper speciesDBHelper = SpeciesDatabaseHelper();
    List<Species> futureList = await speciesDBHelper.getSpeciesList();
    return futureList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _buildSpeciesListView(),
    );
  }

  Widget _loadImage(String fileName,
      {double width = Constants.listViewImageWidth,
      double height = Constants.listViewImageWidth}) {
    return Image.asset(
      fileName,
      width: width,
      height: height,
    );
  }

  Widget _buildSpeciesListView() {
    return FutureBuilder<List<Species>>(
      future: _loadData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());

        return ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              return _buildCellItem(index);
            });
      },
    );
  }

  Widget _buildSpeciesGridList() {
    return FutureBuilder<List<Species>>(
      future: _loadData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());

        return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              return _buildCellItem(index);
            });
      },
    );
  }

  /*Widget _buildSpeciesGridList() {

    return ListView.builder(
        itemCount: _speciesList != null ? _speciesList.length : 0,
        itemBuilder: (BuildContext context, int index) {
          Species species = _speciesList[index];

          return GestureDetector(
            child: Card(
              elevation: 2.5,
              child: Container(
                alignment: Alignment.center,
                child: Column(
                  children: <Widget>[
                    Image.asset(
                      species.imageFile,
                      width: 150.0,
                      height: 150.0,
                      fit: BoxFit.fill,
                    ),
                    Text(species.title),
                    Text(species.imageFile != null ? species.imageFile : "NULL")
                  ],
                ),
              ),
            ),
            onTap: () {},
          );
        });
  }
  */

  Widget _buildCellItem(int index, {CellType cellType = CellType.FittedBox}) {
    Species species = _speciesList[index];

    Widget widget;

    switch (cellType) {
      case CellType.Column:
        {
          break;
        }
      case CellType.FittedBox:
        {
          widget = Padding(
              padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
              child: Container(
                  child: Material(
                elevation: 2.5,
                borderRadius: BorderRadius.circular(15.0),
                shadowColor: Colors.blueGrey,
                child: Padding(
                    padding: EdgeInsets.fromLTRB(5, 5, 10, 5),
                    child:Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _buildLemurPhoto(species),
                      Container(width: 10),
                      _buildTextInfo(species),
                    ])
                ),
              )));

          break;
        }
      case CellType.ListTiles:
        {
          widget = Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Card(
                elevation: 1.5,
                child: ListTile(
                  leading: _buildLemurPhoto(species),
                  title: _buildTitle(species),
                  subtitle: _buildSubTitle(species),
                ),
              ));
          break;
        }
    }

    return widget;
  }

  Widget _buildTextInfo(Species species) {
    return Expanded(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(species.title, style: TextStyle(fontSize: Constants.titleFontSize)),
            Container(height: 10),
            Text(species.malagasy,style: TextStyle(fontSize: Constants.subTitleFontSize)),
          ]),
    );
  }

  Widget _buildLemurPhoto(Species species) {
    return Container(
        child: ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: _loadImage(species.imageFile)));
  }

  Widget _buildTitle(Species species) {
    return Expanded(
      child: Text(species.title, style: TextStyle(fontSize: 18.0)),
    );
  }

  Widget _buildSubTitle(Species species) {
    return Expanded(
      child: Text(species.malagasy),
    );
  }
}
