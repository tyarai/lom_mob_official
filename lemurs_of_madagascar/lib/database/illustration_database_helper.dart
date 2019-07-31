import 'package:lemurs_of_madagascar/models/illustration.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:core';
import 'package:lemurs_of_madagascar/database/database_helper.dart';



class IllustrationDatabaseHelper  {

  String illustrationTable          = "Illustrations";
  String nidCol                     = "_nid";
  String illustrationCol            = "_illustration";
  String illustrationDescriptionCol = "_illustration_description";

  Future<List<Map<String, dynamic>>> getIllustrationMapList({id: int}) async {
    Database database = await DatabaseHelper.instance.database;
    if(id != null && id != 0) {
      var result = await database.rawQuery(
          "SELECT * FROM $illustrationTable WHERE $nidCol = '$id' ", [id]);
      return result;
    }
    return List();
  }

  Future<int> insertIllustration({database:Database,illustration:Illustration}) async {
    var result = await database.insert(illustrationTable, illustration.toMap());
    return result;
  }

  Future<int> updateIllustration({database:Database, illustration : Illustration}) async {
    var result = await database.update(illustrationTable, illustration.toMap(),
        where: '$nidCol = ?', whereArgs: [illustration.nid]);
    return result;
  }

  Future<int> deletePhotograph({database:Database, illustration : Illustration}) async {
    var result =
    await database.delete(illustrationTable, where: '$nidCol = ?', whereArgs: [illustration.id]);
    return result;
  }

  Future<int> getRecordCount({database:Database}) async {
    List<Map<String, dynamic>> x =
    await database.rawQuery("SELECT COUNT(*) FROM $illustrationTable ");
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<List<Illustration>> getIllustrationList({id: int}) async {

    var illustrationMapList = await this.getIllustrationMapList(id: id);
    int count = illustrationMapList.length;

    List<Illustration> list = new List<Illustration>();

    for(int i=0 ; i < count ; i++){
      list.add(Illustration.fromMap(illustrationMapList[i]));
    }

    return list;
  }

  Future<Illustration> getIllustrationWithID({id: int}) async {
    var list = await this.getIllustrationList(id: id);
    return (list != null && list[0] != null ) ? list[0] : null;

  }

}
