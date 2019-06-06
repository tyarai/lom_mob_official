
import 'package:lemurs_of_madagascar/models/comment.dart';
import 'package:sqflite/sqflite.dart';
import 'package:lemurs_of_madagascar/models/sighting.dart';
import 'package:lemurs_of_madagascar/database/database_helper.dart';

class CommentDatabaseHelper  {

  static const String commentTable  = "Comment";
  final idCol             = Comment.idKey;
  final modifiedCol       = Comment.modifiedKey;
  final createdCol        = Comment.createdKey;
  final uidCol            = Comment.uidKey;
  final nidCol            = Comment.nidKey;

  Future<Map<String, dynamic>> getCommentMapWithID(int id) async {

    if(id != null && id != 0 ){
      Database database = await DatabaseHelper.instance.database;
      var result = await database.rawQuery(
          "SELECT * FROM $commentTable WHERE $idCol = ?  ", [id]);
      return result[0];
    }
    return Map();
  }

  Future<List<Map<String, dynamic>>> getCommentMapList(int sightingNid) async {
    if(sightingNid != null && sightingNid != 0) {
      Database database = await DatabaseHelper.instance.database;
      var result = await database.rawQuery(
          "SELECT * FROM $commentTable WHERE  $nidCol = ? ORDER BY $createdCol ASC ",
          [sightingNid]);
      return result;
    }
    return List();
  }

  Future<int> insertComment(Comment comment) async {
    try {
      Database database = await DatabaseHelper.instance.database;
      var result = await database.insert(commentTable, comment.toMap());

      return result;
    }catch(e){
      print("[COMMENT_DATABASE_HELPER::insertComment()] exception "+e.toString());
      return null;
    }
  }

  Future<int> updateComment(Comment comment) async {
    try{

      if(comment.id != null &&  comment.id != 0) {

        Database database = await DatabaseHelper.instance.database;
        var result = await database.update(commentTable, comment.toMap(),
            where: '$idCol = ?', whereArgs: [comment.id]);
        return result;
      }
    }catch(e){
      print("[COMMENT_DATABASE_HELPER::updateComment()] "+e.toString());
      return 0;
    }
    return 0;
  }

  Future<int> deleteComment({comment : Comment}) async {
    try{
      Database database = await DatabaseHelper.instance.database;
      var result =
      await database.delete(commentTable, where: '$idCol = ?', whereArgs: [comment.id]);
      
      return result;
    }catch(e){
      print("[COMMENT_DATABASE_HELPER::deleteComment()] exception :"+e.toString());
      return null;
    }
  }

  static Future<int> deleteAllComments(int sightingNid) async {
    Database database = await DatabaseHelper.instance.database;
    var result =
    await database.delete(commentTable, where: '${Comment.nidKey} = ?', whereArgs: [sightingNid]);
    
    return result;
  }

  Future<int> getRecordCount(int sightingNid) async {
    Database database = await DatabaseHelper.instance.database;
    List<Map<String, dynamic>> x =
    await database.rawQuery("SELECT COUNT(*) FROM $commentTable WHERE ${Comment.nidKey} = $sightingNid)");
    int result = Sqflite.firstIntValue(x);
    
    return result;
  }

  
  Future<List<Comment>> getCommentList(int sightingNid) async {

    var sightingMapList = await this.getCommentMapList(sightingNid);
    int count = sightingMapList.length;

    List<Comment> list = new List<Comment>();

    for(int i=0 ; i < count ; i++){
      list.add(Comment.fromMap(sightingMapList[i]));
    }

    //print(list.toString());
    return list;
  }

  /*Future<Sighting> getSightingWithID(int id) async {
    var map = await this.getSightingMapWithID(id);
    return Sighting.fromMap(map);
  }*/


}