
import 'package:lemurs_of_madagascar/models/tag.dart';
import 'package:sqflite/sqflite.dart';
import 'package:lemurs_of_madagascar/database/database_helper.dart';

class TagDatabaseHelper {

  static const String tagTable  = "Tags";
  final idCol             = Tag.idKey;
  final nameCol           = Tag.nameENKey;
  final uuidCol           = Tag.uuidKey;
  final tidCol            = Tag.tidKey;
  final vocabularyCol     = Tag.vocabularyNameKey;

  Future<Map<String, dynamic>> getTagMapWithID(int id) async {

    if(id != null && id != 0 ){
      Database database = await DatabaseHelper.instance.database;
      var result = await database.rawQuery(
          "SELECT * FROM $tagTable WHERE $idCol = ? ", [id]);
      return result[0];
    }
    return Map();
  }

  Future<List<Map<String, dynamic>>> getTagMapList(String vocabularyName) async {
    if(vocabularyName != null && vocabularyName.length != 0) {
      Database database = await DatabaseHelper.instance.database;
      var result = await database.rawQuery(
          "SELECT * FROM $tagTable WHERE  $vocabularyCol = ?  ", [vocabularyName]);
      return result;
    }
    return List();
  }

  Future<int> insertTag(Tag tag) async {
    try {
      //print("insertTag() " + comment.toString());
      Database database = await DatabaseHelper.instance.database;
      var result = await database.insert(tagTable, tag.toMap());

      return result;
    }catch(e){
      print("[TAG_DATABASE_HELPER::insertTag()] exception "+e.toString());
      return null;
    }
  }

  Future<int> updateTag(Tag tag) async {
    try{

      if(tag.id != null &&  tag.id != 0) {

        Database database = await DatabaseHelper.instance.database;
        var result = await database.update(tagTable, tag.toMap(),
            where: '$idCol = ?', whereArgs: [tag.id]);
        return result;
      }
    }catch(e){
      print("[TAG_DATABASE_HELPER::updateTag()] "+e.toString());
      return 0;
    }
    return 0;
  }

  Future<int> deleteTag({tag : Tag}) async {
    try{
      Database database = await DatabaseHelper.instance.database;
      var result =
      await database.delete(tagTable, where: '$idCol = ?', whereArgs: [tag.id]);
      return result;
    }catch(e){
      print("[TAG_DATABASE_HELPER::deleteTag()] exception :"+e.toString());
      return null;
    }
  }

  Future<List<Tag>> getTagList(String vocabularyName) async {

    if(vocabularyName != null && vocabularyName.length != 0) {

      var tagList = await this.getTagMapList(vocabularyName);
      int count = tagList.length;

      List<Tag> list = new List<Tag>();

      for (int i = 0; i < count; i++) {
        list.add(Tag.fromMap(tagList[i]));
      }
      return list;
    }

    return List();
  }

}