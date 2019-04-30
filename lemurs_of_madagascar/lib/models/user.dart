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

  User({this.uid,this.name,this.mail,this.theme,this.signature,this.signatureFormat,this.created,this.access,this.login,this.status,this.timezone,this.language,this.uuid});

  User.fromMap(dynamic obj){
    this.uid            = int.parse(obj[uidKey]);
    this.name           = obj[nameKey];
    this.mail           = obj[mailKey];
    this.theme          = obj[themeKey];
    this.signature      = obj[signatureKey];
    this.signatureFormat = obj[signatureFormatKey];
    this.created        = obj[createdKey];
    this.access         = obj[accessKey];
    this.login          = obj[loginKey];
    this.status         = obj[statusKey];
    this.timezone       = obj[timezoneKey];
    this.language       = obj[languageKey];
    this.uuid           = obj[uuidKey];

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