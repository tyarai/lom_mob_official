
import 'package:lemurs_of_madagascar/models/author.dart';
import 'package:lemurs_of_madagascar/models/comment.dart';
import 'package:sqflite/sqflite.dart';
import 'package:lemurs_of_madagascar/database/database_helper.dart';

class AuthorDatabaseHelper {

  static const String authorTable  = "Authors";
  final idCol                      = Author.idKey;
  final nidCol                     = Author.nidKey;

  Future<Map<String, dynamic>> getAuthorMapWithNID(int nid) async {

    if(nid != null && nid != 0 ){
      Database database = await DatabaseHelper.instance.database;
      var result = await database.rawQuery(
          "SELECT * FROM $authorTable WHERE $nidCol = ? ", [nid]);
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

  Future<Author> getAuthorWithNID({nid: int}) async {
    var list = await this.getAuthorMapWithNID(nid);
    return (list != null && list[0] != null ) ? list[0] : null;

  }

  Future<int> insertAuthor({database:Database,author:Author}) async {
    var result = await database.insert(authorTable, author.toMap());
    return result;
  }

  Future<int> updateAuthor({database:Database, author : Author}) async {
    var result = await database.update(author, author.toMap(),
        where: '$nidCol = ?', whereArgs: [author.nid]);
    return result;
  }


}