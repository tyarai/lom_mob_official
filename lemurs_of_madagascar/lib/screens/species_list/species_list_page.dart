import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lemurs_of_madagascar/models/species.dart';
import 'package:lemurs_of_madagascar/database/species_database_helper.dart';

class SpeciesListPage extends StatefulWidget {
  SpeciesListPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() {
    return SpeciesListPageState();
  }
}

class SpeciesListPageState extends State<SpeciesListPage> {

  List<Species> _speciesList;

  SpeciesListPageState();


  @override
  void initState() {
    super.initState();

    Future<List<Species>> futureList = _loadData();

    futureList.then((list){
      setState(() {
        _speciesList = list;
      });
    });

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
      body: _buildSpeciesGridList(),

    );
  }

  Widget _loadImage(String fileName){

    return

      Image.asset(
        fileName,
        width: 150.0,
        height: 150.0,
        fit: BoxFit.fill,
      );
  }

  Widget _buildSpeciesGridList() {

    return FutureBuilder<List<Species>>(

      future: _loadData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {

        if (!snapshot.hasData) return Center(child: CircularProgressIndicator());


        return ListView.builder(
            itemCount: snapshot.data.length ,
            itemBuilder: (BuildContext context, int index) {

              return _buildCellItem(index);

              /*Species species = _speciesList[index];

          return GestureDetector(
            child: Card(
              elevation: 2.5,
              child: Container(
                alignment: Alignment.center,
                child: Column(
                  children: <Widget>[
                    _loadImage(species.imageFile),
                    Text(species.title),
                    Text(species.imageFile != null ? species.imageFile : "NULL")
                  ],
                ),
              ),
            ),
            onTap: () {},
          );
          */

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

  Widget _buildCellItem( int index) {

    Species species = _speciesList[index];

    return GestureDetector(
      child: Card(
        elevation: 2.5,
        child: Container(
          alignment: Alignment.center,
          child: Column(
            children:<Widget>[
              Row(
                children: <Widget>[
              _loadImage(species.imageFile),
              Text(species.title),
            ]),
          ]),

        ),
      ),
      onTap: () {},
    );
  }
}
