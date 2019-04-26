import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lemurs_of_madagascar/models/species.dart';
import 'package:lemurs_of_madagascar/models/photograph.dart';
import 'package:lemurs_of_madagascar/database/species_database_helper.dart';
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

  List<Species> _speciesList;

  SpeciesListPageState();


  /*@override
  void initState() {
    super.initState();
    _searchQuery = new TextEditingController();
    fetchCountry(new http.Client()).then((String) {
      parseData(String);
    });
  }*/

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
      /*FutureBuilder(
            future:_loadData(),
            builder:(BuildContext context,AsyncSnapshot snapshot) {


              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }

              //_buildSpeciesGridList(snapshot.data);

              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (_, int position){

                    return Card(
                      child: ListTile(
                        title: Text(
                            "Employee Name: " ),
                      ),
                    );

                  });


            }
          ),*/
    );
  }


  Widget _buildSpeciesGridList() {

    return
      FutureBuilder(
        future:_loadData(),
        builder:(context,snapshot){

            return ListView.builder(
              itemCount: snapshot.data != null ? snapshot.data.length : 0,
              itemBuilder: (BuildContext context, int index) {
                Species species = snapshot.data[index];

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
             /* ListView*/ });

      });

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

  Widget _buildCellItem(BuildContext context, int i, dynamic snapshotData) {
    Species species = snapshotData[i];

    PhotographDatabaseHelper photoDBHelper = PhotographDatabaseHelper();
    Future<Photograph> _photo =
        photoDBHelper.getPhotographWithID(id: species.profilePhotoID);
    var profileImage;
    //profileImage = Image.asset("assets/images/3Cheiros2.jpg");//,width: 150.0,height:150.0);

    _photo.then((photo) {
      var file = "assets/images/" + photo.photograph + ".jpg";
      print(file);
      profileImage = Image.asset(file);
    });

    return GestureDetector(
      child: Card(
        elevation: 2.5,
        child: Container(
          alignment: Alignment.center,
          child: Column(
            children: <Widget>[
              //profileImage,
              Text(species.title)
            ],
          ),
        ),
      ),
      onTap: () {},
    );
  }
}
