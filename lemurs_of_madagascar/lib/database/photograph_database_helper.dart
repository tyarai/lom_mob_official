import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:core';
import 'package:lemurs_of_madagascar/models/photograph.dart';


class PhotographDatabaseHelper  {

  String photoTable     = "Photographs";
  String idCol          = "_nid";
  String titleCol       = "_title";
  String photographCol  = "_photograph";

  Future<List<Map<String, dynamic>>> getPhotographMapList({database:Database,id: int}) async {
    var result = await database.rawQuery("SELECT * FROM $photoTable WHERE $idCol = $id ");
    return result;
  }

  Future<int> insertPhotograph({database:Database,photo:Photograph}) async {
    var result = await database.insert(photoTable, photo.toMap());
    return result;
  }

  Future<int> updatePhotograph({database:Database, photo : Photograph}) async {
    var result = await database.update(photoTable, photo.toMap(),
        where: '$idCol = ?', whereArgs: [photo.id]);
    return result;
  }

  Future<int> deletePhotograph({database:Database, photo : Photograph}) async {
    var result =
    await database.delete(photoTable, where: '$idCol = ?', whereArgs: [photo.id]);
    return result;
  }

  Future<int> getRecordCount({database:Database}) async {
    List<Map<String, dynamic>> x =
    await database.rawQuery("SELECT COUNT(*) FROM $photoTable ");
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<List<Photograph>> getPhotographList({database:Database,id: int}) async {

    var photographMapList = await this.getPhotographMapList(database: database, id: id);
    int count = photographMapList.length;

    List<Photograph> list = new List<Photograph>();

    for(int i=0 ; i < count ; i++){
      list.add(Photograph.fromMap(photographMapList[i]));
    }

    return list;
  }

  Future<Photograph> getPhotographWithID({database:Database,id: int}) async {
    var list = await this.getPhotographList(database: database,id: id);
    return list[0];
  }

}
