import 'package:lemurs_of_madagascar/models/photograph.dart';
import 'package:lemurs_of_madagascar/models/species_map.dart';
import 'package:lemurs_of_madagascar/database/photograph_database_helper.dart';
import 'package:lemurs_of_madagascar/database/speciesmap_database_helper.dart';
import 'package:flutter/material.dart';
import 'package:lemurs_of_madagascar/utils/constants.dart';


enum SpeciesImageClipperType {
  rectangular,
  oval
}

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
  static String statusKey      = "_conservation_status";
  static String sitesKey       = "_where_to_see_it";
  static String mapIDKey       = "_map";
  static String photoIDsKey    = "_specie_photograph";


  String tempImage = "assets/images/Lepilemur-petteri.jpg";
  String _imageFile;
  String _mapFileName;

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


  //Photograph profilePhotograph;



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
    _loadImageFiles();
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
    _loadImageFiles();
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

    _loadImageFiles();


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

    _loadImageFiles();


  }


  String get imageFile    =>  _imageFile ;
  String get mapFileName  =>  _mapFileName ;

  set imageFile(String value){
    this._imageFile = "assets/images/" +  value + ".jpg";
  }

  set mapFileName(String value){
    this._mapFileName = value;
  }


  _loadImageFiles() async {

    this.imageFile  = "placeholder";
    this._mapFileName = "placeholder";

    if(this.profilePhotoID != null && this.mapID != null) {

      // Load profile image
      PhotographDatabaseHelper photographDatabaseHelper = PhotographDatabaseHelper();
      Photograph futurePhoto =  await photographDatabaseHelper.getPhotographWithID(id:this.profilePhotoID);
      this.imageFile = futurePhoto.photograph ;

      // Load map image
      SpeciesMapDatabaseHelper speciesMapDatabaseHelper = SpeciesMapDatabaseHelper();
      SpeciesMap futureMap =  await speciesMapDatabaseHelper.getSpeciesMapWithID(id:this.mapID);
      this._mapFileName = futureMap.fileName;




    }


  }

  Widget getMap(){

    Widget map;

    if(this._mapFileName != null){
      //print("map file :" + this._mapFileName);
      map = Image.asset("assets/images/" + this._mapFileName);
      if(map == null) print ("MAP NULL");
    }

      return map;
  }


  static Widget buildLemurPhoto(Species species,{double width = Constants.listViewImageWidth,double height = Constants.listViewImageHeight, SpeciesImageClipperType imageClipper = SpeciesImageClipperType.rectangular}) {

      Widget widget;
      BorderRadius _borderRadius;

      switch (imageClipper) {

        case SpeciesImageClipperType.rectangular :{

          _borderRadius = BorderRadius.circular(Constants.speciesImageBorderRadius);
          widget = Container(
              child: ClipRRect(
                  borderRadius: _borderRadius,
                  child: Species.loadHeroImage(species,width: width,height: height)));

          break;
        }
        case SpeciesImageClipperType.oval :{
          widget = Container(
              child: ClipOval(
                  child: Species.loadHeroImage(species)));
          break;
        }
      }

      return widget;
  }

  static Widget loadHeroImage(Species species,
      {double width = Constants.listViewImageWidth,
        double height = Constants.listViewImageWidth}) {
    return Hero(
        tag: species.imageFile + species.id.toString(),
        child: Image.asset(
          species.imageFile,
          width: width,
          height: height,
        ));
  }

  static Widget loadHeroTitle(Species species,{TextStyle style = Constants.speciesTitleStyle}) {
    return Hero(
        tag: species.title + species.id.toString(),
        child: Material(
          color: Colors.transparent,
          child:Text(species.title,style:style))
      );
  }


  static Widget buildTextInfo(Species species,{bool showMalagasy = true,CrossAxisAlignment crossAlignment = CrossAxisAlignment.start}) {
    return Expanded(
      child: Column(
          crossAxisAlignment: crossAlignment,
          children: <Widget>[
            Species.loadHeroTitle(species),
            Container(height: 10),
            showMalagasy ?
            Material(
                color: Colors.transparent,
                child:
              Text(species.malagasy,
                style: TextStyle(fontSize: Constants.subTitleFontSize))) : Container(),
          ]),
    );
  }

  static Widget buildInfo(String info,{TextStyle style = Constants.defaultTextStyle, CrossAxisAlignment crossAlignment = CrossAxisAlignment.start, MainAxisAlignment mainAlignment = MainAxisAlignment.start}) {
    return Expanded(
      child: Column(
          crossAxisAlignment: crossAlignment,
          mainAxisAlignment: mainAlignment,
          children: <Widget>[
            Text(info,style : style),
          ]),
    );
  }

  static Widget buildTitle(Species species) {
    return Expanded(
      child: Text(species.title, style: TextStyle(fontSize: 18.0)),
    );
  }

  static Widget buildSubTitle(Species species) {
    return Expanded(
      child: Text(species.malagasy),
    );
  }


}


