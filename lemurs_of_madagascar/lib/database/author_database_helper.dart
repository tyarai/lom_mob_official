
import 'package:lemurs_of_madagascar/models/author.dart';
import 'package:lemurs_of_madagascar/models/comment.dart';
import 'package:sqflite/sqflite.dart';
import 'package:lemurs_of_madagascar/database/database_helper.dart';

class AuthorDatabaseHelper {

  static const String authorTable  = "Authors";
  final idCol                      = Author.idKey;

  Future<Map<String, dynamic>> getAuthorMapWithID(int id) async {

    if(id != null && id != 0 ){
      Database database = await DatabaseHelper.instance.database;
      var result = await database.rawQuery(
          "SELECT * FROM $authorTable WHERE $idCol = ? ", [id]);
      return ( result != null && result.length != 0 ) ?  result[0] : null;
    }
    return Map();
  }

  Future<List<Map<String, dynamic>>> getAuthorMapList() async {
    Database database = await DatabaseHelper.instance.database;
    var result = await database.rawQuery(
        "SELECT * FROM $authorTable ");
    return result;
  }

  Future<List<Author>> getAuthorList() async {

    var authorMapList = await this.getAuthorMapList();
    int count = authorMapList.length;

    List<Author> list = new List<Author>();

    for(int i=0 ; i < count ; i++){
      list.add(Author.fromMap(authorMapList[i]));
    }
    return list;
  }


}