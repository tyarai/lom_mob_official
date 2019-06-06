
import 'package:sqflite/sqflite.dart';
import 'package:lemurs_of_madagascar/models/sighting.dart';
import 'package:lemurs_of_madagascar/database/database_helper.dart';

class SightingDatabaseHelper  {

  static const String sightingsTable    = "Sightings";
  final idCol             = Sighting.idKey;
  final modifiedCol       = Sighting.modifiedKey;
  final uidCol            = Sighting.uidKey;

  Future<Map<String, dynamic>> getSightingMapWithID(int id) async {

    if(id != null && id != 0 ){
      Database database = await DatabaseHelper.instance.database;
      var result = await database.rawQuery(
          "SELECT * FROM $sightingsTable WHERE $idCol = ?  ", [id]);
      return result[0];
    }
    return Map();
  }

  Future<List<Map<String, dynamic>>> getSightingMapList(int uid) async {
    if(uid != null && uid != 0) {
      Database database = await DatabaseHelper.instance.database;
      var result = await database.rawQuery(
          "SELECT * FROM $sightingsTable WHERE  $uidCol = ? ORDER BY $modifiedCol DESC ",
          [uid]);
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

  Future<int> updateSighting(Sighting sighting) async {
    try{

      if(sighting.id != null &&  sighting.id != 0) {

        Database database = await DatabaseHelper.instance.database;
        var result = await database.update(sightingsTable, sighting.toMap(),
            where: '$idCol = ?', whereArgs: [sighting.id]);
        
        return result;
      }

    }catch(e){
      print("[SIGHTING_DATABASE_HELPER::updateSighting()] "+e.toString());
      return 0;
    }
    return 0;
  }

  Future<int> deleteSighting({sighting : Sighting}) async {
    try{
      Database database = await DatabaseHelper.instance.database;
      var result =
      await database.delete(sightingsTable, where: '$idCol = ?', whereArgs: [sighting.id]);
      
      return result;
    }catch(e){
      print("[SIGHTING_DATABASE_HELPER::deleteSighting()] exception :"+e.toString());
      return null;
    }
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

  
  Future<List<Sighting>> getSightingList(int uid) async {

    var sightingMapList = await this.getSightingMapList(uid);
    int count = sightingMapList.length;

    List<Sighting> list = new List<Sighting>();

    for(int i=0 ; i < count ; i++){
      list.add(Sighting.fromMap(sightingMapList[i]));
    }

    //print(list.toString());
    return list;
  }

  Future<Sighting> getSightingWithID(int id) async {
    var map = await this.getSightingMapWithID(id);
    return Sighting.fromMap(map);
  }


}