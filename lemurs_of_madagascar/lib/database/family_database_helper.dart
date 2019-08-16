
import 'package:lemurs_of_madagascar/models/family.dart';
import 'package:sqflite/sqflite.dart';
import 'package:lemurs_of_madagascar/database/database_helper.dart';

class FamilyDatabaseHelper {

  static const String familyTable  = "Families";
  final nidCol                      = Family.nidKey;

  Future<List<Map<String, dynamic>>> getFamilyMapWithNID(int nid) async {

    if(nid != null && nid != 0 ){
      Database database = await DatabaseHelper.instance.database;
      var result = await database.rawQuery(
          "SELECT * FROM $familyTable WHERE $nidCol = ? ", [nid]);
      //return ( result != null && result.length != 0 ) ?  result[0] : null;
      return result;
    }
    return List();
  }

  Future<List<Map<String, dynamic>>> getFamilyMapList() async {
    Database database = await DatabaseHelper.instance.database;
    var result = await database.rawQuery(
        "SELECT * FROM $familyTable ");
    return result;
  }

  Future<List<Family>> getFamilyList() async {

    var familyMapList = await this.getFamilyMapList();
    int count = familyMapList.length;

    List<Family> list = new List<Family>();

    for(int i=0 ; i < count ; i++){
      list.add(Family.fromMap(familyMapList[i]));
    }
    return list;
  }

  Future<int> insertFamily({Database database,Family family}) async {
    try {
      //Database database = await DatabaseHelper.instance.database;
      var result = await database.insert(familyTable, family.toMap());

      return result;
    }catch(e){
      print("[FAMILY_DATABASE_HELPER::insertComment()] exception "+e.toString());
      return null;
    }
  }

  Future<int> updateFamily({Database database,Family family}) async {
    if(family != null) {
      try {

        if (family.nid != null && family.nid != 0) {

          //Database database = await DatabaseHelper.instance.database;
          var result = await database.update(familyTable, family.toMap(),
              where: '$nidCol = ?', whereArgs: [family.nid]);
          return result;
        }

      } catch (e) {
        print("[COMMENT_DATABASE_HELPER::updateComment()] " + e.toString());
      }
    }
    return 0;
  }


  Future<Family> getFamilyWithNID({nid: int}) async {
    /*var list = await this.getFamilyMapWithNID(nid);
    return (list != null && list[0] != null ) ? list[0] : null;*/
    var mapList = await this.getFamilyMapWithNID(nid);
    int count = mapList.length;

    List<Family> list = new List<Family>();

    for(int i=0 ; i < count ; i++){
      list.add(Family.fromMap(mapList[i]));
    }

    return list.length > 0 ? list[0] : null;


  }



}