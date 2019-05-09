import 'package:lemurs_of_madagascar/utils/constants.dart';
import 'package:flutter/material.dart';

class Sighting {

  static String idKey          = "_id";
  static String nidKey         = "_nid";
  static String uuidKey        = "_uuid";
  static String speciesNameKey = "_speciesName";
  static String speciesNidKey  = "_speciesNid";
  static String speciesCountKey = "_speciesCount";
  static String placeNameKey   = "_placeName";
  static String longKey        = "_placeLongitude";
  static String latKey         = "_placeLatitude";
  static String photoFileNamesKey = "_photoFileNames";
  static String titleKey       = "_title";
  static String createdKey     = "_createdTime";
  static String modifiedKey    = "_modifiedTime";
  static String uidKey         = "_uid";
  static String isLocalKey     = "_isLocal";
  static String isSyncedKey    = "_isSynced";
  static String dateKey        = "_date";
  static String deletedKey     = "_deleted";
  static String placeNidKey    = "_place_name_reference_nid";
  static String lockedKey      = "_locked";
  static String altKey        = "_placeAltitude";
  static String hasPhotoChangedKey = "_hasPhotoChanged";


  int id =0;
  int nid =0;
  String uuid = "";
  String speciesName = "";
  int speciesNid = 0;
  int speciesCount = 0;
  String placeName = "";
  double latitude = 0.0;
  double longitude = 0.0;
  double altitude = 0.0;
  String photoFileName = "";
  String title = "";
  double created = 0.0;
  double modified = 0.0;
  int uid =0 ;
  int isLocal = -1;
  int isSynced = -1;
  double date = 0.0;
  int deleted = -1;
  int placeNID = 0;
  int locked = -1;
  int hasPhotoChanged = -1;


  Sighting({this.id,this.uuid,this.nid,this.speciesName,
            this.speciesNid,this.speciesCount,this.placeName,this.latitude,
            this.longitude,this.altitude,this.photoFileName,this.title,
            this.created,this.modified,this.uid,this.isLocal,
            this.isSynced,this.date,this.deleted,this.placeNID,
            this.locked,this.hasPhotoChanged});


  Map<String, dynamic> toMap(){

    var map = Map<String, dynamic>();

    if(id != null){
      map[Sighting.idKey] = this.id;
    }

    map[Sighting.nidKey]  = this.nid;
    map[Sighting.uuidKey] = this.uuid;
    map[Sighting.speciesNameKey]  = this.speciesName;
    map[Sighting.speciesNidKey]  = this.speciesNid;
    map[Sighting.speciesCountKey] = this.speciesCount;
    map[Sighting.placeNameKey]    = this.placeName;
    map[Sighting.longKey]      = this.longitude;
    map[Sighting.latKey]       = this.latitude;
    map[Sighting.photoFileNamesKey]   = this.photoFileName;
    map[Sighting.titleKey]= this.title;
    map[Sighting.createdKey] = this.created;
    map[Sighting.modifiedKey] = this.modified;
    map[Sighting.uidKey]  = this.uid;
    map[Sighting.isLocalKey]  = this.isLocal;
    map[Sighting.isSyncedKey] = this.isSynced;
    map[Sighting.dateKey]      = this.date;
    map[Sighting.deletedKey]  = this.deleted;
    map[Sighting.placeNidKey] = this.placeNID;
    map[Sighting.lockedKey]      = this.locked;
    map[Sighting.altKey]      = this.altitude;
    map[Sighting.hasPhotoChangedKey] = this.hasPhotoChanged;

    return map;
  }

  Sighting.fromMap(Map<String, dynamic> map){

    this.id = map[Sighting.idKey] ;
    this.nid = map[Sighting.nidKey]  ;
    this.uuid = map[Sighting.uuidKey];
    this.speciesName = map[Sighting.speciesNameKey]  ;
    this.speciesNid = map[Sighting.speciesNidKey]  ;
    this.speciesCount = map[Sighting.speciesCountKey] ;
    this.placeName = map[Sighting.placeNameKey]    ;
    this.longitude = map[Sighting.longKey]      ;
    this.latitude = map[Sighting.latKey]       ;
    this.photoFileName = map[Sighting.photoFileNamesKey]   ;
    this.title = map[Sighting.titleKey];
    this.created = map[Sighting.createdKey] ;
    this.modified = map[Sighting.modifiedKey] ;
    this.uid = map[Sighting.uidKey]  ;
    this.isLocal = map[Sighting.isLocalKey]  ;
    this.isSynced = map[Sighting.isSyncedKey] ;
    this.date = map[Sighting.dateKey]      ;
    this.deleted = map[Sighting.deletedKey]  ;
    this.placeNID = map[Sighting.placeNidKey] ;
    this.locked = map[Sighting.lockedKey]      ;
    this.altitude = map[Sighting.altKey]      ;
    this.hasPhotoChanged = map[Sighting.hasPhotoChangedKey] ;
  }


  static Widget buildSightingPhoto(Sighting sighting,{double width = Constants.listViewImageWidth,double height = Constants.listViewImageHeight}) {

    Widget widget;
    BorderRadius _borderRadius;

    _borderRadius = BorderRadius.circular(Constants.speciesImageBorderRadius);
    widget = Container(
        child: ClipRRect(
            borderRadius: _borderRadius,
            child: Sighting.loadImage(sighting)));

    return widget;
  }


  static Widget loadImage(Sighting  sighting,
      {double width = Constants.listViewImageWidth,
        double height = Constants.listViewImageWidth}) {
    return Image.asset(
          sighting.photoFileName,
          width: width,
          height: height,
        );
  }

  static Widget buildTextInfo(Sighting sighting,{bool showMalagasy = true,CrossAxisAlignment crossAlignment = CrossAxisAlignment.start}) {
    return Expanded(
      child: Column(
          crossAxisAlignment: crossAlignment,
          children: <Widget>[
            Text(sighting.title),
            Container(height: 10),
          ]),
    );
  }

  @override
  String toString(){
    return  this.photoFileName ;
  }

}