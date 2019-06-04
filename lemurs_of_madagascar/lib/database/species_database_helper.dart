import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:core';
import 'package:lemurs_of_madagascar/models/species.dart';
import 'package:lemurs_of_madagascar/database/database_helper.dart';




class SpeciesDatabaseHelper  {

  String speciesTable     = "Species";
  final idCol             = Species.idKey;
  final titleCol          = Species.titleKey;

  Future<List<Map<String, dynamic>>> getSpeciesMapListWithID({id: int}) async {
    Database database = await DatabaseHelper.instance.database;
    if(id != null && id !=0) {
      var result = await database.rawQuery(
          "SELECT * FROM $speciesTable WHERE $idCol = ?  ORDER BY $titleCol ASC ",
          [id]);
      return result;
    }
    return List();
  }

  Future<List<Map<String, dynamic>>> getSpeciesMapList() async {
    Database database = await DatabaseHelper.instance.database;
    var result = await database.rawQuery("SELECT * FROM $speciesTable ORDER BY $titleCol ASC ");
    return result;
  }

  Future<int> insertSpecies({species:Species}) async {
    Database database = await DatabaseHelper.instance.database;
    var result = await database.insert(speciesTable, species.toMap());
    return result;
  }

  Future<int> updateSpecies({species : Species}) async {
    Database database = await DatabaseHelper.instance.database;
    var result = await database.update(speciesTable, species.toMap(),
        where: '$idCol = ?', whereArgs: [species.id]);
    return result;
  }

  Future<int> deleteSpecies({species : Species}) async {
    Database database = await DatabaseHelper.instance.database;
    var result =
    await database.delete(speciesTable, where: '$idCol = ?', whereArgs: [species.id]);
    return result;
  }

  Future<int> getRecordCount() async {
    Database database = await DatabaseHelper.instance.database;
    List<Map<String, dynamic>> x =
    await database.rawQuery("SELECT COUNT(*) FROM $speciesTable ");
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<List<Species>> getSpeciesListWithID({id: int}) async {

    var speciesMapList = await this.getSpeciesMapListWithID(id: id);
    int count = speciesMapList.length;

    List<Species> list = new List<Species>();

    for(int i=0 ; i < count ; i++){
      list.add(Species.fromMap(speciesMapList[i]));
    }

    return list;
  }

  Future<List<Species>> getSpeciesList() async {


    var speciesMapList = await this.getSpeciesMapList();
    int count = speciesMapList.length;

    List<Species> list = new List<Species>();

    for(int i=0 ; i < count ; i++){
      list.add(Species.fromMap(speciesMapList[i]));
    }

    //print(list.toString());
    return list;
  }

  Future<Species> getSpeciesWithID(int id) async {
    var list = await this.getSpeciesListWithID(id: id);
    return list.length > 0 ? list[0] : null;
  }

}