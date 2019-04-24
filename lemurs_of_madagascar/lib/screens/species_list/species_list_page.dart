import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';
import 'package:lemurs_of_madagascar/models/species.dart';
import 'package:lemurs_of_madagascar/models/photograph.dart';
import 'package:lemurs_of_madagascar/database/species_database_helper.dart';
import 'package:lemurs_of_madagascar/database/database_helper.dart';
import 'package:lemurs_of_madagascar/database/photograph_database_helper.dart';

class SpeciesListPage extends StatefulWidget {
  SpeciesListPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() {
    return SpeciesListPageState();
  }
}

class SpeciesListPageState extends State<SpeciesListPage> {
  int _speciesCount = 0;
  List<Species> species = List<Species>();
  DatabaseHelper databaseHelper;

  SpeciesListPageState() {
    databaseHelper = DatabaseHelper();
    _loadData();
  }

  void _loadData() {
    if (databaseHelper != null) {
      SpeciesDatabaseHelper speciesDBHelper = SpeciesDatabaseHelper();
      Future<Database> database = databaseHelper.database;

      database.then((db) {
        Future<List<Species>> futureList =
            speciesDBHelper.getSpeciesList(database: db);

        futureList.then((speciesList) {
          setState(() {
            this.species = speciesList;
            _speciesCount = this.species.length;
            print("count : $_speciesCount");
          });
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: _buildSpeciesGridList(),
      ),
    );
  }

  Widget _buildSpeciesGridList() {
    return GridView.builder(
        itemCount: _speciesCount,
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (BuildContext context, int index) {
          return _buildCellItem(context, index);
        });

    /*return ListView.builder(
        itemCount: _speciesCount,
        itemBuilder:(context,position) {

          //if(_speciesCount > 0){
            return _buildListItem(context, position);
          //}
        }
    );*/
  }

  Widget _buildCellItem(BuildContext context, int i) {

      this.databaseHelper = DatabaseHelper();
      Species species = this.species[i];

      PhotographDatabaseHelper photoDBHelper = PhotographDatabaseHelper();
      Future<Photograph> _photo = photoDBHelper.getPhotographWithID(
          database: this.databaseHelper.database, id: species.profilePhotoID);
      var profileImage;

      _photo.then((photo) {
        profileImage = Image.asset("assets/images/" + photo.photograph);

        return GestureDetector(
          child: Card(
            elevation: 2.5,
            child: Container(
              alignment: Alignment.center,
              child: Column(
                children: <Widget>[
                  profileImage,
                  Text(species.title)
                ],
              ),
            ),
          ),
          onTap: () {},
        );
      });

      /*return ListTile(
        title: Text(species[i].title),
        subtitle: Text(species[i].malagasy),
      );*/

    return null;
  }
}
