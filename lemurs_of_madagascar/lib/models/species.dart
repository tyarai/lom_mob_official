import 'package:lemurs_of_madagascar/models/photograph.dart';

class Species {

  static String idKey          = "_species_id";
  static String profilePhotoKey = "_profile_photograph_id";
  static String titleKey       = "_title";
  static String familyIDKey    = "_family_id";
  static String mgKey          = "_malagasy";
  static String frKey          = "_french";
  static String enKey          = "_english";
  static String otherEnKey     = "_other_english";
  static String deKey          = "_german";
  static String identificationKey = "_identification";
  static String historyKey     = "_natural_history";
  static String rangeKey       = "_geographic_range";
  static String statusKey      = "_status";
  static String sitesKey       = "_where_to_see_it";
  static String mapIDKey       = "_map";
  static String photoIDsKey    = "_specie_photograph";


  int id;
  String title;
  int profilePhotoID;
  int familyID;
  String malagasy;
  String german;
  String english;
  String otherEnglish;
  String french;
  String identification;
  String history;
  String range;
  String status;
  String sites;
  int mapID;
  String photoIDs;


  Photograph profilePhotograph;

  Species({
    this.title,
    this.profilePhotoID,
    this.familyID,
    this.malagasy,
    this.german,
    this.english,
    this.otherEnglish,
    this.french,
    this.identification,
    this.history,
    this.range,
    this.status,
    this.sites,
    this.mapID,
    this.photoIDs
  });

  Species.withID({
    this.id,
    this.title,
    this.profilePhotoID,
    this.familyID,
    this.malagasy,
    this.german,
    this.english,
    this.otherEnglish,
    this.french,
    this.identification,
    this.history,
    this.range,
    this.status,
    this.sites,
    this.mapID,
    this.photoIDs
  });


  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();

    if(id != null){
      map[idKey] = this.id;
    }

    map[titleKey]         = this.title;
    map[profilePhotoKey]  = this.profilePhotoID;
    map[familyIDKey]      = this.familyID;
    map[mgKey]            = this.malagasy;
    map[enKey]            = this.english;
    map[otherEnKey]       = this.otherEnglish;
    map[frKey]            = this.french;
    map[deKey]            = this.german;
    map[identificationKey]= this.identification;
    map[statusKey]        = this.status;
    map[rangeKey]         = this.range;
    map[historyKey]       = this.history;
    map[sitesKey]         = this.sites;
    map[mapIDKey]         = this.mapID;
    map[photoIDsKey]      = this.profilePhotoID;

    return map;
  }

  Species.fromMap(Map<String,dynamic> map) {

    //this.id               = int.parse(map[idKey]);
    this.title            = map[titleKey]         ;
    //this.profilePhotoID   = int.parse(map[profilePhotoKey]);
    //this.familyID         = int.parse(map[familyIDKey]);
    this.malagasy         = map[mgKey]             ;
    this.english          = map[enKey]             ;
    this.otherEnglish     = map[otherEnKey]        ;
    this.french           = map[frKey]             ;
    this.german           = map[deKey]             ;
    this.identification   = map[identificationKey] ;
    this.status           = map[statusKey]         ;
    this.range            = map[rangeKey]          ;
    this.history          = map[historyKey]        ;
    this.sites            = map[sitesKey]          ;
    //this.mapID            = int.parse(map[mapIDKey]);
    this.photoIDs         = map[photoIDsKey]       ;

  }



}


