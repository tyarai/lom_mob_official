import 'dart:io';
import 'package:intl/intl.dart';
import 'package:lemurs_of_madagascar/bloc/bloc_provider/bloc_provider.dart';
import 'package:lemurs_of_madagascar/bloc/sighting_bloc/sighting_bloc.dart';
import 'package:lemurs_of_madagascar/data/rest_data.dart';
import 'package:lemurs_of_madagascar/database/sighting_database_helper.dart';
import 'package:lemurs_of_madagascar/database/site_database_helper.dart';
import 'package:lemurs_of_madagascar/database/species_database_helper.dart';
import 'package:lemurs_of_madagascar/database/tag_database_helper.dart';
import 'package:lemurs_of_madagascar/models/photograph.dart';
import 'package:lemurs_of_madagascar/models/site.dart';
import 'package:lemurs_of_madagascar/models/species.dart';
import 'package:lemurs_of_madagascar/models/tag.dart';
import 'package:lemurs_of_madagascar/models/user.dart';
import 'package:lemurs_of_madagascar/screens/sightings/sighting_comment_page.dart';
import 'package:lemurs_of_madagascar/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:lemurs_of_madagascar/utils/error_handler.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';


abstract class SyncSightingContract {
  void onSyncSuccess(Sighting sighting, int nid, bool editing);
  void onDeleteSuccess(Sighting sighting);
  void onSyncFailure(int statusCode);
  void onSocketFailure();
}

abstract class GetSightingsContract {
  void onGetSightingSuccess(List<Sighting> sightingList);
  void onGetSightingFailure(int statusCode);
  void onSocketFailure();
}

class SyncSightingPresenter {

  SyncSightingContract _syncingView;
  RestData api = RestData();
  SyncSightingPresenter(this._syncingView);

  sync(Sighting sighting, {bool editing = false}) {

    if (sighting != null) {

      api.syncSighting(sighting, editing: editing).then((nid) {

        print("SyncSightingPresenter $nid");
        _syncingView.onSyncSuccess(sighting, nid, editing);

      }).catchError((error) {
        if (error is SocketException) _syncingView.onSocketFailure();
        if (error is LOMException) _syncingView.onSyncFailure(error.statusCode);
      });

    }

  }

  delete(Sighting sighting) {
    if (sighting != null) {
      api.deleteSighting(sighting).then((isDeleted) {
        if (isDeleted) {
          _syncingView.onDeleteSuccess(sighting);
        }
      }).catchError((error) {
        if (error is SocketException) _syncingView.onSocketFailure();
        if (error is LOMException) _syncingView.onSyncFailure(error.statusCode);
      });
    }
  }

}

class GetSightingPresenter {

  GetSightingsContract _getView;
  RestData api = RestData();
  GetSightingPresenter(this._getView);

  get(DateTime fromDate) {

    api.getSightings(fromDate).then((sightingList) {

      if(sightingList.length != 0) {
        print("GetSightingPresenter ${sightingList.toString()}");
        _getView.onGetSightingSuccess(sightingList);
      }

    }).catchError((error) {
      if (error is SocketException) _getView.onSocketFailure();
      if (error is LOMException) _getView.onGetSightingFailure(error.statusCode);
    });



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
  static String authorNameKey = "_author_name";
  static String isLocalKey = "_isLocal";
  static String isSyncedKey = "_isSynced";
  static String dateKey = "_date";
  static String deletedKey = "_deleted";
  static String placeNidKey = "_place_name_reference_nid";
  static String lockedKey = "_locked";
  static String altKey = "_placeAltitude";
  static String hasPhotoChangedKey = "_hasPhotoChanged";
  static String activityTagTidKey = "_activityTagTid";

  Species _species;
  Site _site;
  Tag _tag;

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
  //int illegal = 0;
  int activityTagTid = 0;

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
        hasPhotoChanged: sighting.hasPhotoChanged,
        //illegal:sighting.illegal,
        activityTagTid: sighting.activityTagTid);
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
      this.hasPhotoChanged,
      //this.illegal,
      this.activityTagTid}) {
    loadSpeciesAndSiteAndTag();
  }

  Site get site => this._site;

  Tag get tag => this._tag;

  set tag(Tag value) => this._tag = value;

  set site(Site value) => this._site = value;

  Species get species => this._species;

  initProperties(User user,bool editing) async {

    this.uid = user.uid;
    var _uuid = Uuid();
    this.uuid = editing ? this.uuid : _uuid.v1(); // time-based
    this.speciesNid =
    this.species?.id != null ? this.species.id : this.speciesNid;
    this.speciesName = this.species?.title != null
        ? this.species.title
        : this.speciesName;
    this.placeNID = this.site?.id != null ? this.site.id : this.placeNID;
    this.placeName =
    this.site?.title != null ? this.site.title : this.placeName;


    this.date = this.date == null
        ? DateTime.now().millisecondsSinceEpoch.toDouble()
        : this.date;

    this.created = this.created == null
        ? DateTime.now().millisecondsSinceEpoch.toDouble()
        : this.created;

    this.modified = DateTime.now().millisecondsSinceEpoch.toDouble();

    this.uid = this.uid == null ? user.uid : this.uid;

    Photograph defaultImage =
        await this._species?.getPhotographObjectAtIndex(0);
    this.photoFileName = this.photoFileName != null
        ? this.photoFileName
        : defaultImage?.photoAssetPath(ext: Constants.imageType);
    //print("SIGHTING photo name :" + this.photoFileName);

    this.isLocal = 1;
    this.isSynced = 0;
    this.deleted = 0;

    this.locked = 0;
    this.hasPhotoChanged = 0;

  }

  Future<Sighting> saveToDatabase(bool editing,{int nid}) async {

    Future<User> user = User.getCurrentUser();

    return user.then((user) async {
      try {
        if (user != null && user.uid != 0 && user.uuid != null) {

          initProperties(user,editing);

          SightingDatabaseHelper db = SightingDatabaseHelper();
          Future<int> id;

          if (editing) {
            id = db.updateSighting(this,nid:nid);
          } else {
            id = db.insertSighting(this);
          }

          return id.then((result) {
            if (result > 0) {
              if (!editing) {
                this.id = result; // newly created sighting
              }
              return this;
            } else {
              return null;
            }
          });
        } else {
          print("[Sighting::saveToDatabase()] no User logged-in!");
          return null;
        }
      } catch (e) {
        print("[Sighting::saveToDatabase()] Exception ${e.toString()}");
        throw e;
      }

    });

  }

  Future<bool> delete() async {
    try {
      SightingDatabaseHelper db = SightingDatabaseHelper();
      db.deleteSighting(sighting: this).then((deletedRow) {
        //print("deleted Row $deletedRow");
        if (deletedRow > 0) {
          return true;
        } else {
          return false;
        }
      });
    } catch (e) {
      print("{Sighting::delete()} Exception " + e.toString());
    }
    return false;
  }

  set species(Species value) {
    this._species = value;
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
    //map[Sighting.isIllegalKey] = this.illegal;
    map[Sighting.activityTagTidKey] = this.activityTagTid;

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
      this.longitude = double.tryParse(map[Sighting.longKey].toString()) ?? 0.0;
      this.latitude = double.tryParse(map[Sighting.latKey].toString()) ?? 0.0 ;
      this.photoFileName = map[Sighting.photoFileNamesKey];
      this.title = map[Sighting.titleKey];
      this.created = double.tryParse(map[Sighting.createdKey].toString()) ?? 0.0;
      this.modified = double.tryParse(map[Sighting.modifiedKey].toString()) ?? 0.0;
      this.uid = map[Sighting.uidKey];
      this.isLocal = map[Sighting.isLocalKey];
      this.isSynced = map[Sighting.isSyncedKey];
      this.date = double.tryParse(map[Sighting.dateKey].toString()) ?? 0.0;
      this.deleted = map[Sighting.deletedKey];
      this.placeNID = map[Sighting.placeNidKey];
      this.locked = map[Sighting.lockedKey];
      this.altitude = double.tryParse(map[Sighting.altKey].toString()) ?? 0.0;
      this.hasPhotoChanged = map[Sighting.hasPhotoChangedKey];
      //this.illegal = map[Sighting.isIllegalKey];
      this.activityTagTid = (map[Sighting.activityTagTidKey] != 0 && map[Sighting.activityTagTidKey] != null) ? map[Sighting.activityTagTidKey] : null;

      loadSpeciesAndSiteAndTag();
    } catch (e) {
      print("[SIGHTING::Sighting.fromMap()] error :" + e.toString());
      throw (e);
    }
  }

  //Future<bool> loadSpeciesAndSiteAndTag() async  {
  loadSpeciesAndSiteAndTag() async {
    //this._species = null;
    //this._site    = null;
    //this._tag     = null;

    /*return this._loadSpecies().then((finished){
      if(finished){
        this._loadSite().then((finished){
          if(finished){
            return this._loadTag();
          }
          //return finished;
        });
      }
      return finished;
    });*/

    await this.loadSpecies();
    await this.loadSite();
    await this.loadTag();
  }

  Future<bool> loadSpecies() async {
    this._species = null;

    if (this.speciesNid != 0) {
      SpeciesDatabaseHelper speciesDatabaseHelper = SpeciesDatabaseHelper();
      this._species =
          await speciesDatabaseHelper.getSpeciesWithID(this.speciesNid);
      //print("******** SIGHTING LOADED SPECIE : "+ this._species.title);
      return true;
    }
    return false;
  }

  Future<bool> loadTag() async {
    //print("[tid] ${this.activityTagTid}");
    this._tag = null;

    if (this.activityTagTid != 0 && this.activityTagTid != null) {
      TagDatabaseHelper tagDatabaseHelper = TagDatabaseHelper();
      this._tag =
          await tagDatabaseHelper.getActivityTagWithTID(this.activityTagTid);
      //print('current tag ' + this._tag.toString());
      return true;
    }
    return false;
  }

  Future<bool> loadSite() async {
    this._site = null;
    if (this.placeNID != 0) {
      SiteDatabaseHelper db = SiteDatabaseHelper();
      this._site = await db.getSiteWithID(this.placeNID);
      return true;
    }
    return false;
  }

  static _commentButtonPressed(
      Sighting sighting, SightingBloc sightingBloc, BuildContext buildContext) {
    Navigator.push(
        buildContext,
        MaterialPageRoute(
            builder: (context) => BlocProvider(
                  child: SightingCommentPage(sighting),
                  bloc: sightingBloc,
                )));
  }

  static buildAction(
      Sighting sighting, SightingBloc sightingBloc, BuildContext buildContext) {
    return Row(
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.insert_comment),
          color: Constants.mainColor,
          iconSize: 30,
          onPressed: () {
            _commentButtonPressed(sighting, sightingBloc, buildContext);
          },
        ),
      ],
    );
  }

  static Widget _buildSpeciesInfoAndTag(Sighting sighting){

    if(sighting != null) {

      return Row(children: [

        (sighting.speciesName != null) ? Text(
          //sighting.id.toString() +
          //  " " +
          //sighting.nid.toString() +
          //" " +
          sighting.speciesName,
          style: Constants.sightingSpeciesNameTextStyle,
        ) : Container(),
        //Spacer(),
        /*FutureBuilder<bool>(
          future: sighting.loadTag(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Container();
            if (snapshot.data != null && snapshot.hasData) {
              return sighting.tag != null
                  ? Text(
                sighting.tag.nameEN,
                style: Constants.sightingSpeciesNameTextStyle.copyWith(
                    color: Colors.red),
              )
                  : Container();
            }
          },
        ),*/

      ]);
    }

    return Container();
  }

  static Widget buildCellInfo(
      Sighting sighting, SightingBloc sightingBloc, BuildContext buildContext,
      {bool lookInAssetsFolder = false,
      CrossAxisAlignment crossAlignment = CrossAxisAlignment.start}) {

      try {

        int date = sighting.date.toInt();

        String formattedDate = DateFormat.yMMMMd("en_US")
            .format(DateTime.fromMillisecondsSinceEpoch(date));
        //String formattedDate = DateFormat.yMMMMd("en_US")
          //  .format(DateTime(date));

        print("DATE $date - $formattedDate");

        if (sighting != null) {
          double screenWidth = MediaQuery
              .of(buildContext)
              .size
              .width;

          return Column(crossAxisAlignment: crossAlignment, children: <Widget>[
            FutureBuilder<Container>(
                future: Sighting.getImageContainer(sighting, buildContext,
                    width: screenWidth,
                    height: Constants.sightingListImageHeight,
                    fittedImage: true,
                    assetImage: true),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return snapshot.data;
                }),
            Container(height: 10),
            _buildSpeciesInfoAndTag(sighting),
            Container(height: 10),
            Text(
              sighting.title,
              textAlign: TextAlign.justify,
              style: Constants.sightingTitleTextStyle,
            ),
            Container(height: 10),
            (sighting.placeName != null) ? Row(
                children: [
                  Icon(Icons.place, color: Colors.grey,),
                  Text(sighting.placeName,
                    style: Constants.sightingSpeciesCountTextStyle,
                  ),
                ]) : Container(),
            Container(height: 10),
            Row(
              //mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  sighting.speciesCount != null ? Expanded(
                    child: Column(
                      //mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            sighting.speciesCount.toString() +
                                " species observed",
                            style: Constants.sightingSpeciesCountTextStyle,
                          )
                        ]),
                  ) : Container(),
                  Spacer(),
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
            Container(height: 10),
            Divider(
                height: Constants.listViewDividerHeight,
                color: Constants.listViewDividerColor),
            Row(
                children: [

                  Expanded(
                    flex: 1,
                    child: FutureBuilder<bool>(
                      future: sighting.loadTag(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) return Container();
                        if (snapshot.data != null && snapshot.hasData) {
                          return sighting.tag != null
                              ? Text(
                            sighting.tag.nameEN,
                            style: Constants.sightingSpeciesNameTextStyle
                                .copyWith(
                                color: Colors.red),
                          )
                              : Container();
                        }
                      },
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(right: 10),),
                  Sighting.buildAction(sighting, sightingBloc, buildContext),
                ]),
          ]);
        }

      }catch(error){
        print("[Sighting::buildCellInfo()] Error :${error.toString()}");
      }

    return Container();
  }


  static Future<void> _downloadHttpImage(Sighting sighting) async {

    if (sighting != null && sighting.photoFileName != null  && sighting.photoFileName.startsWith(Constants.http)){

      var docFolder = await getApplicationDocumentsDirectory();
      Uri imageURI = Uri.parse(sighting.photoFileName);
      List<String> pathSegments = imageURI.pathSegments;
      String fileName = pathSegments[pathSegments.length - 1];

      HttpClient client = new HttpClient();
      var _downloadData = List<int>();
      var fileSave = new File(docFolder.path + "/" + fileName);

      client.getUrl(imageURI)
      .then((HttpClientRequest request) {
        return request.close();

      })
      .then((HttpClientResponse response) {
        response.listen((d) => _downloadData.addAll(d),
          onDone: () {
            fileSave.writeAsBytes(_downloadData);
            print("SIGHTING::_downloadHttpImage() Success downloading : $fileName");
            //sighting.photoFileName = fileName;

          }
        );
        //return fileName;
      }).catchError((error){
        print("SIGHTING::_downloadHttpImage() Failure - downloading : $fileName");
      });
    }

    //return null;

  }

  static Future<Image> getImage(Sighting sighting) async {

    if(sighting != null && sighting.photoFileName.startsWith(Constants.http)){

      Uri imageURI = Uri.parse(sighting.photoFileName);
      List<String> pathSegments = imageURI.pathSegments;
      String fileName = pathSegments[pathSegments.length - 1];

      Future<void> _downLoad = Sighting._downloadHttpImage(sighting);
      _downLoad.then((_){
          //print("#10");
          //sighting.photoFileName = fileName;
          sighting.photoFileName = fileName;
          sighting.saveToDatabase(true,nid:sighting.nid).then((savedSighting){
            if(savedSighting != null){
              //print("UPDATED SIGHTING");
              //print("Getimage()" +sighting.toString());
            }
          }).catchError((error){
              print("Sighting::Getimage() Error unable to update sighting photo :" +error.toString());
          });

      });

      //sighting.saveToDatabase(true);
    }

    if (sighting != null &&
        sighting.photoFileName.startsWith(Constants.appImagesAssetsFolder)) {
      Species species = sighting.species;

      if (species == null) {
        await sighting.loadSpeciesAndSiteAndTag();
      }

      Future<Photograph> photo =
          sighting._species.getPhotographObjectAtIndex(0);

      return photo.then((photograph) {
        if (photograph != null) {
          String assetPath =
              photograph.photoAssetPath(ext: Constants.imageType);
          Image image = Image.asset(assetPath);

          return image;
        }

        return null;
      });
    }

    return getApplicationDocumentsDirectory().then((folder) {
      if (folder != null) {
        String fullPath = join(folder.path, sighting.photoFileName);
        print("SIGHTING PHOTO ${sighting.photoFileName}");

        File file = File(fullPath);

        if (file.existsSync()) {
          return Image.file(
            file,
          ); // Return image from Documents
        }
      }

      return null;
    });
  }

  static Future<File> getImageFile(Sighting sighting) async {

    try {

      if (sighting != null && sighting.photoFileName != null &&
          sighting.photoFileName.startsWith(Constants.appImagesAssetsFolder)) {

        Species species = sighting.species;

        if (species == null) {
          await sighting.loadSpeciesAndSiteAndTag();
        }

        Future<Photograph> photo =
            sighting._species.getPhotographObjectAtIndex(0);

        return photo.then((photograph) {
          if (photograph != null) {
            String assetPath =
                photograph.photoAssetPath(ext: Constants.imageType);
            File file = File(assetPath);
            return file;
          }

          return null;
        });
      }

      return getApplicationDocumentsDirectory().then((folder) {

        if (folder != null && sighting.photoFileName != null) {
          String fullPath = join(folder.path, sighting.photoFileName);

          File file = File(fullPath);

          if (file.existsSync()) {
            return file;
          }
        }

        return null;
      });

    } catch (e) {
      print("[Sighting::getImageFile()] Exception " + e.toString());
      throw e;
    }
  }

  static void deleteAllSightings() {
    SightingDatabaseHelper.deleteAllSightings();
  }

  static Future<Container> getImageContainer(
      Sighting sighting, BuildContext buildContext,
      {double width = 1280.0,
      double height = Constants.sightingListImageHeight,
      bool fittedImage = false,
      BoxFit standardFit = BoxFit.cover,
      BoxFit assetImageFit = BoxFit.fitHeight,
      bool assetImage = false}) async {

    if (sighting != null) {

      Future<Image> image = Sighting.getImage(sighting);

      return image.then((_image) {

        var fit = BoxFit.fitWidth;

        ImageStream imageStream =
            _image.image.resolve(createLocalImageConfiguration(buildContext));
        imageStream.addListener((imageInfo, _) {
          if (imageInfo.image.width < imageInfo.image.height) {
            fit = BoxFit.fitHeight;
          }
        });

        return Container(
          height:  height ,
          width: fit == BoxFit.fitHeight ? double.infinity : width,
          child: !fittedImage
              ? _image
              :
              //FittedBox(fit: assetImage ? assetImageFit : standardFit, child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [_image])),
              FittedBox(
                  fit: fit,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [_image])),
        ); // Return image from Documents

      });

    }

    return Container();
  }

  @override
  String toString() {
    return " [ID]:${this.id}  -  [NID]:${this.nid}  -  [title]:${this.title}  - [tagTID]:${this.activityTagTid} -  [species NID]:${this.speciesNid} - [species name]:${this.speciesName}   - [photo]:${this.photoFileName}  - [date]:${this.date.toString()}  - [count]:${this.speciesCount}  - [long]:${this.longitude}  - [lat]:${this.latitude}  - [alt]:${this.altitude}  - [place NID]:${this.placeNID} - [placename]:${this.placeName}";
  }
}
