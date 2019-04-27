import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:core';
import 'package:lemurs_of_madagascar/models/menu.dart';

class MenuDatabaseHelper {


  String menuTable  = "Menus";
  String idCol      = "_nid";
  String nameCol    = "_menu_name";
  String contentCol = "_menu_content";



  Future<List<Map<String, dynamic>>> getMenuMapList({database:Database,menuName: String}) async {
    var result = await database       .rawQuery("SELECT * FROM $menuTable WHERE $nameCol = '$menuName' ");

    return result;
  }

  Future<int> insertMenu({database:Database,menu:Menu}) async {
    var result = await database.insert(menuTable, menu.toMap());
    return result;
  }

  Future<int> updateMenu({database:Database, menu : Menu}) async {
    var result = await database.update(menuTable, menu.toMap(),
        where: '$idCol = ?', whereArgs: [menu.id]);
    return result;
  }

  Future<int> deleteMenu({database:Database, menu : Menu}) async {
    var result =
        await database.delete(menuTable, where: '$idCol = ?', whereArgs: [menu.id]);
    return result;
  }

  Future<int> getRecordCount({database:Database}) async {
    List<Map<String, dynamic>> x =
        await database.rawQuery("SELECT COUNT(*) FROM $menuTable ");
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<List<Menu>> getMenuList({database:Database,menuName: String}) async {

    var menuMapList = await this.getMenuMapList(database: database, menuName: menuName);
    int count = menuMapList.length;

    List<Menu> list = new List<Menu>();

    for(int i=0 ; i < count ; i++){
      list.add(Menu.fromMap(menuMapList[i]));
    }

    return list;

  }

}
