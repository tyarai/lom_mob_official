import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'dart:core';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart';
import 'package:lemurs_of_madagascar/database/database.dart';
import 'package:lemurs_of_madagascar/models/menu.dart';

class MenuDatabaseHelper extends LOMDatabaseHelper {
  static MenuDatabaseHelper
      _menuDatabaseHelper; // singleton: Only create one instance
  static Database _database; // Singleton Database

  String menuTable = "Menus";
  String idCol = "_nid";
  String nameCol = "_menu_name";
  String contentCol = "_menu_content";

  MenuDatabaseHelper._createInstance();

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    var dbPath = join(directory.path, databaseName);

    // copy db file from Assets folder to Documents folder (only if not already there...)
    if (FileSystemEntity.typeSync(dbPath) == FileSystemEntityType.notFound) {
      ByteData data = await rootBundle.load("assets/db/$databaseName");
      writeToFile(data, dbPath);
    }
    // Open/create the database at a given path
    var database = await openDatabase(dbPath,
        version: currentVersion, // Starting from 11
        onUpgrade: _onUpgrade);

    return database;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  _onUpgrade(Database db, int oldVersion, int newVersion) {}

  //@TODO : Check if we can find other method to copy the database to the working directory
  // This copy db function works if the database file size is less than 650MB. Actually
  // our original database size is about 1.5MB so it's okay.
  void writeToFile(ByteData data, String path) {
    final buffer = data.buffer;
    return new File(path).writeAsBytesSync(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  factory MenuDatabaseHelper() {
    if (_menuDatabaseHelper == null) {
      _menuDatabaseHelper = MenuDatabaseHelper._createInstance();
    }
    return _menuDatabaseHelper;
  }

  Future<List<Map<String, dynamic>>> getMenuMapList({menuName: String}) async {
    Database db = await this.database;

    var result = await db
        .rawQuery("SELECT * FROM $menuTable WHERE $nameCol = '$menuName' ");

    return result;
  }

  Future<int> insertMenu(Menu menu) async {
    Database db = await this.database;
    var result = await db.insert(menuTable, menu.toMap());
    return result;
  }

  Future<int> updateMenu(Menu menu) async {
    Database db = await this.database;
    var result = await db.update(menuTable, menu.toMap(),
        where: '$idCol = ?', whereArgs: [menu.id]);
    return result;
  }

  Future<int> deleteMenu(Menu menu) async {
    Database db = await this.database;
    var result =
        await db.delete(menuTable, where: '$idCol = ?', whereArgs: [menu.id]);
    return result;
  }

  Future<int> getRecordCound() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery("SELECT COUNT(*) FROM $menuTable ");
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<List<Menu>> getMenuList({menuName: String}) async {

    var menuMapList = await this.getMenuMapList(menuName: menuName);
    int count = menuMapList.length;

    List<Menu> list = new List<Menu>();

    for(int i=0 ; i < count ; i++){
      list.add(Menu.fromMap(menuMapList[i]));
    }

    return list;

  }

}
