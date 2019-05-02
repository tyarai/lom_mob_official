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


  static String sessionIDKey   = "sessid";
  static String sessionNameKey = "session_name";
  static String tokenKey       = "token";


  int uid;
  String name;
  String mail;
  String theme;
  String signature;
  String signatureFormat;
  String created;
  String access;
  String login;
  String status;
  String timezone;
  String language;
  String uuid;

  String sessionID="";
  String sessionName="";
  String token="";

  User({this.uid,this.name,this.mail,this.theme,this.signature,this.signatureFormat,this.created,this.access,this.login,this.status,this.timezone,this.language,this.uuid,this.sessionID,this.sessionName,this.token});

  User.fromMap(dynamic userObj,{dynamic userSession}){
    this.uid            = int.parse(userObj[uidKey]);
    this.name           = userObj[nameKey];
    this.mail           = userObj[mailKey];
    this.theme          = userObj[themeKey];
    this.signature      = userObj[signatureKey];
    this.signatureFormat = userObj[signatureFormatKey];
    this.created        = userObj[createdKey];
    this.access         = userObj[accessKey];
    this.login          = userObj[loginKey];
    this.status         = userObj[statusKey];
    this.timezone       = userObj[timezoneKey];
    this.language       = userObj[languageKey];
    this.uuid           = userObj[uuidKey];

    if(userSession != null) {
      this.sessionName = userSession[sessionNameKey];
      this.sessionID = userSession[sessionIDKey];
      this.token = userSession[tokenKey];
    }

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