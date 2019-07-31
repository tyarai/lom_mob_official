
import 'package:lemurs_of_madagascar/models/family.dart';
import 'package:sqflite/sqflite.dart';
import 'package:lemurs_of_madagascar/database/database_helper.dart';

class FamilyDatabaseHelper {

  static const String familyTable  = "Families";
  final nidCol                      = Family.nidKey;

  Future<Map<String, dynamic>> getFamilyMapWithID(int nid) async {

    if(nid != null && nid != 0 ){
      Database database = await DatabaseHelper.instance.database;
      var result = await database.rawQuery(
          "SELECT * FROM $familyTable WHERE $nidCol = ? ", [nid]);
      return ( result != null && result.length != 0 ) ?  result[0] : null;
    }
    return Map();
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


}