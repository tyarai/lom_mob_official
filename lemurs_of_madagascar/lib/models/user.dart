import 'package:lemurs_of_madagascar/utils/lom_shared_preferences.dart';

class User {


  static String uidKey = "uid";
  static String nameKey = "name";
  static String mailKey = "mail";
  static String themeKey = "theme";
  static String signatureKey = "signature";
  static String signatureFormatKey = "signatureFormat";
  static String createdKey = "created";
  static String accessKey = "access";
  static String loginKey = "login";
  static String statusKey = "statusKey";
  static String timezoneKey = "timezone";
  static String languageKey = "language";
  static String uuidKey = "uuid";
  static String passKey = "pass";


  static String sessionIDKey   = "sessid";
  static String sessionNameKey = "session_name";
  static String tokenKey       = "token";


  int uid;
  String name;
  String mail;
  String theme;
  String signature;
  String signatureFormat;
  int created;
  int access;
  int login;
  int status;
  String timezone;
  String language;
  String uuid;
  String password;

  String sessionID="";
  String sessionName="";
  String token="";

  User({this.uid,this.name,this.password,this.mail,this.theme,this.signature,this.signatureFormat,this.created,this.access,this.login,this.status,this.timezone,this.language,this.uuid,this.sessionID,this.sessionName,this.token});

  User.fromJSONMap(dynamic userObj,{dynamic userSession}){

    if(userObj != null) {
      this.uid = int.parse(userObj[uidKey]);
      this.name = userObj[nameKey];
      this.mail = userObj[mailKey];
      this.theme = userObj[themeKey];
      this.signature = userObj[signatureKey];
      this.signatureFormat = userObj[signatureFormatKey];
      this.created = int.parse(userObj[createdKey]);
      this.access = int.parse(userObj[accessKey]);
      this.login = userObj[loginKey];
      this.status = userObj[statusKey];
      this.timezone = userObj[timezoneKey];
      this.language = userObj[languageKey];
      this.uuid = userObj[uuidKey];

      this.saveToSharedPreferences();
    }

    if(userSession != null) {
      this.sessionName = userSession[sessionNameKey];
      this.sessionID = userSession[sessionIDKey];
      this.token = userSession[tokenKey];

      LOMSharedPreferences.setString(User.sessionIDKey, this.sessionID);
      LOMSharedPreferences.setString(User.sessionNameKey, this.sessionName);
      LOMSharedPreferences.setString(User.tokenKey, this.token);

      LOMSharedPreferences.loadString(User.tokenKey).then((value){
        print( "--->" + value );
      });
    }

  }

  User.fromMap(dynamic userObj){

    if(userObj != null) {
      this.uid = int.parse(userObj[uidKey]);
      this.name = userObj[nameKey];
      this.mail = userObj[mailKey];
      this.theme = userObj[themeKey];
      this.signature = userObj[signatureKey];
      this.signatureFormat = userObj[signatureFormatKey];
      this.created = int.parse(userObj[createdKey]);
      this.access = int.parse(userObj[accessKey]);
      this.login = userObj[loginKey];
      this.status = userObj[statusKey];
      this.timezone = userObj[timezoneKey];
      this.language = userObj[languageKey];
      this.uuid = userObj[uuidKey];
    }


  }


  void saveToSharedPreferences(){
    LOMSharedPreferences.setString(User.uidKey, this.uid.toString());
    LOMSharedPreferences.setString(User.nameKey, this.name);
    LOMSharedPreferences.setString(User.mailKey, this.mail);
    LOMSharedPreferences.setString(User.themeKey, this.theme);
    LOMSharedPreferences.setString(User.signatureKey, this.signature);
    LOMSharedPreferences.setString(User.signatureFormatKey, this.signatureFormat);
    LOMSharedPreferences.setString(User.createdKey, this.created.toString());
    LOMSharedPreferences.setString(User.accessKey, this.access.toString());
    LOMSharedPreferences.setString(User.loginKey, this.login.toString());
    LOMSharedPreferences.setString(User.statusKey, this.status.toString());
    LOMSharedPreferences.setString(User.timezoneKey, this.timezone);
    LOMSharedPreferences.setString(User.languageKey, this.language);
    LOMSharedPreferences.setString(User.uuidKey, this.uuid);
  }


  Map<String,dynamic> toMap(){
    var map = Map<String,dynamic>();
      map[uidKey]=  this.uid.toString();
      map[nameKey]=this.name;
      map[mailKey]=this.mail;
      map[themeKey]=this.theme;
      map[signatureKey]=this.signature;
      map[signatureFormatKey]=this.signatureFormat;
      map[createdKey]=this.created;
      map[accessKey]=this.access;
      map[loginKey]=this.login;
      map[statusKey]=this.status;
      map[timezoneKey]=this.timezone;
      map[languageKey]=this.language;
      map[uuidKey]=this.uuid;
    return map;
  }



}