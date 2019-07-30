
import 'package:sqflite/sqflite.dart';
import 'package:lemurs_of_madagascar/models/sighting.dart';
import 'package:lemurs_of_madagascar/database/database_helper.dart';

class SightingDatabaseHelper  {

  static const String sightingsTable    = "Sightings";
  final idCol             = Sighting.idKey;
  final modifiedCol       = Sighting.modifiedKey;
  final uidCol            = Sighting.uidKey;
  final nidCol            = Sighting.nidKey;
  final uuidCol           = Sighting.uuidKey;
  final typeTagCol        = Sighting.activityTagTidKey;

  Future<Map<String, dynamic>> getSightingMapWithID(int id) async {

    if(id != null && id != 0 ){
      Database database = await DatabaseHelper.instance.database;
      var result = await database.rawQuery(
          "SELECT * FROM $sightingsTable WHERE $idCol = ?  ", [id]);
      return result[0];
    }
    return Map();
  }

  Future<Map<String, dynamic>> getSightingMapWithNID(int nid) async {

    if(nid != null && nid != 0 ){
      print("NID $nid");
      Database database = await DatabaseHelper.instance.database;
      List<Map<String,dynamic>> result = await database.rawQuery(
          "SELECT * FROM $sightingsTable WHERE $nidCol = ?  ", [nid]);
      //print("RESULT $result");
      return ( result != null && result.length != 0 ) ?  result[0] : null;
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getSightingMapList(int uid,{int pageIndex,int limit,bool illegalActivity=false}) async {
    if(uid != null && uid != 0) {
      Database database = await DatabaseHelper.instance.database;
      var result;

      if(!illegalActivity) {
        if(pageIndex != null && limit != null) {
          result = await database.rawQuery(
              "SELECT * FROM $sightingsTable WHERE  $uidCol = ? AND $typeTagCol IS NULL  ORDER BY $modifiedCol DESC LIMIT $pageIndex,$limit  ",
              [uid]);
        }else{
          result = await database.rawQuery(
              "SELECT * FROM $sightingsTable WHERE  $uidCol = ? AND $typeTagCol IS NULL  ORDER BY $modifiedCol DESC ",
              [uid]);
        }
      }else{
        if(pageIndex != null && limit != null){
          result = await database.rawQuery(
              "SELECT * FROM $sightingsTable WHERE  $uidCol = ? AND $typeTagCol IS NOT NULL  ORDER BY $modifiedCol DESC LIMIT $pageIndex,$limit  ",
              [uid]);
        }else{
          result = await database.rawQuery(
              "SELECT * FROM $sightingsTable WHERE  $uidCol = ? AND $typeTagCol IS NOT NULL  ORDER BY $modifiedCol DESC ",
              [uid]);
        }
      }
      print(result);
      return result;
    }
    return List();
  }

  Future<List<Map<String, dynamic>>> getLemurLifeMapList(int uid) async {
    if(uid != null && uid != 0) {
      Database database = await DatabaseHelper.instance.database;
      var result;
      result = await database.rawQuery(" SELECT _speciesNid,_speciesName,totalObserved,totalSightings FROM(  SELECT _speciesNid,_speciesName,SUM(_speciesCount) totalObserved,count(_speciesNid) totalSightings FROM $sightingsTable WHERE _uid = '$uid' AND _deleted ='0' GROUP BY _speciesNid ORDER BY _speciesName ASC)aa ");
      return result;
    }
    return List();
  }

  Future<int> insertSighting(Sighting sighting) async {
    try {
      Database database = await DatabaseHelper.instance.database;
      var result = await database.insert(sightingsTable, sighting.toMap());
      //print("[SIGHTING_DATABASE_HELPER::insertSighting()] Sighting " + sighting.toString());
      
      return result;
    }catch(e){
      print("[SIGHTING_DATABASE_HELPER::insertSighting()] "+e.toString());
      return null;
    }
  }

  Future<int> updateSighting(Sighting sighting,{int nid}) async {
    try{

      if(nid == null || nid == 0) {
        // Search by ID
        if (sighting.id != null && sighting.id != 0) {
          Database database = await DatabaseHelper.instance.database;
          var result = await database.update(sightingsTable, sighting.toMap(),
              where: '$idCol = ?', whereArgs: [sighting.id]);

          return result;
        }
      }else{
        // Search by NID
          Database database = await DatabaseHelper.instance.database;
          var result = await database.update(sightingsTable, sighting.toMap(),
              where: '$nidCol = ?', whereArgs: [nid]);

          return result;

      }

    }catch(e){
      print("[SIGHTING_DATABASE_HELPER::updateSighting()] "+e.toString());
      return 0;
    }
    return 0;
  }

  Future<int> deleteSighting(Sighting sighting ) async {
    try{
      //print("TO BE DELETED ${sighting.nid} -  ${sighting.id}");
      Database database = await DatabaseHelper.instance.database;

      var deletedRow = 0;

      if(sighting.id != null) {
        deletedRow = await database.delete(
            sightingsTable, where: '$idCol = ?', whereArgs: [sighting.id]);
      }else{
        deletedRow = await database.delete(
            sightingsTable, where: '$nidCol = ?', whereArgs: [sighting.nid]);
      }
      
      return deletedRow;
    }catch(e){
      print("[SIGHTING_DATABASE_HELPER::deleteSighting()] exception :"+e.toString());
    }
    return null;
  }

  static Future<int> deleteAllSightings() async {
    Database database = await DatabaseHelper.instance.database;
    var result =
    await database.delete(sightingsTable);
    
    return result;
  }

  Future<int> getRecordCount() async {
    Database database = await DatabaseHelper.instance.database;
    List<Map<String, dynamic>> x =
    await database.rawQuery("SELECT COUNT(*) FROM $sightingsTable ");
    int result = Sqflite.firstIntValue(x);
    
    return result;
  }

  Future<List<Sighting>> getSightingList(int uid,{int pageIndex,int limit,bool illegalActivity=false}) async {

    var sightingMapList = await this.getSightingMapList(uid,pageIndex:pageIndex,limit:limit ,illegalActivity: illegalActivity);
    int count = sightingMapList.length;

    List<Sighting> list = new List<Sighting>();

    for(int i=0 ; i < count ; i++){
      list.add(Sighting.fromMap(sightingMapList[i]));
    }

    //print(list.toString());
    return list;
  }

  Future<List<Sighting>> getLemurLifeList(int uid) async {

    var lemurLifeListMapList = await this.getLemurLifeMapList(uid);
    int count = lemurLifeListMapList.length;

    List<Sighting> list = new List<Sighting>();

    for(int i=0 ; i < count ; i++){
      list.add(Sighting.fromMap(lemurLifeListMapList[i]));
    }

    return list;
  }

  Future<Sighting> getSightingWithID(int id) async {
    var map = await this.getSightingMapWithID(id);
    return Sighting.fromMap(map);
  }

  Future<Sighting> getSightingWithNID(int nid) async {
    if(nid != null && nid !=0) {
      var map = await this.getSightingMapWithNID(nid);
      return Sighting.fromMap(map);
    }
    return null;
  }


}