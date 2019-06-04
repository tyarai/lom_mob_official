import 'package:lemurs_of_madagascar/models/site.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:core';
import 'package:lemurs_of_madagascar/database/database_helper.dart';
import 'package:lemurs_of_madagascar/models/species_map.dart';

class SiteDatabaseHelper  {

  String siteTable     = "LemursWatchingSites";
  String idCol         = "_site_id";
  String titleCol      = "_title";

  Future<List<Map<String, dynamic>>> getSiteMapListWithID(int id) async {
    if(id != null && id != 0) {
      Database database = await DatabaseHelper.instance.database;
      var result = await database.rawQuery(
          "SELECT * FROM $siteTable WHERE $idCol = ? ", [id]);
      return result;
    }
    return List();
  }

  Future<List<Map<String, dynamic>>> getSiteMapList() async {

    Database database = await DatabaseHelper.instance.database;
    var result = await database.rawQuery("SELECT * FROM $siteTable ORDER BY $titleCol ASC ");
    return result;
  }



  Future<int> insertSite({database:Database,site:Site}) async {
    var result = await database.insert(siteTable, site.toMap());
    return result;
  }

  Future<int> updateSite({database:Database, site : Site}) async {
    var result = await database.update(siteTable, site.toMap(),
        where: '$idCol = ?', whereArgs: [site.id]);
    return result;
  }

  Future<int> deleteSite({database:Database, site : Site}) async {
    var result =
    await database.delete(siteTable, where: '$idCol = ?', whereArgs: [site.id]);
    return result;
  }

  Future<int> getRecordCount({database:Database}) async {
    List<Map<String, dynamic>> x =
    await database.rawQuery("SELECT COUNT(*) FROM $siteTable ");
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<List<Site>> getSiteList() async {


    var speciesMapMapList = await this.getSiteMapList();
    int count = speciesMapMapList.length;


    List<Site> list = new List<Site>();

    for(int i=0 ; i < count ; i++){
      list.add(Site.fromMap(speciesMapMapList[i]));
    }

    return list;
  }

  Future<List<Site>> getSiteListWithID(int id) async {

    var siteMapList = await this.getSiteMapListWithID(id);
    int count = siteMapList.length;

    List<Site> list = new List<Site>();

    for(int i=0 ; i < count ; i++){
      list.add(Site.fromMap(siteMapList[i]));
    }

    return list;
  }

  Future<Site> getSiteWithID(int id) async {
    var list = await this.getSiteListWithID(id);
    return list.length > 0 ? list[0] : null;
  }

}
