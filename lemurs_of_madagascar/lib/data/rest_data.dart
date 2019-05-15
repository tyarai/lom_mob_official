
import 'dart:async';
import 'dart:convert';
import 'package:lemurs_of_madagascar/utils/network_util.dart';
import 'package:lemurs_of_madagascar/models/user.dart';
import 'package:lemurs_of_madagascar/utils/lom_shared_preferences.dart';

class RestData {

  static const  errorKey = "error";
  static const  formErrorKey = "form_errors"; // Used to track existing account created twice
  static const  userStructureKey = "user";



  NetworkUtil _networkUtil = NetworkUtil();

  //static const  SERVER               = "https://www.lemursofmadagascar.com/html";
  static const  SERVER               = "http://192.168.2.242";
  static const  LOGIN_ENDPOINT       = SERVER + "/lom_endpoint/api/v1/services/user/login.json";
  static const  LOGOUT_ENDPOINT      = SERVER + "/lom_endpoint/api/v1/services/user/logout.json";
  static const  REGISTER_ENDPOINT    = SERVER + "/lom_endpoint/api/v1/services/user/register.json";
  static const  FILE_ENDPOINT        = SERVER + "/lom_endpoint/api/v1/services/file.json";
  static const  NODE_ENDPOINT        = SERVER + "/lom_endpoint/api/v1/services/node.json";
  static const  NODE_UPDATE_ENDPOINT = SERVER + "/lom_endpoint/api/v1/services/node/";
  static const  ISCONNECTED_ENDPOINT = SERVER + "/lom_endpoint/api/v1/services/system/connect.json";
  static const  ALL_PUBLICATION_ENDPOINT = SERVER + "/all-publication-json";
  static const  MY_SIGHTINGS_ENDPOINT = SERVER + "/api/v1/list/sightings" ;// Misy parameters isLocal
  static const  ALL_MY_SIGHTINGS_ENDPOINT = SERVER + "/api/v1/list/all-my-sightings"; // Tsy misy parameter
  static const  MY_SIGHTINGS_MODIFIED_FROM = SERVER + "/api/v1/list/my-sightings-modified-from" ;
  static const  SERVICE_MY_SIGHTINGS = SERVER + "/lom_endpoint/api/v1/services/lom_sighting_services/changed_sightings"; //Parameters : 'uid' and 'from_date'
  static const  COUNT_SIGHTINGS = SERVER + "/lom_endpoint/api/v1/services/lom_sighting_services/count_sightings"; //Parameters : 'uid' (mandatory) and 'from_date' (optional)
  static const  RESET_SYNCED = SERVER + "/lom_endpoint/api/v1/services/lom_sighting_services/reset_synced"; //Parameters : 'uid' (mandatory) and 'synced_value' (optional)
  static const  NEW_SIGHTING = SERVER + "/lom_endpoint/api/v1/services/lom_sighting_services/new_sighting";
  static const  NEW_COMMENT = SERVER + "/lom_endpoint/api/v1/services/lom_sighting_services/new_comment";
  static const  NEW_ILLEGALACTIVITY = SERVER + "/lom_endpoint/api/v1/services/lom_illegal_activities_services/new_illegal_activity";
  static const  SYNC_ILLEGALACTIVITY_STATUS = SERVER + "/lom_endpoint/api/v1/services/lom_illegal_activities_services/update_status";
  static const  EDIT_COMMENT = SERVER + "/lom_endpoint/api/v1/services/lom_sighting_services/edit_comment";
  static const  CHANGED_COMMENTS = SERVER + "/lom_endpoint/api/v1/services/lom_sighting_services/changed_comments";
  static const  LIFELIST_ENDPOINT = SERVER + "/api/v1/list/my-lemur-life-list-json";
  static const  LIFELIST_ENDPOINT_MODIFIED_FROM = SERVER + "api/v1/list/my-lemur-life-list-modified-from";
  static const  LAST_LOGIN_DATE = SERVER + "login_date"; //Ijerena raha vao ni-installer-na ilay app
  static const  LAST_SYNC_DATE = SERVER + "last_sync_date";
  static const  LAST_SERVER_SYNC_DATE = SERVER + "last_server_sync_date";
  static const  UPDATE_TEXT = SERVER + "update_text";
  static const  UPDATE_SYNC_DATE = SERVER + "update_sync_date";
  static const  SPECIES_UPDATE_COUNT = SERVER + "species_update_count";
  static const  MAP_UPDATE_COUNT = SERVER + "map_update_count";
  static const  FAMILY_UPDATE_COUNT = SERVER + "family_update_count";
  static const  PHOTO_UPDATE_COUNT = SERVER + "photo_update_count";
  static const  PLACE_UPDATE_COUNT = SERVER + "place_update_count";
  static const  SERVER_IMAGE_PATH = SERVER + "/sites/default/files/";
//************ SETTINGS WEB SERVICE ******************//
  static const  SETTINGS_EXPORT_ENDPOINT = SERVER + "/lom_endpoint/api/v1/settings/lom_settings/export_settings"; // Misy param user_uid
  static const  SETTINGS_IMPORT_ENDPOINT = SERVER + "/lom_endpoint/api/v1/settings/lom_settings/import_settings" ;// Misy param user_uid, settings_name, settings_value
// ************* CHANGED NODES SERVICE (Species, Map, Photograph, Family, Places) *******
  static const  CHANGED_NODES = SERVER +  "/lom_endpoint/api/v1/services/lom_node_services/changed_nodes"; // Misy parama from_date


  Future<User> login(String userName, String passWord){

    print("login .....");

    Map<String,String> body = {
      "username": userName,
      "password": passWord
    };

    Map<String,String> headers = {
      "Content-Type": "application/json",
      "Accept": "application/json"
    };

    return
        _networkUtil.post(LOGIN_ENDPOINT,
        body: json.encode(body),
        headers: headers,
      ).then((dynamic resultMap) {

        //print("LOM :(login result): " + resultMap.toString());

        if(resultMap[RestData.errorKey] != null) {
          //print("#2");
          throw new Exception(resultMap["error_msg"]);
        }
        return new User.fromJSONMap(resultMap[userStructureKey],userSession: resultMap);

      });/* .catchError((LOMException lomException) {
        throw new lomException;
      });*/

  }

  Future<User> register(String userName, String passWord,String mail) {

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

        return new User(uid:int.parse(resultMap[User.uidKey]),name:userName,password:passWord);


      });/*.catchError((Object object) {

        return null;
        //throw new object;
    });*/


  }

  Future<bool> logOut() async {

    print("logout .....");

    String userName    = await LOMSharedPreferences.loadString(User.nameKey);
    String sessionName = await LOMSharedPreferences.loadString(User.sessionNameKey);
    String sessionID   = await LOMSharedPreferences.loadString(User.sessionIDKey);
    String token       = await LOMSharedPreferences.loadString(User.tokenKey);
    String cookie = sessionName + "=" + sessionID;

    if(userName.length == 0 || sessionName.length == 0 || sessionID.length == 0 || token.length == 0) return false;


    Map<String,String> body = {
      "username": userName
    };

    Map<String,String> headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Cookie": cookie,
      "X-CSRF-Token": token
    };

    return _networkUtil.post(LOGOUT_ENDPOINT,
        body: json.encode(body),
        headers: headers,
      ).then((dynamic resultMap) {


        /*LOMSharedPreferences.setString(User.nameKey,"");
        LOMSharedPreferences.setString(User.sessionNameKey,"");
        LOMSharedPreferences.setString(User.sessionIDKey,"");
        LOMSharedPreferences.setString(User.tokenKey,"");
        */

        User.clearSharedPreferences(); // Clear all shared preferences

      /*
        if(resultMap[RestData.errorKey] != null) {
          print("#2");
          throw new Exception(resultMap["error_msg"]);
        }*/

        print("LOM :(logout result): " + resultMap.toString());
        return true;

      });/*.catchError((Object error) {
          return false;
      });*/

  }

}

