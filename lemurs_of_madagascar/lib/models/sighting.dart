import 'dart:io';
import 'package:intl/intl.dart';
import 'package:lemurs_of_madagascar/data/rest_data.dart';
import 'package:lemurs_of_madagascar/database/sighting_database_helper.dart';
import 'package:lemurs_of_madagascar/database/site_database_helper.dart';
import 'package:lemurs_of_madagascar/database/species_database_helper.dart';
import 'package:lemurs_of_madagascar/models/photograph.dart';
import 'package:lemurs_of_madagascar/models/site.dart';
import 'package:lemurs_of_madagascar/models/species.dart';
import 'package:lemurs_of_madagascar/models/user.dart';
import 'package:lemurs_of_madagascar/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:lemurs_of_madagascar/utils/error_handler.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';


abstract class SyncSightingContract {
  void onSyncSuccess(Sighting sighting,int nid,bool editing);
  void onSyncFailure(int statusCode);
  void onSocketFailure();
}

class SyncSightingPresenter {

  SyncSightingContract _syncingView;
  RestData api = RestData();
  SyncSightingPresenter(this._syncingView);

  sync(Sighting sighting,{bool editing=false}) {
    if(sighting != null) {
       api.syncSighting(sighting,editing: editing)
          .then((nid) {
            print("presenter $nid");
            _syncingView.onSyncSuccess(sighting,nid,editing);
          })
          .catchError((error) {
            if(error is SocketException) _syncingView.onSocketFailure();
            if(error is LOMException) _syncingView.onSyncFailure(error.statusCode);
          });
    }
  }
}


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

  Future<int> saveToDatabase(bool editing) async {

    Future<User> user = User.getCurrentUser();

    return user.then((user) async {

      try {
        if (user != null && user.uid != 0 && user.uuid != null) {
          //print("[BEFORE] $editing ${this.toString()}");

          this.uid = user.uid;

          //this.nid = this.nid; //Random().nextInt(65000);

          var _uuid = Uuid();
          this.uuid = editing ? this.uuid : _uuid.v1(); // time-based

          this.speciesNid  = this.species?.id != null ? this.species.id : this.speciesNid;
          this.speciesName = this.species?.title != null ? this.species.title : this.speciesName;
          this.placeNID = this.site?.id != null ? this.site.id : this.placeNID;
          this.placeName =
          this.site?.title != null ? this.site.title : this.placeName;

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

          this.uid = this.uid == null ? user.uid : this.uid;

          Photograph defaultImage = await this._species
              .getPhotographObjectAtIndex(0);
          this.photoFileName = this.photoFileName != null
              ? this.photoFileName
              : defaultImage.photoAssetPath(ext: Constants.imageType);
          //print("SIGHTING SAVE TO DB image photo name :" + this.photoFileName);

          this.isLocal = 1;
          this.isSynced = 0;
          this.deleted = 0;

          this.locked = 0;
          this.hasPhotoChanged = 0;

          SightingDatabaseHelper db = SightingDatabaseHelper();
          Future<int> id;

          if (editing) {
            id = db.updateSighting(this);
          }
          else {
            id = db.insertSighting(this);
          }

          return id.then((newID) {
            return newID;
          });

        } else {
          print("[Sighting::saveToDatabase()] no User logged-in!");
          return 0;
        }

      }catch(e) {
        print("[Sighting::saveToDatabase()] Exception ${e.toString()}");
        throw e;
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

    try {
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
      this.altitude = double.tryParse(map[Sighting.altKey].toString()) ?? 0.0;
      this.hasPhotoChanged = map[Sighting.hasPhotoChangedKey];

      loadSpeciesAndSite();

    }catch(e){
      print("[SIGHTING::Sighting.fromMap()] error :"+e.toString());
      throw(e);
    }


  }


  Future<bool> loadSpeciesAndSite() async  {

    return this._loadSpecies().then((finished){
      if(finished){
        this._loadSite().then((finished){
          return finished;
        });
      }
      return finished;
    });

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
      this._site = await db.getSiteWithID(this.placeNID);
      return true;
    }
    return false;
  }


  static Widget buildCellInfo(Sighting sighting,BuildContext buildContext,
      {bool lookInAssetsFolder = false,
      CrossAxisAlignment crossAlignment = CrossAxisAlignment.start}) {
    String formattedDate = DateFormat.yMMMMd("en_US")
        .format(DateTime.fromMillisecondsSinceEpoch(sighting.date.toInt()));

    if(sighting != null) {

      double screenWidth = MediaQuery.of(buildContext).size.width;

      return Column(crossAxisAlignment: crossAlignment, children: <Widget>[

        FutureBuilder<Container>(
            future:
              Sighting.getImageContainer(
              sighting,
              width:screenWidth,
              height:Constants.sightingListImageHeight,
              fittedImage: true,
              assetImage: true),

            builder: (context, snapshot) {
              if(!snapshot.hasData){
                return Center(child:CircularProgressIndicator());
              }
              return snapshot.data;
            }
        ),

        Container(height: 5),
        Text(
          sighting.id.toString() + " " + sighting.nid.toString() + " " + sighting.speciesName,
          style: Constants.sightingSpeciesNameTextStyle,
        ),
        Container(height: 5),
        Row(
          //mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
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

    return Container();
  }

  static Future<Image> getImage(Sighting sighting)  async {

    if(sighting != null  && sighting.photoFileName.startsWith(Constants.appImagesAssetsFolder)){

      Species species = sighting.species;

      if(species == null){
        await sighting.loadSpeciesAndSite();
      }

      Future<Photograph> photo = sighting._species.getPhotographObjectAtIndex(0);

      return photo.then((photograph){

        if(photograph != null) {

          String assetPath = photograph.photoAssetPath(ext: Constants.imageType);
          Image image = Image.asset(assetPath);

          return image;
        }

        return null;

      });

    }


    return getApplicationDocumentsDirectory().then((folder) {

      if(folder != null) {

        String fullPath = join(folder.path, sighting.photoFileName);

        File file = File(fullPath);

        if (file.existsSync()) {
          return Image.file(file,);// Return image from Documents
        }

      }

      return null;

    });


  }

  static Future<File> getImageFile(Sighting sighting)  async {

    if(sighting != null  && sighting.photoFileName.startsWith(Constants.appImagesAssetsFolder)){

      Species species = sighting.species;

      if(species == null){
        await sighting.loadSpeciesAndSite();
      }

      Future<Photograph> photo = sighting._species.getPhotographObjectAtIndex(0);

      return photo.then((photograph){

        if(photograph != null) {

          String assetPath = photograph.photoAssetPath(ext: Constants.imageType);
          File file = File(assetPath);
          return file;
        }

        return null;

      });

    }


    return getApplicationDocumentsDirectory().then((folder) {

      if(folder != null) {

        String fullPath = join(folder.path, sighting.photoFileName);

        File file = File(fullPath);

        if (file.existsSync()) {
          return file;
        }

      }

      return null;

    });


  }

  static Future<Container> getImageContainer(Sighting sighting,
      {double width = 1280.0 ,
        double height = Constants.sightingListImageHeight,
        bool fittedImage = false,
        BoxFit standardFit = BoxFit.cover,
        BoxFit assetImageFit = BoxFit.fitHeight  ,
        bool assetImage=false})  async {

    if (sighting != null) {

      Future<Image> image = Sighting.getImage(sighting);

      return image.then( (_image) {

        bool assetImage = sighting.photoFileName.startsWith(Constants.appImagesAssetsFolder);

        return Container(
          height: height,
          width:width,
          child: ! fittedImage ?
            _image
              :
          FittedBox(fit: assetImage ? assetImageFit : standardFit, child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [_image])),
        ); // Return image from Documents

      });
    }

    return Container();

  }


  static void deleteAllSightings() {
    SightingDatabaseHelper.deleteAllSightings();
  }

  @override
  String toString() {
    return "\n[ID]:${this.id}  -  [NID]:${this.nid}  -  [title]:${this.title}  - [species NID]:${this.speciesNid} - [species name]:${this.speciesName}   - [photo]:${this.photoFileName}  - [date]:${this.date.toString()}  - [count]:${this.speciesCount}  - [long]:${this.longitude}  - [lat]:${this.latitude}  - [alt]:${this.altitude}  - [place NID]:${this.placeNID} - [placename]:${this.placeName}";
  }
}
