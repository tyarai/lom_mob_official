
import 'package:lemurs_of_madagascar/utils/lom_shared_preferences.dart';

class UserSession {

  static String sessionIDKey   = "sessid";
  static String sessionNameKey = "session_name";
  static String tokenKey       = "token";
  static const dateKey         = "date";


  String sessionID ="";
  String sessionName ="";
  String token ="";
  int startDate; //TimeStamp

  UserSession(this.token,this.sessionID,this.sessionName,this.startDate);

  UserSession.fromJSONMap(dynamic obj){
    if(obj != null) {
      this.token      = obj[tokenKey];
      this.sessionName = obj[sessionNameKey];
      this.sessionID = obj[sessionIDKey];
      this.startDate  = DateTime.now().millisecondsSinceEpoch;
    }
  }

  static Future<bool> startSession(UserSession session) async {
    if(session != null){
      try{
        await LOMSharedPreferences.setString(UserSession.tokenKey, session.token);
        await LOMSharedPreferences.setString(UserSession.sessionIDKey, session.sessionID);
        await LOMSharedPreferences.setString(UserSession.sessionNameKey, session.sessionName);
        await LOMSharedPreferences.setString(UserSession.dateKey, session.startDate.toString());
        return true;
      }catch(e){
        print("[UserSession startSession()] ${e.toString()}");
      }
    }
    return false;
  }

  static Future<bool> closeCurrentSession()  async {
    try{
      await LOMSharedPreferences.setString(UserSession.tokenKey, "");
      await LOMSharedPreferences.setString(UserSession.sessionIDKey, "");
      await LOMSharedPreferences.setString(UserSession.sessionNameKey, "");
      await LOMSharedPreferences.setString(UserSession.dateKey, "");
      return true;
    }catch(e){
      print("[UserSession closeCurrentSession()] ${e.toString()}");
    }
    return false;
  }

  static Future<UserSession> getCurrentSession() async {
    try {
      var token = await LOMSharedPreferences.loadString(UserSession.tokenKey) ?? "";
      var sessionID = await LOMSharedPreferences.loadString(UserSession.sessionIDKey) ?? "";
      var sessionName = await LOMSharedPreferences.loadString(UserSession.sessionNameKey) ?? "";
      var date = await LOMSharedPreferences.loadString(UserSession.dateKey) ?? "";
      return UserSession(token, sessionID,sessionName,int.parse(date));
    }catch(e){
      print("[UserSession getCurrentsession()] ${e.toString()}");
    }
    return null;
  }
}