
import "dart:async";
import "dart:convert";
import "dart:io";
import 'package:intl/intl.dart';
import 'package:lemurs_of_madagascar/models/comment.dart';
import 'package:lemurs_of_madagascar/models/photograph.dart';
import "package:lemurs_of_madagascar/models/sighting.dart";
import "package:lemurs_of_madagascar/utils/constants.dart";
import 'package:lemurs_of_madagascar/utils/lom_shared_preferences.dart';
import "package:lemurs_of_madagascar/utils/user_session.dart";
import "package:lemurs_of_madagascar/utils/network_util.dart";
import "package:lemurs_of_madagascar/models/user.dart";
import 'package:path/path.dart';
import 'package:flutter/services.dart' show rootBundle;

class RestData {

  static const errorKey = "error";
  static const formErrorKey = "form_errors"; // Used to track existing account created twice
  static const userStructureKey = "user";
  static const nodesKey = "nodes";

  NetworkUtil _networkUtil = NetworkUtil();

  //static const  SERVER               = "https://www.lemursofmadagascar.com/html";
  static const SERVER = "http://192.168.2.242";
  static const LOGIN_ENDPOINT = SERVER +
      "/lom_endpoint/api/v1/services/user/login.json";
  static const LOGOUT_ENDPOINT = SERVER +
      "/lom_endpoint/api/v1/services/user/logout.json";
  static const REGISTER_ENDPOINT = SERVER +
      "/lom_endpoint/api/v1/services/user/register.json";
  static const FILE_ENDPOINT = SERVER +
      "/lom_endpoint/api/v1/services/file.json";
  static const NODE_ENDPOINT = SERVER +
      "/lom_endpoint/api/v1/services/node.json";
  static const NODE_UPDATE_ENDPOINT = SERVER +
      "/lom_endpoint/api/v1/services/node/";
  static const ISCONNECTED_ENDPOINT = SERVER +
      "/lom_endpoint/api/v1/services/system/connect.json";
  static const SERVER_IMAGE_PATH = SERVER + "/sites/default/files/";
  static const ALL_PUBLICATION_ENDPOINT = SERVER + "/all-publication-json";
  static const MY_SIGHTINGS_ENDPOINT = SERVER +
      "/api/v1/list/sightings"; // Misy parameters isLocal
  static const ALL_MY_SIGHTINGS_ENDPOINT = SERVER +
      "/api/v1/list/all-my-sightings"; // Tsy misy parameter
  static const MY_SIGHTINGS_MODIFIED_FROM = SERVER +
      "/api/v1/list/my-sightings-modified-from";

  static const SERVICE_MY_SIGHTINGS = SERVER +
      "/lom_endpoint/api/v1/services/lom_sighting_services/changed_sightings"; //Parameters : "uid" and "from_date"
  static const COUNT_SIGHTINGS = SERVER +
      "/lom_endpoint/api/v1/services/lom_sighting_services/count_sightings"; //Parameters : "uid" (mandatory) and "from_date" (optional)
  static const RESET_SYNCED = SERVER +
      "/lom_endpoint/api/v1/services/lom_sighting_services/reset_synced"; //Parameters : "uid" (mandatory) and "synced_value" (optional)
  static const NEW_SIGHTING = SERVER +
      "/lom_endpoint/api/v1/services/lom_sighting_services/new_sighting";
  static const NEW_COMMENT = SERVER +
      "/lom_endpoint/api/v1/services/lom_sighting_services/new_comment";
  static const NEW_ILLEGALACTIVITY = SERVER +
      "/lom_endpoint/api/v1/services/lom_illegal_activities_services/new_illegal_activity";
  static const SYNC_ILLEGALACTIVITY_STATUS = SERVER +
      "/lom_endpoint/api/v1/services/lom_illegal_activities_services/update_status";
  static const EDIT_COMMENT = SERVER +
      "/lom_endpoint/api/v1/services/lom_sighting_services/edit_comment";
  static const CHANGED_COMMENTS = SERVER +
      "/lom_endpoint/api/v1/services/lom_sighting_services/changed_comments";
  static const LIFELIST_ENDPOINT = SERVER +
      "/api/v1/list/my-lemur-life-list-json";
  static const LIFELIST_ENDPOINT_MODIFIED_FROM = SERVER +
      "api/v1/list/my-lemur-life-list-modified-from";
  static const LAST_LOGIN_DATE = SERVER +
      "login_date"; //Ijerena raha vao ni-installer-na ilay app
  static const LAST_SYNC_DATE = SERVER + "last_sync_date";
  static const LAST_SERVER_SYNC_DATE = SERVER + "last_server_sync_date";
  static const UPDATE_TEXT = SERVER + "update_text";
  static const UPDATE_SYNC_DATE = SERVER + "update_sync_date";
  static const SPECIES_UPDATE_COUNT = SERVER + "species_update_count";
  static const MAP_UPDATE_COUNT = SERVER + "map_update_count";
  static const FAMILY_UPDATE_COUNT = SERVER + "family_update_count";
  static const PHOTO_UPDATE_COUNT = SERVER + "photo_update_count";
  static const PLACE_UPDATE_COUNT = SERVER + "place_update_count";

  // ************ SETTINGS WEB SERVICE ******************//
  static const SETTINGS_EXPORT_ENDPOINT = SERVER +
      "/lom_endpoint/api/v1/settings/lom_settings/export_settings"; // Misy param user_uid
  static const SETTINGS_IMPORT_ENDPOINT = SERVER +
      "/lom_endpoint/api/v1/settings/lom_settings/import_settings"; // Misy param user_uid, settings_name, settings_value
  // ************* CHANGED NODES SERVICE (Species, Map, Photograph, Family, Places) *******
  static const CHANGED_NODES = SERVER +
      "/lom_endpoint/api/v1/services/lom_node_services/changed_nodes"; // Misy parama from_date

  Future<List<dynamic>> login(String userName, String passWord) {
    print("login .....");

    Map<String, String> body = {
      "username": userName,
      "password": passWord
    };

    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Accept": "application/json"
    };

    return
      _networkUtil.post(LOGIN_ENDPOINT,
        body: json.encode(body),
        headers: headers,
      ).then((dynamic resultMap) {
        print("[REST_DATA::login()] " + resultMap.toString());

        if (resultMap[RestData.errorKey] != null) {
          //print("#2");
          throw new Exception(resultMap["error_msg"]);
        }

        List<dynamic> userAndSession = List();


        userAndSession.add(User.fromJSONMap(resultMap[userStructureKey]));
        userAndSession.add(UserSession.fromJSONMap(resultMap));
        return userAndSession;
      }).catchError((error) {
        print("[REST_DATA:login()] error:" + error.toString());
        throw error;
      });
  }

  Future<User> register(String userName, String passWord, String mail) {
    print("register .....");

    Map<String, String> body = {
      "account[name]": userName.trim(),
      "account[pass]": passWord.trim(),
      "account[mail]": mail.trim()
    };

    Map<String, String> headers = {
      "Content-Type": "application/x-www-form-urlencoded",
      "Accept": "application/json"
    };

    return _networkUtil.post(REGISTER_ENDPOINT,
      body: body,
      headers: headers,
    ).then((dynamic resultMap) {
      print("LOM :(register result): " + resultMap.toString());

      if (resultMap[RestData.errorKey] != null) {
        //print("#2");
        throw new Exception(resultMap["error_msg"]);
      }
      //print("#3"+ resultMap[User.uidKey]+ " " + userName+ " "+ passWord);

      return new User(uid: int.parse(resultMap[User.uidKey]),
          name: userName,
          password: passWord);
    }); /*.catchError((Object object) {

        return null;
        //throw new object;
    });*/


  }

  Future<bool> logOut(User user, UserSession session) async {
    if (user != null && session != null) {
      print("logout .....");

      String cookie = session.sessionName + "=" + session.sessionID;
      String token = session.token;

      Map<String, String> body = {
        "username": user.name
      };

      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Cookie": cookie,
        "X-CSRF-Token": token
      };

      return _networkUtil.post(LOGOUT_ENDPOINT,
        body: json.encode(body),
        headers: headers,
      ).then((dynamic resultMap) {
        //User.clearSharedPreferences(); // Clear all shared preferences

        print("LOM :(logout result): " + resultMap.toString());
        return true;
      }); /*.catchError((Object error) {
          return false;
      });*/
    }

    return false;
  }

  Future<int> syncFile(File file, String fileName) async {

      if (file != null && fileName != null) {
        List<int> byteData = List();
        String base6sString = "";
        int fileSize = 0;


        if (file.path.startsWith(Constants.appImagesAssetsFolder)) {
          // ----- SYNCING IMAGE OR FILE IN ASSETS FOLDER
          var _byteData = await rootBundle.load(file.path);
          final buffer = _byteData.buffer;
          base6sString = base64Encode(buffer.asUint8List());
          fileSize = buffer.lengthInBytes;
        } else {
          // ----- SYNCING IMAGE OR FILE IN DOCUMENTS FOLDER
          byteData = file.readAsBytesSync();
          base6sString = base64Encode(byteData);
          fileSize = await file.length();
        }


        UserSession currentSession = await UserSession.getCurrentSession();

        String cookie = currentSession.sessionName + "=" +
            currentSession.sessionID;
        String token = currentSession.token;

        Map<String, String> body = {
          "filename": fileName,
          "file": base6sString,
          "filepath": Constants.publicFolder + fileName,
          "filesize": fileSize.toString(),
        };

        Map<String, String> headers = {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Cookie": cookie,
          "X-CSRF-Token": token
        };

        return
          _networkUtil.post(FILE_ENDPOINT,
            body: json.encode(body),
            headers: headers,
          ).then((dynamic resultMap) {
            print("[REST_DATA::syncFile()] " + resultMap.toString());

            if (resultMap[RestData.errorKey] != null) {
              throw new Exception(resultMap["error_msg"]);
            }

            String fidKey = "fid";
            int fid = int.parse(resultMap[fidKey]);
            //int fid = resultMap[fidKey];

            return fid;

          }).catchError((error) {
            print("[REST_DATA::syncFile()] error:" + error.toString());
            throw error;
          });
      }


    return 0;
  }

  Future<int> syncSighting(Sighting sighting, {bool editing = false}) async {

    if (sighting != null) {

      Future<User> _user =  User.getCurrentUser();

      print("HERE#1" +sighting.toString());

      return _user.then((user){

        if(user != null) {

          //sighting.initProperties(user, editing);
          //print("[HERE] " + sighting.photoFileName);

          var _file = Sighting.getImageFile(sighting);

          var longitude = sighting.longitude != null ? sighting
              .longitude.toStringAsPrecision(Constants
              .gpsDecimalPrecision) : 0.0;

          var latitude = sighting.latitude != null ?  sighting
              .latitude.toStringAsPrecision(Constants
              .gpsDecimalPrecision) : 0.0;

          var altitude = sighting.altitude != null ? sighting
              .altitude.toStringAsPrecision(
              Constants.gpsDecimalPrecision) : 0.0;



          return _file.then((file) async {
            if (file != null) {
              //print("HERE");

              String fileName = basename(file.path);

              return syncFile(file, fileName).then((fid) async {
                if (fid == 0) return 0;

                UserSession currentSession = await UserSession
                    .getCurrentSession();

                String cookie = currentSession.sessionName + "=" +
                    currentSession.sessionID;
                String token = currentSession.token;

                String formattedDate = editing
                    ?
                DateFormat(Constants.apiNodeUpdateDateFormat).format(
                    DateTime.fromMillisecondsSinceEpoch(sighting.date.toInt()))
                    :
                DateFormat(Constants.apiDateFormat).format(
                    DateTime.fromMillisecondsSinceEpoch(sighting.date.toInt()));
                //String formattedDate = DateFormat(Constants.apiDateFormat).format(DateTime.fromMillisecondsSinceEpoch(sighting.date.toInt()));

                if (!editing) {

                  var speciesNID = sighting.speciesNid != null ? sighting.speciesNid.toString() : null;
                  var siteNID    = sighting.placeNID != null ? sighting.placeNID.toString() : null;

                  var type = (sighting.activityTagTid != null &&
                      sighting.activityTagTid != 0)
                      ? sighting.activityTagTid
                      : 0.toString();//"_none";


                  Map<String, dynamic> postBody = {
                    "title": sighting.title,
                    "type": "publication",
                    "uuid": sighting.uuid,
                    "uid": sighting.uid.toString(),
                    "status": 1.toString(),
                    "field_uuid": sighting.uuid,
                    "body": sighting.title,
                    "field_place_name": sighting.placeName,
                    "field_date": formattedDate,
                    "field_associated_species": speciesNID,//sighting.speciesNid.toString(),
                    "field_lat": latitude,// sighting.latitude.toString(),
                    "field_long": longitude,// sighting.longitude.toString(),
                    "field_altitude": altitude,// sighting.altitude.toString(),
                    "field_is_local": editing ? sighting.isLocal.toString() : 0
                        .toString(), //NO
                    "field_is_synced": editing
                        ? sighting.isSynced.toString()
                        : 1
                        .toString(), //YES
                    "field_count":  sighting.speciesCount != null ? sighting.speciesCount.toString() : 0,
                    "field_photo": fid.toString(),
                    "field_type": type,//sighting.activityTagTid.toString(),
                    //TODO Optimisation do not upload unchanged photo
                    "field_place_name_reference": siteNID,//sighting.placeNID.toString(),
                  };

                  /*String  postBody = "{";
                  postBody += " title : " +  sighting.title;
                  postBody += " uuid  : ${sighting.uuid},";
                  postBody += " uid   : ${sighting.uid.toString()},";
                  postBody += " status : 1,";
                  postBody += " field_uuid : ${sighting.uuid},";
                  postBody += " body : ${sighting.title},";
                  postBody += sighting.placeName != null ? " field_place_name : ${sighting.placeName}," : "";
                  postBody += " field_date: $formattedDate,";
                  postBody += sighting.speciesNid != null ? " field_associated_species : ${sighting.speciesNid}," : ""; //sighting.speciesNid.toString(),
                  postBody += " field_lat : ${sighting.latitude.toString()},";
                  postBody += " field_long : ${sighting.longitude.toString()},";
                  postBody += " field_altitude : ${sighting.altitude.toString()},";
                  postBody += " field_is_local : ${editing ? sighting.isLocal.toString() : 0},";
                  postBody += " field_is_synced : ${editing  ? sighting.isSynced.toString() : 1},";
                  postBody += " field_count : ${sighting.speciesCount.toString()},";
                  postBody += " field_photo : ${fid.toString()},";
                  //TODO Optimisation do not upload unchanged photo
                  postBody +=  sighting.placeNID != null ? " field_place_name_reference : ${sighting.placeNID}," : "";
                  postBody += " field_type : $type";//sighting.activityTagTid.toString(),
                  postBody += "}";*/

                  Map<String, String> postHeaders = {
                    "Content-Type": "application/json",
                    "Accept": "application/json",
                    "Cookie": cookie,
                    "X-CSRF-Token": token
                  };

                  // Create new sighting
                  return
                    _networkUtil.post(NEW_SIGHTING,
                      body: json.encode(postBody),
                      //body: body,
                      headers: postHeaders,
                    ).then((dynamic resultMap) async {
                      print("[REST_DATA::syncSighting()] new nid " +
                          resultMap.toString());

                      if (resultMap[RestData.errorKey] != null) {
                        throw new Exception(resultMap["error_msg"]);
                      }

                      String nidKey = "nid";
                      int nid = resultMap[nidKey];

                      return nid;
                    }).catchError((error) {
                      print(
                          "[REST_DATA::syncSighting()] creating sighting error:" +
                              error.toString());
                      throw error;
                    });

                } else {

                  var type = (sighting.activityTagTid != null &&
                      sighting.activityTagTid != 0)
                      ? sighting.activityTagTid
                      : "_none";

                  //var speciesNID = sighting.speciesNid != null ? sighting.speciesNid.toString() : "_none";
                  //var speciesNID = sighting.speciesNid != null ? sighting.speciesNid.toString() : 0;
                  //var siteNID    = sighting.placeNID != null ? sighting.placeNID.toString() : "_none";
                  var count      = sighting.speciesCount != null ? sighting.speciesCount : 0;

                  Map<String, String> putHeaders = {
                    "Content-Type": "application/x-www-form-urlencoded",
                    "Accept": "application/json",
                    "Cookie": cookie,
                    "X-CSRF-Token": token
                  };

                  var longitude = sighting.longitude != null ? sighting
                      .longitude.toStringAsPrecision(Constants
                      .gpsDecimalPrecision) : 0.0;

                  var latitude = sighting.latitude != null ?  sighting
                      .latitude.toStringAsPrecision(Constants
                      .gpsDecimalPrecision) : 0.0;

                  var altitude = sighting.altitude != null ? sighting
                      .altitude.toStringAsPrecision(
                      Constants.gpsDecimalPrecision) : 0.0;

                  /*String putBody = "title=${sighting
                      .title}&field_type[und][]=$type&field_place_name_reference[und][nid]=$siteNID&body[und][0][value]=${sighting
                      .title}&field_place_name[und][0][value]=${sighting
                      .placeName}&field_date[und][0][value][date]=$formattedDate&field_count[und][0][value]=${sighting
                      .speciesCount}&field_associated_species[und][nid]=$speciesNID&field_photo[und][0][fid]=$fid&field_long[und][0][value]=$longitude&field_lat[und][0][value]=$latitude&field_altitude[und][0][value]=$altitude";*/

                  String  putBody = "";
                  putBody += " title=" + sighting.title;
                  putBody += "&body=" +  sighting.title;
                  putBody += sighting.placeName != null ? "&field_place_name[und][0][value]=${sighting.placeName}" : "";
                  putBody += "&field_date[und][0][value][date]=$formattedDate";
                  putBody += sighting.speciesNid != null ? "&field_associated_species[und][nid]=${sighting.speciesNid}" : ""; //sighting.speciesNid.toString(),
                  putBody += "&field_lat[und][0][value]=$latitude";
                  putBody += "&field_long[und][0][value]=$longitude";
                  putBody += "&field_altitude[und][0][value]=$altitude";
                  putBody += "&field_count[und][0][value]=$count";
                  putBody += "&field_photo[und][0][fid]=${fid.toString()}";
                  //TODO Optimisation do not upload unchanged photo
                  putBody +=  sighting.placeNID != null ? "&field_place_name_reference[und][nid]=${sighting.placeNID}" : "";
                  putBody += "&field_type[und][]=$type";//sighting.activityTagTid.toString(),
                  putBody += "";


                  /*String putBody = "title=${sighting
                      .title}&field_type[und][]=$type&field_place_name_reference[und][nid]=$siteNID&body[und][0][value]=${sighting
                      .title}&field_place_name[und][0][value]=${sighting
                      .placeName}&field_date[und][0][value][date]=$formattedDate&field_count[und][0][value]=$count&field_associated_species[und][nid]=$speciesNID&field_photo[und][0][fid]=$fid&field_long[und][0][value]=$longitude&field_lat[und][0][value]=$latitude&field_altitude[und][0][value]=$altitude";*/

                  String nodeUpdateUrl = NODE_UPDATE_ENDPOINT +
                      sighting.nid.toString();
                  print("[Updating node at $nodeUpdateUrl]");
                  return

                    _networkUtil.put(nodeUpdateUrl,
                      body: putBody,
                      headers: putHeaders,
                      encoding: Encoding.getByName('utf-8'),
                    ).then((dynamic resultMap) {
                      print("[REST_DATA::syncSighting()] update" +
                          resultMap.toString());

                      if (resultMap[RestData.errorKey] != null) {
                        throw new Exception(resultMap["error_msg"]);
                      }

                      String nidKey = "nid";
                      int nid = int.parse(resultMap[nidKey]);
                      return nid;
                    }).catchError((error) {
                      print(
                          "[REST_DATA::syncSighting()] updating sighting error:" +
                              error.toString());
                      throw error;
                    });
                }
              });
            }

            return 0;
          }).catchError((error) {
            print("[Rest_data::syncSighting()] Exception " + error.toString());
            throw error;
          });

        }else{
          print("[REST_DATA::syncSighting()] Current user null");
        }

      });

      // Default image
      /*if(sighting.photoFileName == null || sighting.photoFileName.length == 0){
        Photograph defaultImage = await sighting.species.getPhotographObjectAtIndex(0);
        sighting.photoFileName = defaultImage.photoAssetPath(ext: Constants.imageType);
      }*/

    }

    return 0;
  }

  Future<bool> deleteSighting(Sighting sighting) async {
    if (sighting != null && sighting.nid != null) {
      UserSession currentSession = await UserSession.getCurrentSession();
      String cookie = currentSession.sessionName + "=" +
          currentSession.sessionID;
      String token = currentSession.token;

      Map<String, String> putHeaders = {
        "Content-Type": "application/json",
        //"application/x-www-form-urlencoded",
        "Accept": "application/json",
        "Cookie": cookie,
        "X-CSRF-Token": token
      };

      //String putBody = "field_is_deleted[und][0][value]=1";
      String nodeUpdateUrl = NODE_UPDATE_ENDPOINT + sighting.nid.toString();
      print("[Deleting node at $nodeUpdateUrl]");
      return _networkUtil.delete(nodeUpdateUrl,
        headers: putHeaders,
      ).then((dynamic resultMap) {
        print("[REST_DATA::syncSighting()] delete " + resultMap.toString());

        /*if (resultMap[RestData.errorKey] != null) {
          throw new Exception(resultMap["error_msg"]);
        }*/

        return resultMap[0] as bool;
      }).catchError((error) {
        print(
            "[REST_DATA::syncSighting()] deleting sighting error:" +
                error.toString());
        throw error;
      });
    }
    return false;
  }

  Future<List<Sighting>> getSightings(DateTime fromDate) async {

    Future<User> _user =  User.getCurrentUser();

    return _user.then((user) async {

      if (user != null) {

        UserSession currentSession = await UserSession
            .getCurrentSession();

        String cookie = currentSession.sessionName + "=" +
            currentSession.sessionID;
        String token = currentSession.token;

        String formattedDate = fromDate.toString();

        /*String formattedDate =
        DateFormat(Constants.searchDateFormat).format(
            DateTime.fromMillisecondsSinceEpoch(
                fromDate?.millisecondsSinceEpoch));*/

        //DateFormat(Constants.apiDateFormat).format(
        //    DateTime.fromMillisecondsSinceEpoch(sighting.date.toInt()));
        //String formattedDate = DateFormat(Constants.apiDateFormat).format(DateTime.fromMillisecondsSinceEpoch(sighting.date.toInt()));

        String params = "?";
        params += "uid=${user.uid}";
        params += (fromDate != null) ? "&from_date=$formattedDate" : "";

        Map<String, String> postHeaders = {
          "Content-Type": "application/x-www-form-urlencoded",
          "Accept": "application/json",
          "Cookie": cookie,
          "X-CSRF-Token": token
        };

        // get changed sighting from the specified date
        return _networkUtil.post(SERVICE_MY_SIGHTINGS + params,
            headers: postHeaders,
        ).then((dynamic resultMap) async {

            print("[REST_DATA::getSightings()] " +
                resultMap.toString());

            String lastSyncDate = DateTime.now().millisecondsSinceEpoch.toString();
            LOMSharedPreferences.setString(LOMSharedPreferences.lastSyncDateTime, lastSyncDate);

            /*if (resultMap[RestData.errorKey] != null) {
              throw new Exception(resultMap["error_msg"]);
            }*/

            return (resultMap[RestData.nodesKey] as List).map((jsonSighting) {

              return Sighting.fromMap(jsonSighting);

            }).toList();

        }).catchError((error) {

            print(
                "[REST_DATA::getSightings()] Getting sightings list error :" +
                    error.toString());
            throw error;

        });
      }

      return List();

    });

  }

  Future<int> syncComment(Comment comment, {bool editing = false}) async {
    if (comment != null) {
      UserSession currentSession = await UserSession.getCurrentSession();

      String cookie = currentSession.sessionName + "=" +
          currentSession.sessionID;
      String token = currentSession.token;



      if (!editing) {

        Map<String, String> postBody = {
          "body": comment.commentBody,
          "uuid": comment.uuid,
          "uid": comment.uid.toString(),
          "sighting_uuid": comment.sightingUUID,
          "nid": comment.nid.toString(),
          "status": "1",
          "subject": "",
          "synced": "1"
        };

        Map<String, String> postHeaders = {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Cookie": cookie,
          "X-CSRF-Token": token
        };

        // Create new comment
        return

          _networkUtil.post(NEW_COMMENT,
            body: json.encode(postBody),
            headers: postHeaders,
          ).then((dynamic resultMap) async {
            print("[REST_DATA::syncComment()] new cid " + resultMap.toString());

            if (resultMap[RestData.errorKey] != null) {
              throw new Exception(resultMap["error_msg"]);
            }

            String cidKey = "cid";
            int cid = resultMap[cidKey];

            return cid;
          }).catchError((error) {
            print(
                "[REST_DATA::syncComment()] creating comment error:" +
                    error.toString());
            throw error;
          });

      } else {

        Map<String, String> postHeaders = {
          "Content-Type": "application/x-www-form-urlencoded",
          "Accept": "application/json",
          "Cookie": cookie,
          "X-CSRF-Token": token
        };

        String postBody = "body=${comment.commentBody}&uuid=${comment.uuid}&status=${comment.status}&deleted=${comment.deleted}";

        String commentUpdateUrl = EDIT_COMMENT;
        print("[Updating comment at $commentUpdateUrl]");

        return

          _networkUtil.post(commentUpdateUrl,
            body: postBody,
            headers: postHeaders,
            encoding: Encoding.getByName('utf-8'),

          ).then((dynamic resultMap) {

            print("[REST_DATA::updateComment()] update" + resultMap.toString());

            if (resultMap[RestData.errorKey] != null) {
              throw new Exception(resultMap["error_msg"]);
            }

            String cidKey = "cid";
            int cid = resultMap[cidKey];
            return cid;

          }).catchError((error) {
            print(
                "[REST_DATA::updateComment()] updating comment :" +
                    error.toString());
            throw error;
          });
      }
    }

    return 0;
  }

}