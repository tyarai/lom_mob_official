import 'package:flutter/material.dart';
import 'package:lemurs_of_madagascar/database/database_helper.dart';
import 'package:lemurs_of_madagascar/database/photograph_database_helper.dart';
import 'package:lemurs_of_madagascar/utils/constants.dart';
import 'package:sqflite/sqlite_api.dart';

class Photograph {

  static String _titleKey       = "_title";
  static String _photographKey  = "_photograph";
  static String _idKey          = "_nid";

  String _title;
  String _photograph;
  int _id;


  factory Photograph.withPhotograph(Photograph photo){
    return Photograph.withID(photo.id, photo.title,photo.photograph);
  }
  Photograph(this._title, this._photograph);
  Photograph.withID(this._id, this._title,this._photograph);


  int get id => _id;
  String get title => _title;
  String get photograph => _photograph;

  set title(String value){
    if(value.length <= 255){
      this._title = value;
    }
  }

  set content(String value){
    this._photograph = value;
  }

  String photoAssetPath({String ext = Constants.imageType}){
    return Constants.appImagesAssetsFolder + this._photograph + "." +  ext;
  }

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();

    if(_id != null){
      map[_idKey] = this._id;
    }

    map[_titleKey]       = this._title;
    map[_photographKey]  = this._photograph;
    return map;
  }

  /*Photograph.fromDB(PhotographDatabaseHelper photoDBHelper){
    this._id         = photoDBHelper.;
    this._title      = map[_titleKey];
    this._photograph = map[_photographKey];
  }*/

  Photograph.fromMap(Map<String,dynamic> map) {
    try {
      this._id = map[_idKey];
      this._title = map[_titleKey];
      this._photograph = map[_photographKey];
    }catch(e){
      print("[Photograph.fromMap]"+e.toString());
    }
  }

  Image getImageWidget({String path = "assets/images/",String ext = ".jpg"}){
    return Image.asset(path+ this.photograph + ext);

  }

  ExactAssetImage getExactAssetImage({String path = "assets/images/",String ext = ".jpg"}){
    return ExactAssetImage(path+ this.photograph + ext);

  }

  Future<int> saveToDatabase(bool editing) async {

    try{

      PhotographDatabaseHelper db = PhotographDatabaseHelper();
      Future<int> id;
      Database database = await DatabaseHelper.instance.database;

      if (editing) {
        id = db.updatePhotograph(database:database,photo:this);
      }
      else {
        id = db.insertPhotograph(database: database,photo:this);
      }

      return id;

    }catch(e) {
      print("[Photograph::saveToDatabase()] Exception ${e.toString()}");
      throw e;
    }


  }


}


