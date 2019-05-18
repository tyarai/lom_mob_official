import 'dart:io';

import 'package:intl/intl.dart';
import 'package:lemurs_of_madagascar/database/sighting_database_helper.dart';
import 'package:lemurs_of_madagascar/database/site_database_helper.dart';
import 'package:lemurs_of_madagascar/database/species_database_helper.dart';
import 'package:lemurs_of_madagascar/models/photograph.dart';
import 'package:lemurs_of_madagascar/models/site.dart';
import 'package:lemurs_of_madagascar/models/species.dart';
import 'package:lemurs_of_madagascar/models/user.dart';
import 'package:lemurs_of_madagascar/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:lemurs_of_madagascar/utils/user_session.dart';
import 'package:uuid/uuid.dart';

class Sighting {
  static String idKey = "_id";
  static String nidKey = "_nid";
  static String uuidKey = "_uuid";
  static String speciesNameKey = "_speciesName";
  static String speciesNidKey = "_speciesNid";
  static String speciesCountKey = "_speciesCount";
  static String placeNameKey = "_placeName";
  static String longKey = "_placeLongitude";
  static String latKey = "_placeLatitude";
  static String photoFileNamesKey = "_photoFileNames";
  static String titleKey = "_title";
  static String createdKey = "_createdTime";
  static String modifiedKey = "_modifiedTime";
  static String uidKey = "_uid";
  static String isLocalKey = "_isLocal";
  static String isSyncedKey = "_isSynced";
  static String dateKey = "_date";
  static String deletedKey = "_deleted";
  static String placeNidKey = "_place_name_reference_nid";
  static String lockedKey = "_locked";
  static String altKey = "_placeAltitude";
  static String hasPhotoChangedKey = "_hasPhotoChanged";

  Species _species;
  Site _site;

  int id = 0;
  int nid = 0;
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
  int uid = 0;

  int isLocal = -1;
  int isSynced = -1;
  double date = 0.0;
  int deleted = -1;
  int placeNID = 0;
  int locked = -1;
  int hasPhotoChanged = -1;

  factory Sighting.withSighting(Sighting sighting) {
    return Sighting(
        id: sighting.id,
        uuid: sighting.uuid,
        nid: sighting.nid,
        speciesName: sighting.speciesName,
        speciesNid: sighting.speciesNid,
        speciesCount: sighting.speciesCount,
        placeName: sighting.placeName,
        latitude: sighting.latitude,
        longitude: sighting.longitude,
        altitude: sighting.altitude,
        photoFileName: sighting.photoFileName,
        title: sighting.title,
        created: sighting.created,
        modified: sighting.modified,
        uid: sighting.uid,
        isLocal: sighting.isLocal,
        isSynced: sighting.isSynced,
        date: sighting.date,
        deleted: sighting.deleted,
        placeNID: sighting.placeNID,
        locked: sighting.locked,
        hasPhotoChanged: sighting.hasPhotoChanged);
  }

  Sighting(
      {this.id,
      this.uuid,
      this.nid,
      this.speciesName,
      this.speciesNid,
      this.speciesCount,
      this.placeName,
      this.latitude,
      this.longitude,
      this.altitude,
      this.photoFileName,
      this.title,
      this.created,
      this.modified,
      this.uid,
      this.isLocal,
      this.isSynced,
      this.date,
      this.deleted,
      this.placeNID,
      this.locked,
      this.hasPhotoChanged}) {

    loadSpeciesAndSite();
  }

  Site get site => this._site;

  set site(Site value) => this._site = value;

  Species get species => this._species;

  set species(Species value) {
    this._species = value;
  }

  void saveToDatabase() async {


    Future<User> user = User.getCurrentUser();

    //Future<int> _uid = UserSession.loadCurrentUserUID();

    user.then((user) async {

      if(user != null) {

        this.uid = user.uid;

        var _uuid = Uuid();
        this.uuid = _uuid.v1(); // time-based
        //this.nid  = 0;
        this.speciesNid = this.species.id;
        this.placeName = this.site.title;

        this.date = this.date == null
            ? DateTime
            .now()
            .millisecondsSinceEpoch
            .toDouble()
            : this.date;
        this.created = this.created == null
            ? DateTime
            .now()
            .millisecondsSinceEpoch
            .toDouble()
            : this.created;
        this.modified = DateTime
            .now()
            .millisecondsSinceEpoch
            .toDouble();
        this.placeNID = this.site.id;
        this.uid = this.uid == null ? this.uid : this.uid;

        Photograph defaultImage =
        await this._species.getPhotographObjectAtIndex(0);
        this.photoFileName = this.photoFileName != null
            ? this.photoFileName
            : defaultImage.photoAssetPath(ext: Constants.imageType);
        print("SIGHTING SAVE TO DB image photo name :" + this.photoFileName);
        //this.isLocal    = 1;
        //this.isSynced   = 0;
        //this.deleted    = 0;

        //this.locked     = 0;
        //this.hasPhotoChanged = 0;
        //this.latitude   = this.latitude == 0 ? 0.0 : this.latitude;
        //this.longitude  = this.longitude  == 0 ? 0.0 : this.longitude;

        SightingDatabaseHelper db = SightingDatabaseHelper();
        Future<int> id = db.insertSighting(sighting: this);

        id.then((newID) {
          print("Insert successful! New id : $newID");
        });
      }

    });
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if (id != null) {
      map[Sighting.idKey] = this.id;
    }

    map[Sighting.nidKey] = this.nid;
    map[Sighting.uuidKey] = this.uuid;
    map[Sighting.speciesNameKey] = this.speciesName;
    map[Sighting.speciesNidKey] = this.speciesNid;
    map[Sighting.speciesCountKey] = this.speciesCount;
    map[Sighting.placeNameKey] = this.placeName;
    map[Sighting.longKey] = this.longitude;
    map[Sighting.latKey] = this.latitude;
    map[Sighting.photoFileNamesKey] = this.photoFileName;
    map[Sighting.titleKey] = this.title;
    map[Sighting.createdKey] = this.created;
    map[Sighting.modifiedKey] = this.modified;
    map[Sighting.uidKey] = this.uid;
    map[Sighting.isLocalKey] = this.isLocal;
    map[Sighting.isSyncedKey] = this.isSynced;
    map[Sighting.dateKey] = this.date;
    map[Sighting.deletedKey] = this.deleted;
    map[Sighting.placeNidKey] = this.placeNID;
    map[Sighting.lockedKey] = this.locked;
    map[Sighting.altKey] = this.altitude;
    map[Sighting.hasPhotoChangedKey] = this.hasPhotoChanged;

    return map;
  }

  Sighting.fromMap(Map<String, dynamic> map) {
    this.id = map[Sighting.idKey];
    this.nid = map[Sighting.nidKey];
    this.uuid = map[Sighting.uuidKey];
    this.speciesName = map[Sighting.speciesNameKey];
    this.speciesNid = map[Sighting.speciesNidKey];
    this.speciesCount = map[Sighting.speciesCountKey];
    this.placeName = map[Sighting.placeNameKey];
    this.longitude = map[Sighting.longKey];
    this.latitude = map[Sighting.latKey];
    this.photoFileName = map[Sighting.photoFileNamesKey];
    this.title = map[Sighting.titleKey];
    this.created = map[Sighting.createdKey];
    this.modified = map[Sighting.modifiedKey];
    this.uid = map[Sighting.uidKey];
    this.isLocal = map[Sighting.isLocalKey];
    this.isSynced = map[Sighting.isSyncedKey];
    this.date = map[Sighting.dateKey];
    this.deleted = map[Sighting.deletedKey];
    this.placeNID = map[Sighting.placeNidKey];
    this.locked = map[Sighting.lockedKey];
    this.altitude = map[Sighting.altKey];
    this.hasPhotoChanged = map[Sighting.hasPhotoChangedKey];

    loadSpeciesAndSite();

  }


  Future<bool> loadSpeciesAndSite() async  {

    await this._loadSpecies().then((finished){
      if(finished){
        this._loadSite().then((finished){
          print("LOADED DATA");
          return finished;

        });
      }
      return finished;
    });

    return false;

  }

  Future<bool> _loadSpecies() async {
    if (this.speciesNid != 0) {
      SpeciesDatabaseHelper speciesDatabaseHelper = SpeciesDatabaseHelper();
      this._species =
          await speciesDatabaseHelper.getSpeciesWithID(this.speciesNid);
      //print("******** SIGHTING LOADED SPECIE : "+ this._species.title);
      return true;
    }
    return false;
  }

  Future<bool> _loadSite() async {
    if (this.placeNID != 0) {
      SiteDatabaseHelper db = SiteDatabaseHelper();
      this._site = await db.getSiteWithID(this.speciesNid);
      return true;
    }
    return false;
  }


  static Widget getImage(Sighting sighting) {
    if (sighting != null && sighting.photoFileName.length != 0) {
      if (!sighting.photoFileName.startsWith(Constants.appImagesAssetsFolder)) {
        File file = File(sighting.photoFileName);
        if (file.existsSync()) {
          return Container(
              child: Image.file(file)); // Return image from Documents
        }
      } else {
        return Container(
            child: Image.asset(
                sighting.photoFileName)); // Return image from assets
      }
    }

    return Container(
      child: Icon(Icons.camera,
          size: Constants.cameraPhotoPlaceHolder,
          color: Constants.cameraPlaceHolderColor),
    );
  }

  static Widget buildCellInfo(Sighting sighting,
      {bool lookInAssetsFolder = false,
      CrossAxisAlignment crossAlignment = CrossAxisAlignment.start}) {
    String formattedDate = DateFormat.yMMMMd("en_US")
        .format(DateTime.fromMillisecondsSinceEpoch(sighting.date.toInt()));

    return Column(crossAxisAlignment: crossAlignment, children: <Widget>[
      //Image.file(File(sighting.photoFileName)),
      Sighting.getImage(sighting),
      Container(height: 5),
      Text(
        sighting.speciesName,
        style: Constants.sightingSpeciesNameTextStyle,
      ),
      //sighting.species?.getItemCell(ListProvider provider,int index,BuildContext context, OnSelectCallback onSelectCallback);
      Container(height: 5),
      Row(
          //mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //Image.asset("assets/images/icons/ico_specy.png",width: 25,height: 25,color: Constants.mainColor,),
            //Container(width: 5),
            Expanded(
              child: Column(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      sighting.speciesCount.toString() + " species observed",
                      style: Constants.sightingSpeciesCountTextStyle,
                    )
                  ]),
            ),
            Container(width: 10),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      formattedDate,
                      style: Constants.sightingSpeciesCountTextStyle,
                    )
                  ]),
            ),
          ]),
      Container(height: 5),
      Text(
        sighting.placeName,
        style: Constants.sightingSpeciesCountTextStyle,
      ),
      Container(height: 10),
      Text(
        sighting.title,
        style: Constants.sightingTitleTextStyle,
      )
    ]);
  }

  static void deleteAllSightings() {
    SightingDatabaseHelper.deleteAllSightings();
  }

  @override
  String toString() {
    return "[ID]:${this.id} \n [title]:${this.title} \n[species]:${this.speciesName}  \n[photo]:${this.photoFileName} \n[date]:${this.date.toString()} \n[count]:${this.speciesCount} \n[long]:${this.longitude} \n[lat]:${this.latitude} \n[alt]:${this.altitude} \n[placename]:${this.placeName}";
  }
}
