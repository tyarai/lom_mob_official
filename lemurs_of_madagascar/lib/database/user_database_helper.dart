import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:core';
import 'package:lemurs_of_madagascar/models/user.dart';
import 'package:lemurs_of_madagascar/database/database_helper.dart';




class UserDatabaseHelper  {

  String userTable        = "User";


  Future<List<Map<String, dynamic>>> getUserMapListWithID({id: int}) async {
    Database database = await DatabaseHelper.instance.database;
    var result = await database.rawQuery("SELECT * FROM $userTable WHERE $User.uidKey = ?  ",[id]);
    return result;
  }

  Future<List<Map<String, dynamic>>> getUserMapList() async {
    Database database = await DatabaseHelper.instance.database;
    var result = await database.rawQuery("SELECT * FROM $userTable ");
    return result;
  }

  Future<int> insertUser({user:User}) async {
    Database database = await DatabaseHelper.instance.database;
    var result = await database.insert(userTable, user.toMap());
    return result;
  }

  Future<int> updateUser({user : User}) async {
    Database database = await DatabaseHelper.instance.database;
    var result = await database.update(userTable, user.toMap(),
        where: "$User.uidKey = ?", whereArgs: [user.id]);
    return result;
  }

  Future<int> deleteUser({user : User}) async {
    Database database = await DatabaseHelper.instance.database;
    var result =
    await database.delete(userTable, where: "$User.uidKey = ?", whereArgs: [user.id]);
    return result;
  }

  Future<int> getRecordCount() async {
    Database database = await DatabaseHelper.instance.database;
    List<Map<String, dynamic>> x =
    await database.rawQuery("SELECT COUNT(*) FROM $userTable ");
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<List<User>> getUserListWithID({id: int}) async {

    var userMapList = await this.getUserMapListWithID(id: id);
    int count = userMapList.length;

    List<User> list = new List<User>();

    for(int i=0 ; i < count ; i++){
      list.add(User.fromMap(userMapList[i]));
    }

    return list;
  }

  Future<List<User>> getUserList() async {


    var userMapList = await this.getUserMapList();
    int count = userMapList.length;

    List<User> list = new List<User>();

    for(int i=0 ; i < count ; i++){
      list.add(User.fromMap(userMapList[i]));
    }

    //print(list.toString());
    return list;
  }

  Future<User> getUserWithID({id: int}) async {
    var list = await this.getUserListWithID(id: id);
    return list[0];
  }

}