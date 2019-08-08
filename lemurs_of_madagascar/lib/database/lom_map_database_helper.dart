import 'package:lemurs_of_madagascar/models/lom_map.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:core';
import 'package:lemurs_of_madagascar/database/database_helper.dart';



class LOMMapDatabaseHelper  {

  String mapTable                   = "Maps";
  String nidCol                     = LOMMap.nidKey;
  String fileNameCol                = LOMMap.fileNameKey;

  Future<List<Map<String, dynamic>>> getMapList({id: int}) async {
    Database database = await DatabaseHelper.instance.database;
    if(id != null && id != 0) {
      var result = await database.rawQuery(
          "SELECT * FROM $mapTable WHERE $nidCol = ? ", [id]);
      return result;
    }
    return List();
  }

  Future<int> insertLOMMap({database:Database,map:LOMMap}) async {
    var result = await database.insert(mapTable, map.toMap());
    return result;
  }

  Future<int> updateLOMMap({database:Database, map : LOMMap}) async {
    var result = await database.update(mapTable, map.toMap(),
        where: '$nidCol = ?', whereArgs: [map.nid]);
    return result;
  }

  Future<int> deleteLOMMap({database:Database, map : LOMMap}) async {
    var result =
    await database.delete(mapTable, where: '$nidCol = ?', whereArgs: [map.id]);
    return result;
  }

  Future<int> getRecordCount({database:Database}) async {
    List<Map<String, dynamic>> x =
    await database.rawQuery("SELECT COUNT(*) FROM $mapTable ");
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<List<LOMMap>> getLOMMapList({id: int}) async {

    var lomMapList = await this.getMapList(id: id);
    int count = lomMapList.length;

    List<LOMMap> list = new List<LOMMap>();

    for(int i=0 ; i < count ; i++){
      list.add(LOMMap.fromMap(lomMapList[i]));
    }

    return list;
  }

  Future<LOMMap> getLOMMapWithID({id: int}) async {
    var list = await this.getLOMMapList(id: id);
    return (list != null && list[0] != null ) ? list[0] : null;

  }

}
