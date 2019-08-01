import 'package:flutter/material.dart';
import 'package:lemurs_of_madagascar/database/lom_map_database_helper.dart';
import 'package:lemurs_of_madagascar/utils/constants.dart';

class LOMMap {

  static String fileNameKey = "_file_name";
  static String nidKey      = "_nid";

  String _fileName = "";
  int    _nid = 0;


  factory LOMMap.withMap(LOMMap map){
    return LOMMap.withID(map._nid, map._fileName);
  }

  LOMMap();

  LOMMap.withID(this._nid, this._fileName);


  int get nid => _nid;

  String get fileName => _fileName;

  set fileName(String value) {
    if (value.length <= 255) {
      this._fileName = value;
    }
  }

  set nid(int value) {
    if (value > 0) {
      this._nid = value;
    }
  }

  String mapAssetPath() {
    return Constants.appImagesAssetsFolder + this._fileName ;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if (_nid != null) {
      map[nidKey] = this._nid;
    }

    map[fileNameKey] = this._fileName;
    return map;
  }

  LOMMap.fromMap(Map<String, dynamic> map) {
    this._nid = map[nidKey];
    this._fileName = map[fileNameKey];
  }

  Image getMapWidget(
      {String path = "assets/images/"}) {
    return Image.asset(path + this._fileName);
  }

  ExactAssetImage getExactAssetImage({String path = "assets/images/"}) {
    return ExactAssetImage(path + this._fileName);
  }

  Future<String> getLOMMapFileName() async {
    LOMMapDatabaseHelper db = LOMMapDatabaseHelper();
    LOMMap _lomMap = await db.getLOMMapWithID(id:this._nid);
    return _lomMap.fileName;
  }

}


