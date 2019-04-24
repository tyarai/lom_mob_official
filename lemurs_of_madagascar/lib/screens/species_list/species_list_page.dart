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

  SpeciesListPageState();

  Future<List<Species>> _loadData()  {

      SpeciesDatabaseHelper speciesDBHelper = SpeciesDatabaseHelper();
      Future<List<Species>> futureList =    speciesDBHelper.getSpeciesList();
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
        builder:( BuildContext context,AsyncSnapshot snapshot) {

          if(!snapshot.hasData) return Center(child: CircularProgressIndicator(),);

            return GridView.builder(
                itemCount: snapshot.data.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
                itemBuilder: (BuildContext context, int index) {

                  if(snapshot.hasError){
                    print(snapshot.error);
                  }

                 snapshot.data

                 return GestureDetector(

                    child: Card(
                      elevation: 2.5,
                      child: Container(
                        alignment: Alignment.center,
                        child: Column(
                          children: <Widget>[
                            //Image.asset(species.imageFile,width: 150.0, height: 150.0,),
                            Text(species.title),
                            //Text(species.imageFile)
                          ],
                        ),
                      ),

                    ),
                    onTap: () {},
                  );

                }
            );

      });

  }

  Widget _buildCellItem(BuildContext context, int i,dynamic snapshotData)   {

      Species species = snapshotData[i] ;

      PhotographDatabaseHelper photoDBHelper = PhotographDatabaseHelper();
      Future<Photograph> _photo = photoDBHelper.getPhotographWithID(id: species.profilePhotoID);
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
