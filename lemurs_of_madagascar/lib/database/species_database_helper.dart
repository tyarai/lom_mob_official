import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:core';
import 'package:lemurs_of_madagascar/models/species.dart';

class SpeciesDatabaseHelper  {

  String speciesTable     = "Species";
  final idCol             = Species.idKey;

  Future<List<Map<String, dynamic>>> getSpeciesMapListWithID({database:Database,id: int}) async {
    var result = await database.rawQuery("SELECT * FROM $speciesTable WHERE $idCol = id ");
    return result;
  }

  Future<List<Map<String, dynamic>>> getSpeciesMapList({database:Database}) async {
    var result = await database.rawQuery("SELECT * FROM $speciesTable ");
    return result;
  }

  Future<int> insertSpecies({database:Database,species:Species}) async {
    var result = await database.insert(speciesTable, species.toMap());
    return result;
  }

  Future<int> updateSpecies({database:Database, species : Species}) async {
    var result = await database.update(speciesTable, species.toMap(),
        where: '$idCol = ?', whereArgs: [species.id]);
    return result;
  }

  Future<int> deleteSpecies({database:Database, species : Species}) async {
    var result =
    await database.delete(speciesTable, where: '$idCol = ?', whereArgs: [species.id]);
    return result;
  }

  Future<int> getRecordCount({database:Database}) async {
    List<Map<String, dynamic>> x =
    await database.rawQuery("SELECT COUNT(*) FROM $speciesTable ");
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<List<Species>> getSpeciesListWithID({database:Database,id: int}) async {

    var speciesMapList = await this.getSpeciesMapListWithID(database: database, id: id);
    int count = speciesMapList.length;

    List<Species> list = new List<Species>();

    for(int i=0 ; i < count ; i++){
      list.add(Species.fromMap(speciesMapList[i]));
    }

    return list;
  }

  Future<List<Species>> getSpeciesList({database:Database}) async {

    var speciesMapList = await this.getSpeciesMapList(database: database);
    int count = speciesMapList.length;

    List<Species> list = new List<Species>();

    for(int i=0 ; i < count ; i++){
      list.add(Species.fromMap(speciesMapList[i]));
    }

    return list;
  }

  Future<Species> getSpeciesWithID({database:Database,id: int}) async {
    var list = await this.getSpeciesListWithID(database: database,id: id);
    return list[0];
  }

}