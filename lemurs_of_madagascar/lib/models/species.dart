import 'package:lemurs_of_madagascar/models/photograph.dart';
import 'package:lemurs_of_madagascar/database/photograph_database_helper.dart';


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


  String tempImage = "assets/images/Lepilemur-petteri.jpg";
  String _imageFile;

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
  }){
    _loadImageFile();
  }

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
  }){
    _loadImageFile();
  }


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

    this.id               = map[idKey];
    this.title            = map[titleKey]         ;
    this.profilePhotoID   = map[profilePhotoKey];
    this.familyID         = map[familyIDKey];
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
    this.mapID            = map[mapIDKey];
    this.photoIDs         = map[photoIDsKey]       ;

    _loadImageFile();


  }

  Species.fromSpecies(Species species) {

    this.id               = species.id;
    this.title            = species.title;
    this.profilePhotoID   = species.profilePhotoID;
    this.familyID         = species.familyID;
    this.malagasy         = species.malagasy             ;
    this.english          = species.english             ;
    this.otherEnglish     = species.otherEnglish        ;
    this.french           = species.french             ;
    this.german           = species.german             ;
    this.identification   = species.identification ;
    this.status           = species.status         ;
    this.range            = species.range         ;
    this.history          = species.history        ;
    this.sites            = species.sites         ;
    this.mapID            = species.mapID;
    this.photoIDs         = species.photoIDs;

    _loadImageFile();


  }


  String get imageFile =>  _imageFile ;

  set imageFile(String value){
    this._imageFile = "assets/images/" +  value + ".jpg";
  }


  _loadImageFile() async {


    if(this.profilePhotoID != null) {
      PhotographDatabaseHelper photographDatabaseHelper = PhotographDatabaseHelper();
      Photograph futurePhoto =  await photographDatabaseHelper.getPhotographWithID(id:this.profilePhotoID);
      this.imageFile = futurePhoto.photograph ;

    }else{
      this.imageFile  = "83";
    }

  }

}


