
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'dart:core';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart';


class DatabaseHelper {


   String databaseName = "LOM.sqlite";
   int currentVersion = 11; // Starting from and needs to be updated each time we have new version

   //Make this class singleton
   DatabaseHelper._privateConstructor();

   static final DatabaseHelper instance =  DatabaseHelper._privateConstructor();

   //only have a single app-wide reference to the database
   static Database _database;


   Future<Database> get database async {

      if(_database != null) return _database;
      _database = await _initializeDatabase();
      return _database;
   }


   Future<Database> _initializeDatabase() async {
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




   _onUpgrade(Database db, int oldVersion, int newVersion) {}

   //@TODO : Check if we can find other method to copy the database to the working directory
   // This copy db function works if the database file size is less than 650MB. Actually
   // our original database size is about 1.5MB so it's okay.
   void writeToFile(ByteData data, String path) {
      final buffer = data.buffer;
      return new File(path).writeAsBytesSync(
          buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
   }


}

