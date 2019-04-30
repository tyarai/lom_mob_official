
import 'package:lemurs_of_madagascar/utils/network_util.dart';
import 'package:lemurs_of_madagascar/models/user.dart';

class RestData {

  NetworkUtil _networkUtil = NetworkUtil();

  static final SERVER               = "https://www.lemursofmadagascar.com/html";

  static final LOGIN_ENDPOINT       = SERVER + "/lom_endpoint/api/v1/services/user/login.json";
  static final LOGOUT_ENDPOINT      = SERVER + "/lom_endpoint/api/v1/services/user/logout.json";
  static final REGISTER_ENDPOINT    = SERVER + "/lom_endpoint/api/v1/services/user/register.json";
  static final FILE_ENDPOINT        = SERVER + "/lom_endpoint/api/v1/services/file.json";
  static final NODE_ENDPOINT        = SERVER + "/lom_endpoint/api/v1/services/node.json";
  static final NODE_UPDATE_ENDPOINT = SERVER + "/lom_endpoint/api/v1/services/node/";
  static final ISCONNECTED_ENDPOINT = SERVER + "/lom_endpoint/api/v1/services/system/connect.json";
  static final ALL_PUBLICATION_ENDPOINT = SERVER + "/all-publication-json";
  static final MY_SIGHTINGS_ENDPOINT = SERVER + "/api/v1/list/sightings" ;// Misy parameters isLocal
  static final ALL_MY_SIGHTINGS_ENDPOINT = SERVER + "/api/v1/list/all-my-sightings"; // Tsy misy parameter
  static final MY_SIGHTINGS_MODIFIED_FROM = SERVER + "/api/v1/list/my-sightings-modified-from" ;
  static final SERVICE_MY_SIGHTINGS = SERVER + "/lom_endpoint/api/v1/services/lom_sighting_services/changed_sightings"; //Parameters : 'uid' and 'from_date'
  static final COUNT_SIGHTINGS = SERVER + "/lom_endpoint/api/v1/services/lom_sighting_services/count_sightings"; //Parameters : 'uid' (mandatory) and 'from_date' (optional)
  static final RESET_SYNCED = SERVER + "/lom_endpoint/api/v1/services/lom_sighting_services/reset_synced"; //Parameters : 'uid' (mandatory) and 'synced_value' (optional)
  static final NEW_SIGHTING = SERVER + "/lom_endpoint/api/v1/services/lom_sighting_services/new_sighting";
  static final NEW_COMMENT = SERVER + "/lom_endpoint/api/v1/services/lom_sighting_services/new_comment";
  static final NEW_ILLEGALACTIVITY = SERVER + "/lom_endpoint/api/v1/services/lom_illegal_activities_services/new_illegal_activity";
  static final SYNC_ILLEGALACTIVITY_STATUS = SERVER + "/lom_endpoint/api/v1/services/lom_illegal_activities_services/update_status";
  static final EDIT_COMMENT = SERVER + "/lom_endpoint/api/v1/services/lom_sighting_services/edit_comment";
  static final CHANGED_COMMENTS = SERVER + "/lom_endpoint/api/v1/services/lom_sighting_services/changed_comments";
  static final LIFELIST_ENDPOINT = SERVER + "/api/v1/list/my-lemur-life-list-json";
  static final LIFELIST_ENDPOINT_MODIFIED_FROM = SERVER + "api/v1/list/my-lemur-life-list-modified-from";
  static final LAST_LOGIN_DATE = SERVER + "login_date"; //Ijerena raha vao ni-installer-na ilay app
  static final LAST_SYNC_DATE = SERVER + "last_sync_date";
  static final LAST_SERVER_SYNC_DATE = SERVER + "last_server_sync_date";
  static final UPDATE_TEXT = SERVER + "update_text";
  static final UPDATE_SYNC_DATE = SERVER + "update_sync_date";
  static final SPECIES_UPDATE_COUNT = SERVER + "species_update_count";
  static final MAP_UPDATE_COUNT = SERVER + "map_update_count";
  static final FAMILY_UPDATE_COUNT = SERVER + "family_update_count";
  static final PHOTO_UPDATE_COUNT = SERVER + "photo_update_count";
  static final PLACE_UPDATE_COUNT = SERVER + "place_update_count";
  static final SERVER_IMAGE_PATH = SERVER + "/sites/default/files/";
//************ SETTINGS WEB SERVICE ******************//
  static final SETTINGS_EXPORT_ENDPOINT = SERVER + "/lom_endpoint/api/v1/settings/lom_settings/export_settings"; // Misy param user_uid
  static final SETTINGS_IMPORT_ENDPOINT = SERVER + "/lom_endpoint/api/v1/settings/lom_settings/import_settings" ;// Misy param user_uid, settings_name, settings_value
// ************* CHANGED NODES SERVICE (Species, Map, Photograph, Family, Places) *******
  static final CHANGED_NODES = SERVER +  "/lom_endpoint/api/v1/services/lom_node_services/changed_nodes"; // Misy parama from_date


  Future<User> login(String userName, String password){
    return new Future.value(User(name:userName));
  }

}