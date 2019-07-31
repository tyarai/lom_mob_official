import 'package:flutter/material.dart';
import 'package:lemurs_of_madagascar/utils/constants.dart';

class Illustration {

  static String _illustrationDescriptionKey = "_illustration_description";
  static String _illstrationKey = "_illustration";
  static String _nidKey = "_nid";

  String _illustration;
  String _illustrationDescription;
  int _nid;


  factory Illustration.withIllustration(Illustration illustration){
    return Illustration.withID(illustration._nid, illustration._illustration,
        illustration._illustrationDescription);
  }

  Illustration(this._illustration, this._illustrationDescription);

  Illustration.withID(this._nid, this._illustration,
      this._illustrationDescription);


  int get nid => _nid;

  String get illustration => _illustration;

  String get illustrationDescription => _illustrationDescription;

  set illustration(String value) {
    if (value.length <= 255) {
      this._illustration = value;
    }
  }

  set illustrationDescription(String value) {
    if (value.length <= 255) {
      this._illustrationDescription = value;
    }
  }

  String illustrationAssetPath({String ext = Constants.imageType}) {
    return Constants.appImagesAssetsFolder + this._illustration + "." + ext;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if (_nid != null) {
      map[_nidKey] = this._nid;
    }

    map[_illstrationKey] = this._illustration;
    map[_illustrationDescription] = this._illustrationDescription;
    return map;
  }

  Illustration.fromMap(Map<String, dynamic> map) {
    this._nid = map[_nidKey];
    this._illustration = map[_illstrationKey];
    this._illustrationDescription = map[_illstrationKey];
  }

    Image getIllustrationWidget(
        {String path = "assets/images/", String ext = ".jpg"}) {
      return Image.asset(path + this._illustration + ext);
    }

    ExactAssetImage getExactAssetImage(
        {String path = "assets/images/", String ext = ".jpg"}) {
      return ExactAssetImage(path + this._illustration + ext);
    }
  
}


