import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:core';
import 'package:lemurs_of_madagascar/database/database_helper.dart';
import 'package:lemurs_of_madagascar/models/species_map.dart';


class SpeciesMapDatabaseHelper  {

  String mapsTable     = "Maps";
  String idCol         = "_nid";
  String fileNameCol   = "_file_name";

  Future<List<Map<String, dynamic>>> getSpeciesMapMapList({id: int}) async {
    Database database = await DatabaseHelper.instance.database;
    var result = await database.rawQuery("SELECT * FROM $mapsTable WHERE $idCol = ? ",[id]);
    return result;
  }

  Future<int> insertSpeciesMap({database:Database,map:SpeciesMap}) async {
    var result = await database.insert(mapsTable, map.toMap());
    return result;
  }

  Future<int> updateSpeciesMap({database:Database, map : SpeciesMap}) async {
    var result = await database.update(mapsTable, map.toMap(),
        where: '$idCol = ?', whereArgs: [map.id]);
    return result;
  }

  Future<int> deleteSpeciesMap({database:Database, map : SpeciesMap}) async {
    var result =
    await database.delete(mapsTable, where: '$idCol = ?', whereArgs: [map.id]);
    return result;
  }

  Future<int> getRecordCount({database:Database}) async {
    List<Map<String, dynamic>> x =
    await database.rawQuery("SELECT COUNT(*) FROM $mapsTable ");
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<List<SpeciesMap>> getSpeciesMapList({id: int}) async {

    var speciesMapMapList = await this.getSpeciesMapMapList(id: id);
    int count = speciesMapMapList.length;

    List<SpeciesMap> list = new List<SpeciesMap>();

    for(int i=0 ; i < count ; i++){
      list.add(SpeciesMap.fromMap(speciesMapMapList[i]));
    }

    return list;
  }

  Future<SpeciesMap> getSpeciesMapWithID({id: int}) async {
    var list = await this.getSpeciesMapList(id: id);
    return list.length > 0 ? list[0] : null;
  }

}
